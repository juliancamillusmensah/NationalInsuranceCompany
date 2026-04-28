package com.insurance.util;

import java.sql.*;
import com.insurance.util.DBConnection;

public class GhanaRegistryMigration {
    public static void main(String[] args) {
        String dropTable = "DROP TABLE IF EXISTS ghana_insurance_registry";
        String createTable = "CREATE TABLE ghana_insurance_registry (" +
                             "id VARCHAR(50) PRIMARY KEY, " +
                             "company_name TEXT NOT NULL, " +
                             "official_email TEXT, " +
                             "official_phone TEXT, " +
                             "headquarters TEXT, " +
                             "type TEXT, " +
                             "created_at DATETIME DEFAULT CURRENT_TIMESTAMP" +
                             ")";

        String insertSQL = "INSERT INTO ghana_insurance_registry (id, company_name, official_email, official_phone, headquarters, type) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Creating ghana_insurance_registry table...");
            stmt.execute(dropTable);
            stmt.execute(createTable);

            try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
                addCompany(pstmt, "REG-001", "Enterprise Insurance", "contactus.insurance@enterprisegroup.com.gh", "+233 30 266 6511", "High Street, Accra", "Non-Life");
                addCompany(pstmt, "REG-002", "SIC Insurance", "sicinfo@sic-gh.com", "+233 30 222 8957", "Nyemitei House, Accra", "Non-Life");
                addCompany(pstmt, "REG-003", "Star Assurance", "info@starassurance.com", "+233 30 224 0632", "Stanbic Heights, Airport City", "Non-Life");
                addCompany(pstmt, "REG-004", "Hollard Insurance Ghana", "info@hollardghana.com", "+233 30 222 0966", "Hollard Tower, Ridge", "Non-Life");
                addCompany(pstmt, "REG-005", "GLICO Insurance", "info@glicogroup.com", "+233 30 221 8500", "Glico House, Adabraka", "Non-Life");
                addCompany(pstmt, "REG-006", "Vanguard Assurance", "info@vanguardassurance.com", "+233 30 223 3411", "Vanguard House, Ridge", "Non-Life");
                addCompany(pstmt, "REG-007", "Old Mutual Ghana", "ghana@oldmutual.com.gh", "+233 30 225 2132", "Mutual Place, Airport City", "Life");
                addCompany(pstmt, "REG-008", "Prudential Life Insurance Ghana", "info@prudential.com.gh", "+233 30 220 8877", "Prudential House, Accra", "Life");
                addCompany(pstmt, "REG-009", "Phoenix Insurance", "info@phoenixinsurancegh.com", "+233 30 224 6750", "Phoenix House, Accra", "Non-Life");
                addCompany(pstmt, "REG-010", "RegencyNem Insurance", "info@regencynem.com", "+233 30 224 4242", "RegencyNem House, Adabraka", "Non-Life");
                addCompany(pstmt, "REG-011", "Metropolitan Life Insurance", "info@metropolitan.com.gh", "+233 30 261 0350", "Metropolitan House, Ridge", "Life");
                addCompany(pstmt, "REG-012", "Allianz Insurance Ghana", "info@allianz-gh.com", "+233 30 225 3111", "Allianz House, Airport City", "Non-Life");
            }

            System.out.println("Migration complete. Registry populated with 12 companies.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void addCompany(PreparedStatement pstmt, String id, String name, String email, String phone, String address, String type) throws SQLException {
        pstmt.setString(1, id);
        pstmt.setString(2, name);
        pstmt.setString(3, email);
        pstmt.setString(4, phone);
        pstmt.setString(5, address);
        pstmt.setString(6, type);
        pstmt.executeUpdate();
    }
}
