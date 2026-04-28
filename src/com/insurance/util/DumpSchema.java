package com.insurance.util;

import java.sql.*;

public class DumpSchema {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT sql FROM sqlite_master WHERE type='table'")) {
            
            while (rs.next()) {
                String schema = rs.getString(1);
                if (schema != null) {
                    System.out.println(schema + ";\n");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
