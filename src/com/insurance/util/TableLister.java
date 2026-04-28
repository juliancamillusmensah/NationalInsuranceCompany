package com.insurance.util;

import java.sql.*;

public class TableLister {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData dbmd = conn.getMetaData();
            try (ResultSet rs = dbmd.getTables(null, null, "%", new String[] { "TABLE" })) {
                System.out.println("Tables in database:");
                while (rs.next()) {
                    System.out.println("- " + rs.getString("TABLE_NAME"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
