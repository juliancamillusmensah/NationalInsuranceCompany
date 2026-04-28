package com.insurance.util;

import java.sql.*;

public class SchemaUpdater {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            // 1. Add password column if it doesn't exist
            System.out.println("Adding password column to Account table...");
            try {
                stmt.execute("ALTER TABLE Account ADD COLUMN password TEXT");
                System.out.println("- Column added successfully.");
            } catch (SQLException e) {
                if (e.getMessage().contains("duplicate column name")) {
                    System.out.println("- Column already exists.");
                } else {
                    throw e;
                }
            }

            // 2. Set default password for existing users
            System.out.println("Setting default passwords...");
            int updated = stmt.executeUpdate(
                    "UPDATE Account SET password = 'password123' WHERE password IS NULL OR password = ''");
            System.out.println("- Updated " + updated + " accounts with default password.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
