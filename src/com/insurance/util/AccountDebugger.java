package com.insurance.util;

import java.sql.*;

public class AccountDebugger {
    public static void main(String[] args) {
        String dbPath = "C:/Program Files/Apache Software Foundation/Tomcat 10.1/webapps/NationalInsuranceCompany/WEB-INF/database/NIC_insurance.db";
        String url = "jdbc:sqlite:" + dbPath;

        try {
            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection(url);
                 Statement stmt = conn.createStatement()) {
                
                System.out.println("--- Account Table Contents (including passwords) ---");
                try (ResultSet rs = stmt.executeQuery("SELECT id, email, password, role_id, status FROM Account")) {
                    while (rs.next()) {
                        System.out.println("ID: " + rs.getString("id") + 
                                           " | Email: " + rs.getString("email") + 
                                           " | PWD: " + rs.getString("password") + 
                                           " | Role: " + rs.getString("role_id") + 
                                           " | Status: " + rs.getString("status"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
