package com.insurance.util;

import java.sql.*;

public class RoleSchemaUpdater {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Updating admin_invitations schema...");
            try {
                stmt.execute("ALTER TABLE admin_invitations ADD COLUMN invited_role TEXT DEFAULT 'companyadmin'");
                System.out.println("- Column 'invited_role' added successfully.");
            } catch (SQLException e) {
                if (e.getMessage().contains("duplicate column name")) {
                    System.out.println("- Column already exists.");
                } else {
                    throw e;
                }
            }
            
            System.out.println("Seeding new roles...");
            // Role ID 5 for Support
            stmt.execute("INSERT OR IGNORE INTO roles (id, role_name, description) VALUES (5, 'Support', 'Customer Support Agent')");
            // Role ID 6 for Auditor
            stmt.execute("INSERT OR IGNORE INTO roles (id, role_name, description) VALUES (6, 'Auditor', 'Financial Auditor')");
            System.out.println("- Roles seeded successfully.");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
