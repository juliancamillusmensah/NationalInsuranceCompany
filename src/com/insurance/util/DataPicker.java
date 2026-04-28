package com.insurance.util;

import java.sql.*;

public class DataPicker {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT email, role_id, status FROM Account")) {
            System.out.println("Accounts in database:");
            while (rs.next()) {
                System.out.println("- Email: " + rs.getString("email") + ", Role: " + rs.getInt("role_id")
                        + ", Status: " + rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
