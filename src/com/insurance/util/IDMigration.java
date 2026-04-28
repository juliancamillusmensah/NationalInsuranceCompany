package com.insurance.util;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class IDMigration {

    public static void main(String[] args) {

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Starting Database Migration for String IDs...");
            stmt.execute("PRAGMA foreign_keys=OFF;");
            conn.setAutoCommit(false);

            // 1. Fetch old Roles and generate new String IDs (we'll just use the role_name upper cased as ID)
            Map<Integer, String> roleMap = new HashMap<>();
            try (ResultSet rs = stmt.executeQuery("SELECT id, role_name FROM roles")) {
                while (rs.next()) {
                    int oldId = rs.getInt("id");
                    String newId = "ROLE_" + rs.getString("role_name").toUpperCase().replace(" ", "_");
                    roleMap.put(oldId, newId);
                }
            }
            if (!roleMap.isEmpty()) System.out.println("Mapped " + roleMap.size() + " roles.");

            // 2. Fetch old Accounts and generate UUIDs
            Map<Integer, String> accountMap = new HashMap<>();
            try (ResultSet rs = stmt.executeQuery("SELECT id FROM Account")) {
                while (rs.next()) {
                    int oldId = rs.getInt("id");
                    String newId = "ACC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                    accountMap.put(oldId, newId);
                }
            }
            if (!accountMap.isEmpty()) System.out.println("Mapped " + accountMap.size() + " accounts.");

            // 3. Create NEW tables with TEXT instead of INTEGER for IDs
            createNewTables(stmt);

            // 4. Migrate Data
            migrateRoles(conn, roleMap);
            migrateAccounts(conn, accountMap, roleMap);
            migrateCompanyAdmins(conn, accountMap);
            migrateCustomerPolicies(conn, accountMap);
            migratePasswords(conn, accountMap);
            migrateTransactions(conn, accountMap);
            migrateAccountPhone(conn, accountMap);
            migrateNotifications(conn, accountMap);
            migrateClaims(conn, accountMap);
            migrateRolePermissions(conn, roleMap);
            migrateSystemLogs(conn, accountMap);

            // 5. Drop old tables, rename new tables
            dropOldTables(stmt);
            renameNewTables(stmt);

            conn.commit();
            stmt.execute("PRAGMA foreign_keys=ON;");
            System.out.println("Migration Completed Successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Migration Failed! Rolling back...");
        }
    }

    private static void createNewTables(Statement stmt) throws SQLException {
        stmt.execute("CREATE TABLE roles_new (id TEXT PRIMARY KEY, role_name TEXT NOT NULL UNIQUE, description TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP)");
        stmt.execute("CREATE TABLE Account_new (id TEXT PRIMARY KEY, full_name TEXT NOT NULL, email TEXT NOT NULL UNIQUE, role_id TEXT NOT NULL, status TEXT DEFAULT 'active', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, password TEXT, FOREIGN KEY (role_id) REFERENCES roles(id))");
        stmt.execute("CREATE TABLE company_admins_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, company_id INTEGER NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES Account(id) ON DELETE CASCADE, FOREIGN KEY (company_id) REFERENCES insurance_companies(id) ON DELETE CASCADE, UNIQUE (user_id, company_id))");
        stmt.execute("CREATE TABLE customer_policies_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, policy_id INTEGER NOT NULL, start_date DATE NOT NULL, end_date DATE, policy_status TEXT DEFAULT 'active', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES Account(id), FOREIGN KEY (policy_id) REFERENCES policies(id))");
        stmt.execute("CREATE TABLE passwords_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, password_hash TEXT NOT NULL, reset_token TEXT, token_expires_at DATETIME, last_changed_at DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES Account(id))");
        stmt.execute("CREATE TABLE transactions_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, policy_id INTEGER NOT NULL, amount DECIMAL(10,2) NOT NULL, transaction_type TEXT, payment_method TEXT, payment_status TEXT DEFAULT 'pending', transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES Account(id), FOREIGN KEY (policy_id) REFERENCES policies(id))");
        stmt.execute("CREATE TABLE AccountPhone_new (id INTEGER PRIMARY KEY AUTOINCREMENT, account_id TEXT NOT NULL, phone_number TEXT NOT NULL, FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE)");
        stmt.execute("CREATE TABLE notifications_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, title TEXT, message TEXT, type TEXT, is_read INTEGER DEFAULT 0, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)");
        stmt.execute("CREATE TABLE claims_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, policy_id INTEGER NOT NULL, claim_amount DECIMAL(10,2) NOT NULL, description TEXT, incident_date TEXT, status TEXT DEFAULT 'Pending', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(user_id) REFERENCES Account(id), FOREIGN KEY(policy_id) REFERENCES policies(id))");
        stmt.execute("CREATE TABLE role_permissions_new (role_id TEXT, permission_id INTEGER, PRIMARY KEY(role_id, permission_id))");
        stmt.execute("CREATE TABLE system_logs_new (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, activity TEXT, details TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, type TEXT, impact TEXT)");
    }

    private static void migrateRoles(Connection conn, Map<Integer, String> roleMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM roles"); PreparedStatement ps = conn.prepareStatement("INSERT INTO roles_new (id, role_name, description, created_at, updated_at) VALUES (?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setString(1, roleMap.get(rs.getInt("id")));
                ps.setString(2, rs.getString("role_name"));
                ps.setString(3, rs.getString("description"));
                ps.setString(4, rs.getString("created_at"));
                ps.setString(5, rs.getString("updated_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateAccounts(Connection conn, Map<Integer, String> accountMap, Map<Integer, String> roleMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM Account"); PreparedStatement ps = conn.prepareStatement("INSERT INTO Account_new (id, full_name, email, role_id, status, created_at, updated_at, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setString(1, accountMap.get(rs.getInt("id")));
                ps.setString(2, rs.getString("full_name"));
                ps.setString(3, rs.getString("email"));
                ps.setString(4, roleMap.get(rs.getInt("role_id")));
                ps.setString(5, rs.getString("status"));
                ps.setString(6, rs.getString("created_at"));
                ps.setString(7, rs.getString("updated_at"));
                ps.setString(8, rs.getString("password"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateCompanyAdmins(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM company_admins"); PreparedStatement ps = conn.prepareStatement("INSERT INTO company_admins_new (id, user_id, company_id, created_at) VALUES (?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("user_id")));
                ps.setInt(3, rs.getInt("company_id"));
                ps.setString(4, rs.getString("created_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateCustomerPolicies(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM customer_policies"); PreparedStatement ps = conn.prepareStatement("INSERT INTO customer_policies_new (id, user_id, policy_id, start_date, end_date, policy_status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("user_id")));
                ps.setInt(3, rs.getInt("policy_id"));
                ps.setString(4, rs.getString("start_date"));
                ps.setString(5, rs.getString("end_date"));
                ps.setString(6, rs.getString("policy_status"));
                ps.setString(7, rs.getString("created_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migratePasswords(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM passwords"); PreparedStatement ps = conn.prepareStatement("INSERT INTO passwords_new (id, user_id, password_hash, reset_token, token_expires_at, last_changed_at) VALUES (?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("user_id")));
                ps.setString(3, rs.getString("password_hash"));
                ps.setString(4, rs.getString("reset_token"));
                ps.setString(5, rs.getString("token_expires_at"));
                ps.setString(6, rs.getString("last_changed_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateTransactions(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM transactions"); PreparedStatement ps = conn.prepareStatement("INSERT INTO transactions_new (id, user_id, policy_id, amount, transaction_type, payment_method, payment_status, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("user_id")));
                ps.setInt(3, rs.getInt("policy_id"));
                ps.setDouble(4, rs.getDouble("amount"));
                ps.setString(5, rs.getString("transaction_type"));
                ps.setString(6, rs.getString("payment_method"));
                ps.setString(7, rs.getString("payment_status"));
                ps.setString(8, rs.getString("transaction_date"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateAccountPhone(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM AccountPhone"); PreparedStatement ps = conn.prepareStatement("INSERT INTO AccountPhone_new (id, account_id, phone_number) VALUES (?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("account_id")));
                ps.setString(3, rs.getString("phone_number"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateNotifications(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM notifications"); PreparedStatement ps = conn.prepareStatement("INSERT INTO notifications_new (id, user_id, title, message, type, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                String uId = rs.getString("user_id");
                if (uId != null) uId = accountMap.getOrDefault(Integer.parseInt(uId), uId);
                ps.setString(2, uId);
                ps.setString(3, rs.getString("title"));
                ps.setString(4, rs.getString("message"));
                ps.setString(5, rs.getString("type"));
                ps.setInt(6, rs.getInt("is_read"));
                ps.setString(7, rs.getString("created_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateClaims(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM claims"); PreparedStatement ps = conn.prepareStatement("INSERT INTO claims_new (id, user_id, policy_id, claim_amount, description, incident_date, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                ps.setString(2, accountMap.get(rs.getInt("user_id")));
                ps.setInt(3, rs.getInt("policy_id"));
                ps.setDouble(4, rs.getDouble("claim_amount"));
                ps.setString(5, rs.getString("description"));
                ps.setString(6, rs.getString("incident_date"));
                ps.setString(7, rs.getString("status"));
                ps.setString(8, rs.getString("created_at"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateRolePermissions(Connection conn, Map<Integer, String> roleMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM role_permissions"); PreparedStatement ps = conn.prepareStatement("INSERT INTO role_permissions_new (role_id, permission_id) VALUES (?, ?)")) {
            while (rs.next()) {
                ps.setString(1, roleMap.get(rs.getInt("role_id")));
                ps.setInt(2, rs.getInt("permission_id"));
                ps.executeUpdate();
            }
        }
    }

    private static void migrateSystemLogs(Connection conn, Map<Integer, String> accountMap) throws SQLException {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM system_logs"); PreparedStatement ps = conn.prepareStatement("INSERT INTO system_logs_new (id, user_id, activity, details, timestamp, type, impact) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
            while (rs.next()) {
                ps.setInt(1, rs.getInt("id"));
                String uId = rs.getString("user_id");
                if (uId != null) uId = accountMap.getOrDefault(Integer.parseInt(uId), uId);
                ps.setString(2, uId);
                ps.setString(3, rs.getString("activity"));
                ps.setString(4, rs.getString("details"));
                ps.setString(5, rs.getString("timestamp"));
                ps.setString(6, rs.getString("type"));
                ps.setString(7, rs.getString("impact"));
                ps.executeUpdate();
            }
        }
    }

    private static void dropOldTables(Statement stmt) throws SQLException {
        String[] tables = {"roles", "Account", "company_admins", "customer_policies", "passwords", "transactions", "AccountPhone", "notifications", "claims", "role_permissions", "system_logs"};
        for (String t : tables) {
            stmt.execute("DROP TABLE " + t);
        }
    }

    private static void renameNewTables(Statement stmt) throws SQLException {
        String[] tables = {"roles", "Account", "company_admins", "customer_policies", "passwords", "transactions", "AccountPhone", "notifications", "claims", "role_permissions", "system_logs"};
        for (String t : tables) {
            stmt.execute("ALTER TABLE " + t + "_new RENAME TO " + t);
        }
    }
}
