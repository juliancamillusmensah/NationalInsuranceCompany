package com.insurance.util;

import java.sql.*;
import java.util.UUID;

/**
 * Phase 3 Migration: Entity IDs to Unique Strings
 * Targets: transactions, claims, notifications, system_logs, AccountPhone, admin_invitations
 */
public class IDMigrationPhase3 {

    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Starting Phase 3 Migration: Entity IDs to Strings...");
            stmt.execute("PRAGMA foreign_keys=OFF;");
            conn.setAutoCommit(false);

            // 1. Recreate tables with TEXT IDs
            recreateTransactions(conn);
            recreateClaims(conn);
            recreateNotifications(conn);
            recreateSystemLogs(conn);
            recreateAccountPhone(conn);
            recreateAdminInvitations(conn);

            conn.commit();
            stmt.execute("PRAGMA foreign_keys=ON;");
            System.out.println("Phase 3 Migration Completed Successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Phase 3 Migration Failed! Check logs.");
        }
    }

    private static String generateId(String prefix) {
        return prefix + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private static void recreateTransactions(Connection conn) throws SQLException {
        System.out.println("Migrating transactions...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE transactions_new (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, policy_id TEXT NOT NULL, amount DECIMAL(10,2) NOT NULL, transaction_type TEXT, payment_method TEXT, payment_status TEXT DEFAULT 'pending', transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM transactions");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO transactions_new (id, user_id, policy_id, amount, transaction_type, payment_method, payment_status, transaction_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("TXN"));
                    ps.setString(2, rs.getString("user_id"));
                    ps.setString(3, rs.getString("policy_id"));
                    ps.setBigDecimal(4, rs.getBigDecimal("amount"));
                    ps.setString(5, rs.getString("transaction_type"));
                    ps.setString(6, rs.getString("payment_method"));
                    ps.setString(7, rs.getString("payment_status"));
                    ps.setString(8, rs.getString("transaction_date"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE transactions");
            stmt.execute("ALTER TABLE transactions_new RENAME TO transactions");
        }
    }

    private static void recreateClaims(Connection conn) throws SQLException {
        System.out.println("Migrating claims...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE claims_new (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, policy_id TEXT NOT NULL, claim_amount DECIMAL(10,2) NOT NULL, description TEXT, incident_date TEXT, status TEXT DEFAULT 'Pending', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM claims");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO claims_new (id, user_id, policy_id, claim_amount, description, incident_date, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("CLM"));
                    ps.setString(2, rs.getString("user_id"));
                    ps.setString(3, rs.getString("policy_id"));
                    ps.setBigDecimal(4, rs.getBigDecimal("claim_amount"));
                    ps.setString(5, rs.getString("description"));
                    ps.setString(6, rs.getString("incident_date"));
                    ps.setString(7, rs.getString("status"));
                    ps.setString(8, rs.getString("created_at"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE claims");
            stmt.execute("ALTER TABLE claims_new RENAME TO claims");
        }
    }

    private static void recreateNotifications(Connection conn) throws SQLException {
        System.out.println("Migrating notifications...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE notifications_new (id TEXT PRIMARY KEY, user_id TEXT, title TEXT, message TEXT, type TEXT, is_read INTEGER DEFAULT 0, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM notifications");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO notifications_new (id, user_id, title, message, type, is_read, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("NOTE"));
                    ps.setString(2, rs.getString("user_id"));
                    ps.setString(3, rs.getString("title"));
                    ps.setString(4, rs.getString("message"));
                    ps.setString(5, rs.getString("type"));
                    ps.setInt(6, rs.getInt("is_read"));
                    ps.setString(7, rs.getString("created_at"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE notifications");
            stmt.execute("ALTER TABLE notifications_new RENAME TO notifications");
        }
    }

    private static void recreateSystemLogs(Connection conn) throws SQLException {
        System.out.println("Migrating system_logs...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE system_logs_new (id TEXT PRIMARY KEY, user_id TEXT, activity TEXT, details TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, type TEXT, impact TEXT)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM system_logs");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO system_logs_new (id, user_id, activity, details, timestamp, type, impact) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("LOG"));
                    ps.setString(2, rs.getString("user_id"));
                    ps.setString(3, rs.getString("activity"));
                    ps.setString(4, rs.getString("details"));
                    ps.setString(5, rs.getString("timestamp"));
                    ps.setString(6, rs.getString("type"));
                    ps.setString(7, rs.getString("impact"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE system_logs");
            stmt.execute("ALTER TABLE system_logs_new RENAME TO system_logs");
        }
    }

    private static void recreateAccountPhone(Connection conn) throws SQLException {
        System.out.println("Migrating AccountPhone...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE AccountPhone_new (id TEXT PRIMARY KEY, account_id TEXT NOT NULL, phone_number TEXT NOT NULL)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM AccountPhone");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO AccountPhone_new (id, account_id, phone_number) VALUES (?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("PHN"));
                    ps.setString(2, rs.getString("account_id"));
                    ps.setString(3, rs.getString("phone_number"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE AccountPhone");
            stmt.execute("ALTER TABLE AccountPhone_new RENAME TO AccountPhone");
        }
    }

    private static void recreateAdminInvitations(Connection conn) throws SQLException {
        System.out.println("Migrating admin_invitations...");
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE TABLE admin_invitations_new (id TEXT PRIMARY KEY, email TEXT NOT NULL, company_id TEXT NOT NULL, invite_token TEXT NOT NULL, expires_at DATETIME, is_used INTEGER DEFAULT 0, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, invited_role TEXT)");
            
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM admin_invitations");
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO admin_invitations_new (id, email, company_id, invite_token, expires_at, is_used, created_at, invited_role) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                while (rs.next()) {
                    ps.setString(1, generateId("INV"));
                    ps.setString(2, rs.getString("email"));
                    ps.setString(3, rs.getString("company_id"));
                    ps.setString(4, rs.getString("invite_token"));
                    ps.setTimestamp(5, rs.getTimestamp("expires_at"));
                    ps.setInt(6, rs.getInt("is_used"));
                    ps.setTimestamp(7, rs.getTimestamp("created_at"));
                    ps.setString(8, rs.getString("invited_role"));
                    ps.executeUpdate();
                }
            }
            stmt.execute("DROP TABLE admin_invitations");
            stmt.execute("ALTER TABLE admin_invitations_new RENAME TO admin_invitations");
        }
    }
}
