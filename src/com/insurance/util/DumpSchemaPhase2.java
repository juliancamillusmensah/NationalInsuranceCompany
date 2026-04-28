package com.insurance.util;
import java.sql.*;
public class DumpSchemaPhase2 {
    public static void main(String[] args) throws Exception {
        Class.forName("org.sqlite.JDBC");
        String url = "jdbc:sqlite:C:/Program Files/Apache Software Foundation/Tomcat 10.1/webapps/NationalInsuranceCompany/WEB-INF/database/NIC_insurance.db";
        try (Connection conn = DriverManager.getConnection(url)) {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getTables(null, null, null, new String[]{"TABLE"});
            while (rs.next()) {
                String tableName = rs.getString("TABLE_NAME");
                System.out.println("TABLE: " + tableName);
                ResultSet cols = meta.getColumns(null, null, tableName, null);
                while (cols.next()) {
                    System.out.println("  " + cols.getString("COLUMN_NAME") + " - " + cols.getString("TYPE_NAME"));
                }
            }
        }
    }
}
