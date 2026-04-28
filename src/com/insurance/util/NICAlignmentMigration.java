package com.insurance.util;

import java.sql.*;
import com.insurance.util.DBConnection;

public class NICAlignmentMigration {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Migrating insurance_companies table...");
            addColumn(stmt, "insurance_companies", "company_type", "TEXT DEFAULT 'Non-Life'");
            addColumn(stmt, "insurance_companies", "license_number", "TEXT DEFAULT 'NIC-TBD'");
            addColumn(stmt, "insurance_companies", "license_expiry", "TEXT");
            addColumn(stmt, "insurance_companies", "compliance_status", "TEXT DEFAULT 'Compliant'");
            addColumn(stmt, "insurance_companies", "tin", "TEXT");

            System.out.println("Migrating ghana_insurance_registry table...");
            // ghana_insurance_registry already has 'type' from previous migration, but we should align names if possible.
            // For now, let's just add missing ones.
            addColumn(stmt, "ghana_insurance_registry", "license_number", "TEXT DEFAULT 'NIC-PRE-AUTH'");
            addColumn(stmt, "ghana_insurance_registry", "license_expiry", "TEXT");
            addColumn(stmt, "ghana_insurance_registry", "compliance_status", "TEXT DEFAULT 'Compliant'");
            addColumn(stmt, "ghana_insurance_registry", "tin", "TEXT");

            System.out.println("Alignment migration complete.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void addColumn(Statement stmt, String tableName, String columnName, String definition) {
        try {
            stmt.execute("ALTER TABLE " + tableName + " ADD COLUMN " + columnName + " " + definition);
            System.out.println("Added " + columnName + " to " + tableName);
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate column name")) {
                System.out.println("Column " + columnName + " already exists in " + tableName);
            } else {
                System.err.println("Error adding " + columnName + " to " + tableName + ": " + e.getMessage());
            }
        }
    }
}
