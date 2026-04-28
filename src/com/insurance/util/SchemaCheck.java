package com.insurance.util;
import com.insurance.util.DBConnection;
import java.sql.*;

public class SchemaCheck {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getColumns(null, null, "insurance_companies", null);
            System.out.println("Columns in insurance_companies:");
            while (rs.next()) {
                String name = rs.getString("COLUMN_NAME");
                String type = rs.getString("TYPE_NAME");
                System.out.println("- " + name + " (" + type + ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
