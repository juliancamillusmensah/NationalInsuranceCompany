package com.insurance.util;

import java.sql.*;

public class SettingsInitializer {
    public static void main(String[] args) {
        String sql = "CREATE TABLE IF NOT EXISTS company_settings (" +
                     "company_id INTEGER PRIMARY KEY, " +
                     "daily_digest INTEGER DEFAULT 1, " +
                     "financial_alerts INTEGER DEFAULT 1, " +
                     "sms_notifications INTEGER DEFAULT 0, " +
                     "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                     ")";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Creating company_settings table...");
            stmt.execute(sql);
            System.out.println("Table created successfully.");
            
            // Seed for default company if needed
            // Default company ID 1
            stmt.execute("INSERT OR IGNORE INTO company_settings (company_id, daily_digest, financial_alerts, sms_notifications) VALUES (1, 1, 1, 0)");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
