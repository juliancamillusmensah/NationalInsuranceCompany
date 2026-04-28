package com.insurance.util;

import java.sql.*;

public class SchemaChecker {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            // Get all tables
            DatabaseMetaData metaData = conn.getMetaData();
            try (ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"})) {
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    System.out.println("\nColumns in " + tableName + " table:");
                    try (ResultSet columns = metaData.getColumns(null, null, tableName, "%")) {
                        while (columns.next()) {
                            System.out.println("- " + columns.getString("COLUMN_NAME") + " (" + columns.getString("TYPE_NAME") + ")");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
