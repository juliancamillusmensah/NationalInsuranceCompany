package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Claim;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {
    private Claim mapClaim(ResultSet rs) throws SQLException {
        Claim c = new Claim();
        c.setId(rs.getString("id"));
        c.setUserId(rs.getString("user_id"));
        c.setPolicyId(rs.getString("policy_id"));
        try { c.setPolicyName(rs.getString("policy_name")); } catch (SQLException e) {}
        try { c.setUserName(rs.getString("full_name")); } catch (SQLException e) {}
        try { c.setUserEmail(rs.getString("email")); } catch (SQLException e) {}
        c.setClaimAmount(rs.getBigDecimal("claim_amount"));
        c.setDescription(rs.getString("description"));
        c.setIncidentDate(rs.getString("incident_date"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        
        // New NIC fields
        c.setAcknowledgedAt(rs.getTimestamp("acknowledged_at"));
        c.setDocsSubmittedAt(rs.getTimestamp("docs_submitted_at"));
        c.setDischargeVoucherAt(rs.getTimestamp("discharge_voucher_at"));
        c.setSettledAt(rs.getTimestamp("settled_at"));
        c.setRejectionReason(rs.getString("rejection_reason"));
        c.setAssignedAdjuster(rs.getString("assigned_adjuster"));
        try { c.setDocumentPath(rs.getString("document_path")); } catch(SQLException e) {}
        return c;
    }

    public boolean addClaim(Claim claim) {
        String id = "CLM-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO claims (id, user_id, policy_id, claim_amount, description, incident_date, status, created_at, document_path) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'Reported', datetime('now'), ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, claim.getUserId());
            pstmt.setString(3, claim.getPolicyId());
            pstmt.setBigDecimal(4, claim.getClaimAmount());
            pstmt.setString(5, claim.getDescription());
            pstmt.setString(6, claim.getIncidentDate());
            pstmt.setString(7, claim.getDocumentPath());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Claim> getClaimsByUserId(String userId) {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_name FROM claims c " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    claims.add(mapClaim(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public List<Claim> getClaimsByCompanyId(String companyId) {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_name, a.full_name, a.email FROM claims c " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "JOIN Account a ON c.user_id = a.id " +
                     "WHERE p.insurance_company_id = ? " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    claims.add(mapClaim(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public boolean updateClaimStatus(String id, String status) {
        String sql = "UPDATE claims SET status = ?, " +
                     "acknowledged_at = CASE WHEN ? = 'Acknowledged' AND acknowledged_at IS NULL THEN datetime('now') ELSE acknowledged_at END, " +
                     "docs_submitted_at = CASE WHEN ? = 'Reviewing' AND docs_submitted_at IS NULL THEN datetime('now') ELSE docs_submitted_at END, " +
                     "discharge_voucher_at = CASE WHEN ? = 'Offer_Made' AND discharge_voucher_at IS NULL THEN datetime('now') ELSE discharge_voucher_at END, " +
                     "settled_at = CASE WHEN ? = 'Settled' AND settled_at IS NULL THEN datetime('now') ELSE settled_at END " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, status);
            pstmt.setString(3, status);
            pstmt.setString(4, status);
            pstmt.setString(5, status);
            pstmt.setString(6, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getClaimCountByStatus(String status, String companyId) {
        String sql = "SELECT COUNT(*) FROM claims c " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "WHERE p.insurance_company_id = ? AND c.status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            pstmt.setString(2, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getAverageSettlementDays(String companyId) {
        // Average time between created_at and settled_at in days
        String sql = "SELECT AVG(julianday(settled_at) - julianday(created_at)) FROM claims c " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "WHERE p.insurance_company_id = ? AND c.status = 'Settled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Claim> getAllClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_name, a.full_name, a.email FROM claims c " +
                     "JOIN Account a ON c.user_id = a.id " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                claims.add(mapClaim(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }
}
