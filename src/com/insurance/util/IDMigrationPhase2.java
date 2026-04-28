package com.insurance.util;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class IDMigrationPhase2 {

    public static void main(String[] args) {
        String dbPath = "C:/Program Files/Apache Software Foundation/Tomcat 10.1/webapps/NationalInsuranceCompany/WEB-INF/database/NIC_insurance.db";
        String url = "jdbc:sqlite:" + dbPath;

        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        try (Connection conn = DriverManager.getConnection(url)) {
            conn.setAutoCommit(false);
            
            System.out.println("Starting Phase 2 Migration...");

            // 1. Generate Mappings
            Map<Integer, String> companyMap = new HashMap<>();
            Map<Integer, String> policyMap = new HashMap<>();
            Map<Integer, String> permissionMap = new HashMap<>();

            try (Statement stmt = conn.createStatement()) {
                // Companies
                ResultSet rs = stmt.executeQuery("SELECT id FROM insurance_companies");
                while (rs.next()) {
                    int oldId = rs.getInt("id");
                    companyMap.put(oldId, "COMP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                }
                // Policies
                rs = stmt.executeQuery("SELECT id FROM policies");
                while (rs.next()) {
                    int oldId = rs.getInt("id");
                    policyMap.put(oldId, "POL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                }
                // Permissions
                rs = stmt.executeQuery("SELECT id FROM permissions");
                while (rs.next()) {
                    int oldId = rs.getInt("id");
                    permissionMap.put(oldId, "PERM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                }
            }
            
            System.out.println("Mappings Generated:");
            System.out.println("Companies: " + companyMap.size() + ", Policies: " + policyMap.size() + ", Permissions: " + permissionMap.size());

            try (Statement stmt = conn.createStatement()) {
                // 2. Create new primary tables
                stmt.execute("CREATE TABLE insurance_companies_new (" +
                             "id TEXT PRIMARY KEY, " +
                             "company_name TEXT, " +
                             "email TEXT, " +
                             "phone_number TEXT, " +
                             "address TEXT, " +
                             "status TEXT, " +
                             "created_at DATETIME, " +
                             "updated_at DATETIME)");

                stmt.execute("CREATE TABLE policies_new (" +
                             "id TEXT PRIMARY KEY, " +
                             "insurance_company_id TEXT, " +
                             "policy_name TEXT, " +
                             "description TEXT, " +
                             "premium_amount DECIMAL, " +
                             "coverage_duration TEXT, " +
                             "status TEXT, " +
                             "created_at DATETIME, " +
                             "updated_at DATETIME, " +
                             "policy_type TEXT, " +
                             "image_url TEXT, " +
                             "FOREIGN KEY(insurance_company_id) REFERENCES insurance_companies(id))");

                stmt.execute("CREATE TABLE permissions_new (" +
                             "id TEXT PRIMARY KEY, " +
                             "permission_name TEXT, " +
                             "module TEXT)");

                // Insert into new primary tables
                ResultSet rs = stmt.executeQuery("SELECT * FROM insurance_companies");
                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO insurance_companies_new VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        insertStmt.setString(1, companyMap.get(rs.getInt("id")));
                        insertStmt.setString(2, rs.getString("company_name"));
                        insertStmt.setString(3, rs.getString("email"));
                        insertStmt.setString(4, rs.getString("phone_number"));
                        insertStmt.setString(5, rs.getString("address"));
                        insertStmt.setString(6, rs.getString("status"));
                        insertStmt.setObject(7, rs.getObject("created_at"));
                        insertStmt.setObject(8, rs.getObject("updated_at"));
                        insertStmt.executeUpdate();
                    }
                }

                rs = stmt.executeQuery("SELECT * FROM policies");
                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO policies_new VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        insertStmt.setString(1, policyMap.get(rs.getInt("id")));
                        insertStmt.setString(2, companyMap.get(rs.getInt("insurance_company_id")));
                        insertStmt.setString(3, rs.getString("policy_name"));
                        insertStmt.setString(4, rs.getString("description"));
                        insertStmt.setBigDecimal(5, rs.getBigDecimal("premium_amount"));
                        insertStmt.setString(6, rs.getString("coverage_duration"));
                        insertStmt.setString(7, rs.getString("status"));
                        insertStmt.setObject(8, rs.getObject("created_at"));
                        insertStmt.setObject(9, rs.getObject("updated_at"));
                        insertStmt.setString(10, rs.getString("policy_type"));
                        insertStmt.setString(11, rs.getString("image_url"));
                        insertStmt.executeUpdate();
                    }
                }

                rs = stmt.executeQuery("SELECT * FROM permissions");
                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO permissions_new VALUES (?, ?, ?)")) {
                    while (rs.next()) {
                        insertStmt.setString(1, permissionMap.get(rs.getInt("id")));
                        insertStmt.setString(2, rs.getString("permission_name"));
                        insertStmt.setString(3, rs.getString("module"));
                        insertStmt.executeUpdate();
                    }
                }

                System.out.println("Base tables migrated.");

                // 3. Create new referencing tables
                stmt.execute("CREATE TABLE admin_invitations_new (" +
                             "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                             "email TEXT, " +
                             "company_id TEXT, " +
                             "invite_token TEXT, " +
                             "expires_at DATETIME, " +
                             "is_used BOOLEAN, " +
                             "created_at DATETIME, " +
                             "invited_role TEXT, " +
                             "FOREIGN KEY(company_id) REFERENCES insurance_companies(id))");

                stmt.execute("CREATE TABLE company_admins_new (" +
                             "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                             "user_id TEXT, " +
                             "company_id TEXT, " +
                             "created_at DATETIME, " +
                             "FOREIGN KEY(user_id) REFERENCES Account(id), " +
                             "FOREIGN KEY(company_id) REFERENCES insurance_companies(id))");

                stmt.execute("CREATE TABLE company_settings_new (" +
                             "company_id TEXT PRIMARY KEY, " +
                             "daily_digest INTEGER, " +
                             "financial_alerts INTEGER, " +
                             "sms_notifications INTEGER, " +
                             "updated_at TIMESTAMP, " +
                             "FOREIGN KEY(company_id) REFERENCES insurance_companies(id))");

                stmt.execute("CREATE TABLE customer_policies_new (" +
                             "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                             "user_id TEXT, " +
                             "policy_id TEXT, " +
                             "start_date DATE, " +
                             "end_date DATE, " +
                             "policy_status TEXT, " +
                             "created_at DATETIME, " +
                             "FOREIGN KEY(user_id) REFERENCES Account(id), " +
                             "FOREIGN KEY(policy_id) REFERENCES policies(id))");

                stmt.execute("CREATE TABLE transactions_new (" +
                             "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                             "user_id TEXT, " +
                             "policy_id TEXT, " +
                             "amount DECIMAL, " +
                             "transaction_type TEXT, " +
                             "payment_method TEXT, " +
                             "payment_status TEXT, " +
                             "transaction_date DATETIME, " +
                             "FOREIGN KEY(user_id) REFERENCES Account(id), " +
                             "FOREIGN KEY(policy_id) REFERENCES policies(id))");

                stmt.execute("CREATE TABLE claims_new (" +
                             "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                             "user_id TEXT, " +
                             "policy_id TEXT, " +
                             "claim_amount DECIMAL, " +
                             "description TEXT, " +
                             "incident_date TEXT, " +
                             "status TEXT, " +
                             "created_at TIMESTAMP, " +
                             "FOREIGN KEY(user_id) REFERENCES Account(id), " +
                             "FOREIGN KEY(policy_id) REFERENCES policies(id))");

                stmt.execute("CREATE TABLE role_permissions_new (" +
                             "role_id TEXT, " +
                             "permission_id TEXT, " +
                             "PRIMARY KEY(role_id, permission_id), " +
                             "FOREIGN KEY(role_id) REFERENCES roles(id), " +
                             "FOREIGN KEY(permission_id) REFERENCES permissions(id))");

                // Populate referencing tables (skipping ID for AUTOINCREMENT, extracting directly to new columns)

                // admin_invitations
                rs = stmt.executeQuery("SELECT * FROM admin_invitations");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO admin_invitations_new (id, email, company_id, invite_token, expires_at, is_used, created_at, invited_role) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        pstmt.setInt(1, rs.getInt("id"));
                        pstmt.setString(2, rs.getString("email"));
                        String newCid = companyMap.get(rs.getInt("company_id"));
                        pstmt.setString(3, newCid != null ? newCid : String.valueOf(rs.getInt("company_id")));
                        pstmt.setString(4, rs.getString("invite_token"));
                        pstmt.setObject(5, rs.getObject("expires_at"));
                        pstmt.setBoolean(6, rs.getBoolean("is_used"));
                        pstmt.setObject(7, rs.getObject("created_at"));
                        pstmt.setString(8, rs.getString("invited_role"));
                        pstmt.executeUpdate();
                    }
                }

                // company_admins
                rs = stmt.executeQuery("SELECT * FROM company_admins");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO company_admins_new (id, user_id, company_id, created_at) VALUES (?, ?, ?, ?)")) {
                    while (rs.next()) {
                        pstmt.setInt(1, rs.getInt("id"));
                        pstmt.setString(2, rs.getString("user_id"));
                        String newCid = companyMap.get(rs.getInt("company_id"));
                        pstmt.setString(3, newCid != null ? newCid : String.valueOf(rs.getInt("company_id")));
                        pstmt.setObject(4, rs.getObject("created_at"));
                        pstmt.executeUpdate();
                    }
                }

                // company_settings
                rs = stmt.executeQuery("SELECT * FROM company_settings");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO company_settings_new VALUES (?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        String newCid = companyMap.get(rs.getInt("company_id"));
                        pstmt.setString(1, newCid != null ? newCid : String.valueOf(rs.getInt("company_id")));
                        pstmt.setInt(2, rs.getInt("daily_digest"));
                        pstmt.setInt(3, rs.getInt("financial_alerts"));
                        pstmt.setInt(4, rs.getInt("sms_notifications"));
                        pstmt.setObject(5, rs.getObject("updated_at"));
                        pstmt.executeUpdate();
                    }
                }

                // customer_policies
                rs = stmt.executeQuery("SELECT * FROM customer_policies");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO customer_policies_new (id, user_id, policy_id, start_date, end_date, policy_status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        pstmt.setInt(1, rs.getInt("id"));
                        pstmt.setString(2, rs.getString("user_id"));
                        String newPid = policyMap.get(rs.getInt("policy_id"));
                        pstmt.setString(3, newPid != null ? newPid : String.valueOf(rs.getInt("policy_id")));
                        pstmt.setObject(4, rs.getObject("start_date"));
                        pstmt.setObject(5, rs.getObject("end_date"));
                        pstmt.setString(6, rs.getString("policy_status"));
                        pstmt.setObject(7, rs.getObject("created_at"));
                        pstmt.executeUpdate();
                    }
                }

                // transactions
                rs = stmt.executeQuery("SELECT * FROM transactions");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO transactions_new (id, user_id, policy_id, amount, transaction_type, payment_method, payment_status, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        pstmt.setInt(1, rs.getInt("id"));
                        pstmt.setString(2, rs.getString("user_id"));
                        String newPid = policyMap.get(rs.getInt("policy_id"));
                        pstmt.setString(3, newPid != null ? newPid : String.valueOf(rs.getInt("policy_id")));
                        pstmt.setBigDecimal(4, rs.getBigDecimal("amount"));
                        pstmt.setString(5, rs.getString("transaction_type"));
                        pstmt.setString(6, rs.getString("payment_method"));
                        pstmt.setString(7, rs.getString("payment_status"));
                        pstmt.setObject(8, rs.getObject("transaction_date"));
                        pstmt.executeUpdate();
                    }
                }

                // claims
                rs = stmt.executeQuery("SELECT * FROM claims");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO claims_new (id, user_id, policy_id, claim_amount, description, incident_date, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                    while (rs.next()) {
                        pstmt.setInt(1, rs.getInt("id"));
                        pstmt.setString(2, rs.getString("user_id"));
                        String newPid = policyMap.get(rs.getInt("policy_id"));
                        pstmt.setString(3, newPid != null ? newPid : String.valueOf(rs.getInt("policy_id")));
                        pstmt.setBigDecimal(4, rs.getBigDecimal("claim_amount"));
                        pstmt.setString(5, rs.getString("description"));
                        pstmt.setString(6, rs.getString("incident_date"));
                        pstmt.setString(7, rs.getString("status"));
                        pstmt.setObject(8, rs.getObject("created_at"));
                        pstmt.executeUpdate();
                    }
                }

                // role_permissions
                rs = stmt.executeQuery("SELECT * FROM role_permissions");
                try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO role_permissions_new VALUES (?, ?)")) {
                    while (rs.next()) {
                        pstmt.setString(1, rs.getString("role_id"));
                        String newPermId = permissionMap.get(rs.getInt("permission_id"));
                        pstmt.setString(2, newPermId != null ? newPermId : String.valueOf(rs.getInt("permission_id")));
                        pstmt.executeUpdate();
                    }
                }

                System.out.println("Child tables migrated.");

                // 4. Drop old tables
                stmt.execute("DROP TABLE admin_invitations");
                stmt.execute("DROP TABLE company_admins");
                stmt.execute("DROP TABLE company_settings");
                stmt.execute("DROP TABLE customer_policies");
                stmt.execute("DROP TABLE transactions");
                stmt.execute("DROP TABLE claims");
                stmt.execute("DROP TABLE role_permissions");
                stmt.execute("DROP TABLE policies");
                stmt.execute("DROP TABLE permissions");
                stmt.execute("DROP TABLE insurance_companies");

                // 5. Rename new tables
                stmt.execute("ALTER TABLE admin_invitations_new RENAME TO admin_invitations");
                stmt.execute("ALTER TABLE company_admins_new RENAME TO company_admins");
                stmt.execute("ALTER TABLE company_settings_new RENAME TO company_settings");
                stmt.execute("ALTER TABLE customer_policies_new RENAME TO customer_policies");
                stmt.execute("ALTER TABLE transactions_new RENAME TO transactions");
                stmt.execute("ALTER TABLE claims_new RENAME TO claims");
                stmt.execute("ALTER TABLE role_permissions_new RENAME TO role_permissions");
                stmt.execute("ALTER TABLE policies_new RENAME TO policies");
                stmt.execute("ALTER TABLE permissions_new RENAME TO permissions");
                stmt.execute("ALTER TABLE insurance_companies_new RENAME TO insurance_companies");

                System.out.println("Cleanup complete. Committing...");
            }

            conn.commit();
            System.out.println("Migration Phase 2 completed successfully!");

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Migration failed and rolled back.");
        }
    }
}
