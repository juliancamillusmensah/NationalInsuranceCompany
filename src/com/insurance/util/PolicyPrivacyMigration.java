package com.insurance.util;

import java.sql.*;

public class PolicyPrivacyMigration {
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
            try (Statement stmt = conn.createStatement()) {
                System.out.println("Adding hide_from_superadmin column to company_settings...");
                stmt.execute("ALTER TABLE company_settings ADD COLUMN hide_from_superadmin INTEGER DEFAULT 0");
                System.out.println("Cloud migration successful.");
            }
        } catch (SQLException e) {
            if (e.getMessage().contains("duplicate column name")) {
                System.out.println("Column already exists. Skipping.");
            } else {
                e.printStackTrace();
            }
        }
    }
}
