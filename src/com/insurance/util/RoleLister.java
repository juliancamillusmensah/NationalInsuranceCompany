package com.insurance.util;

import java.sql.*;

public class RoleLister {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id, role_name FROM roles")) {
            System.out.println("Roles in database:");
            while (rs.next()) {
                System.out.println("- ID: " + rs.getInt("id") + ", Name: " + rs.getString("role_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
