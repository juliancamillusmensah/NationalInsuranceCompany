package com.insurance.util;

import java.sql.*;

public class MigratePolicyImage {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Adding 'image_url' column to 'policies' table...");
            stmt.execute("ALTER TABLE policies ADD COLUMN image_url TEXT");
            System.out.println("Migration successful.");
            
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate column name")) {
                System.out.println("Column 'image_url' already exists.");
            } else {
                e.printStackTrace();
            }
        }
    }
}
