package com.insurance.util;

import java.sql.*;

public class TestCleaner {
    public static void main(String[] args) {
        String email = "emmanuel@gmail.com";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Delete from company_admins
                String sql1 = "DELETE FROM company_admins WHERE user_id IN (SELECT id FROM Account WHERE email = ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql1)) {
                    pstmt.setString(1, email);
                    pstmt.executeUpdate();
                }

                // Delete from Account
                String sql2 = "DELETE FROM Account WHERE email = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql2)) {
                    pstmt.setString(1, email);
                    pstmt.executeUpdate();
                }

                // Reset Invitation
                String sql3 = "UPDATE admin_invitations SET is_used = 0 WHERE email = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql3)) {
                    pstmt.setString(1, email);
                    pstmt.executeUpdate();
                }

                conn.commit();
                System.out.println("Test data for " + email + " has been cleaned up and invitation reset.");
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
