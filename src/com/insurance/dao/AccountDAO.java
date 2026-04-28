package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
    public int getAccountCount() {
        String sql = "SELECT COUNT(*) FROM Account";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Account> getAllAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                accounts.add(mapAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }

    public Account getAccountById(String id) {
        String sql = "SELECT * FROM Account WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM Account WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addAccount(Account acc) {
        if (acc.getId() == null || acc.getId().isEmpty()) {
            acc.setId("ACC-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        String sql = "INSERT INTO Account (id, full_name, email, role_id, status, password, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, acc.getId());
            pstmt.setString(2, acc.getFullName());
            pstmt.setString(3, acc.getEmail());
            pstmt.setString(4, acc.getRoleId());
            pstmt.setString(5, acc.getStatus());
            pstmt.setString(6, acc.getPassword());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Account authenticate(String email, String password) {
        String sql = "SELECT * FROM Account WHERE LOWER(email) = LOWER(?) AND password = ? AND status = 'active'";
        System.out.println("DEBUG: AccountDAO: Executing Auth with email=[" + email + "] and password=[" + password + "] (Status: active)");
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("DEBUG: AccountDAO: Match found for email: " + email);
                    return mapAccount(rs);
                } else {
                    System.out.println("DEBUG: AccountDAO: No match found for email: " + email);
                }
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: AccountDAO: Error during authentication: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateAccount(Account acc) {
        String sql = "UPDATE Account SET full_name = ?, email = ?, role_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, acc.getFullName());
            pstmt.setString(2, acc.getEmail());
            pstmt.setString(3, acc.getRoleId());
            pstmt.setString(4, acc.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAccountStatus(String id, String status) {
        String sql = "UPDATE Account SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfile(String id, String fullName, String email) {
        String sql = "UPDATE Account SET full_name = ?, email = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(String id, String newPassword) {
        String sql = "UPDATE Account SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPassword);
            pstmt.setString(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean submitKYC(String userId, String docType, String docPath, String portraitPath) {
        String sql = "UPDATE Account SET kyc_status = 'Pending', kyc_document_type = ?, kyc_document_path = ?, kyc_portrait_path = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, docType);
            pstmt.setString(2, docPath);
            pstmt.setString(3, portraitPath);
            pstmt.setString(4, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean verifyKYC(String userId, String status) {
        String sql = "UPDATE Account SET kyc_status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Account> getPendingKYCAccounts() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE kyc_status = 'Pending' ORDER BY updated_at ASC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                accounts.add(mapAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }

    public int getPendingKYCCount() {
        String sql = "SELECT COUNT(*) FROM Account WHERE kyc_status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Account mapAccount(ResultSet rs) throws SQLException {
        Account acc = new Account();
        acc.setId(rs.getString("id"));
        acc.setFullName(rs.getString("full_name"));
        acc.setEmail(rs.getString("email"));
        acc.setRoleId(rs.getString("role_id"));
        acc.setStatus(rs.getString("status"));
        acc.setPassword(rs.getString("password"));
        acc.setCreatedAt(rs.getTimestamp("created_at"));
        acc.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Map KYC fields
        acc.setKycStatus(rs.getString("kyc_status"));
        acc.setKycDocumentType(rs.getString("kyc_document_type"));
        acc.setKycDocumentPath(rs.getString("kyc_document_path"));
        acc.setKycPortraitPath(rs.getString("kyc_portrait_path"));
        
        return acc;
    }
}
