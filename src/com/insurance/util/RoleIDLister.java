package com.insurance.util;

import java.sql.*;

public class RoleIDLister {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Checking Role IDs...");
            ResultSet rs = stmt.executeQuery("SELECT * FROM roles");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + ", Name: " + rs.getString("role_name"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
