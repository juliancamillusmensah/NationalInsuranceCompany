package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Policy;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PolicyDAO {
    public static final String VERSION = "1.0.1_WITH_ENSURE";
    public int getTotalPolicyCountByCompany(String companyId) {
        String sql = "SELECT COUNT(*) FROM customer_policies cp " +
                     "JOIN policies p ON cp.policy_id = p.id " +
                     "WHERE p.insurance_company_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Policy> getCustomerPolicies(String userId) {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT p.*, cp.id AS cp_id, cp.start_date, cp.end_date, cp.policy_status, cp.insured_item, cp.document_path FROM policies p " +
                "JOIN customer_policies cp ON p.id = cp.policy_id WHERE cp.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Policy p = new Policy();
                    p.setId(rs.getString("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    p.setCoverageDuration(rs.getString("coverage_duration"));
                    p.setStatus(rs.getString("status"));

                    String startDateStr = rs.getString("start_date");
                    if (startDateStr != null && !startDateStr.isEmpty()) {
                        try {
                            if (startDateStr.length() > 10)
                                startDateStr = startDateStr.substring(0, 10);
                            p.setStartDate(java.sql.Date.valueOf(startDateStr));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    String endDateStr = rs.getString("end_date");
                    if (endDateStr != null && !endDateStr.isEmpty()) {
                        try {
                            if (endDateStr.length() > 10)
                                endDateStr = endDateStr.substring(0, 10);
                            p.setEndDate(java.sql.Date.valueOf(endDateStr));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    p.setPolicyStatus(rs.getString("policy_status"));
                    p.setCustomerPolicyId(rs.getInt("cp_id"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setInsuredItem(rs.getString("insured_item"));
                    p.setDocumentPath(rs.getString("document_path"));
                    p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                    policies.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public int getActivePolicyCountByCompany(String companyId) {
        String sql = "SELECT COUNT(*) FROM customer_policies cp " +
                     "JOIN policies p ON cp.policy_id = p.id " +
                     "WHERE cp.policy_status = 'active' AND p.insurance_company_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Policy> getPoliciesByCompany(String companyId) {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT * FROM policies WHERE insurance_company_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Policy p = new Policy();
                    p.setId(rs.getString("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    p.setCoverageDuration(rs.getString("coverage_duration"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                    p.setStatus(rs.getString("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    policies.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public List<Policy> getRecentPolicies(int limit) {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT * FROM policies ORDER BY updated_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Policy p = new Policy();
                    p.setId(rs.getString("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    p.setCoverageDuration(rs.getString("coverage_duration"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                    p.setStatus(rs.getString("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    policies.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public boolean enrollPolicy(String userId, String policyId, String insuredItem, String documentPath) {
        String sql = "INSERT INTO customer_policies (user_id, policy_id, start_date, end_date, policy_status, created_at, insured_item, document_path) " +
                     "VALUES (?, ?, date('now'), date('now', '+1 year'), 'active', datetime('now'), ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, policyId);
            pstmt.setString(3, insuredItem);
            pstmt.setString(4, documentPath);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean renewPolicy(int customerPolicyId) {
        String sql = "UPDATE customer_policies SET policy_status = 'active', end_date = date('now', '+1 year'), " +
                     "start_date = date('now') WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customerPolicyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelPolicy(int customerPolicyId) {
        String sql = "UPDATE customer_policies SET policy_status = 'cancelled' WHERE id = ? AND policy_status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customerPolicyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean addPolicy(Policy p) {
        String policyId = p.getId();
        if (policyId == null || policyId.isEmpty()) {
            policyId = "POL-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            p.setId(policyId);
        }
        String sql = "INSERT INTO policies (id, policy_name, description, premium_amount, coverage_duration, policy_type, insurance_company_id, image_url, status, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active', datetime('now'), datetime('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, policyId);
            pstmt.setString(2, p.getPolicyName());
            pstmt.setString(3, p.getDescription());
            pstmt.setBigDecimal(4, p.getPremiumAmount());
            pstmt.setString(5, p.getCoverageDuration());
            pstmt.setString(6, p.getPolicyType());
            pstmt.setString(7, p.getInsuranceCompanyId());
            pstmt.setString(8, p.getImageUrl());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Policy> getAllPolicies() {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT p.* FROM policies p " +
                     "LEFT JOIN company_settings cs ON p.insurance_company_id = cs.company_id " +
                     "WHERE cs.hide_from_superadmin IS NULL OR cs.hide_from_superadmin = 0";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Policy p = new Policy();
                p.setId(rs.getString("id"));
                p.setPolicyName(rs.getString("policy_name"));
                p.setDescription(rs.getString("description"));
                p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                p.setCoverageDuration(rs.getString("coverage_duration"));
                p.setPolicyType(rs.getString("policy_type"));
                p.setImageUrl(rs.getString("image_url"));
                p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                policies.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    /**
     * Returns all active policies for customer-facing pages (no company_settings filter).
     */
    public List<Policy> getAllActivePolicies() {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT * FROM policies WHERE status = 'active' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Policy p = new Policy();
                p.setId(rs.getString("id"));
                p.setPolicyName(rs.getString("policy_name"));
                p.setDescription(rs.getString("description"));
                p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                p.setCoverageDuration(rs.getString("coverage_duration"));
                p.setPolicyType(rs.getString("policy_type"));
                p.setImageUrl(rs.getString("image_url"));
                p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                policies.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public int getTotalPolicyCount() {
        String sql = "SELECT COUNT(*) FROM policies p " +
                     "LEFT JOIN company_settings cs ON p.insurance_company_id = cs.company_id " +
                     "WHERE cs.hide_from_superadmin IS NULL OR cs.hide_from_superadmin = 0";
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
    public Policy getPolicyById(String id) {
        String sql = "SELECT * FROM policies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Policy p = new Policy();
                    p.setId(rs.getString("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    p.setCoverageDuration(rs.getString("coverage_duration"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setInsuranceCompanyId(rs.getString("insurance_company_id"));
                    p.setStatus(rs.getString("status"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Policy> getEnrolledSubscribers(String companyId) {
        List<Policy> results = new ArrayList<>();
        String sql = "SELECT cp.*, a.full_name as customer_name, a.email as customer_email, " +
                     "a.kyc_status, a.kyc_document_path as kyc_doc, a.kyc_portrait_path, " +
                     "p.policy_name, p.policy_type " +
                     "FROM customer_policies cp " +
                     "JOIN Account a ON cp.user_id = a.id " +
                     "JOIN policies p ON cp.policy_id = p.id " +
                     "WHERE p.insurance_company_id = ? " +
                     "ORDER BY cp.created_at DESC";
        try (Connection conn = com.insurance.util.DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Policy p = new Policy();
                    p.setCustomerPolicyId(rs.getInt("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setCustomerName(rs.getString("customer_name"));
                    p.setCustomerEmail(rs.getString("customer_email"));
                    p.setInsuredItem(rs.getString("insured_item"));
                    p.setDocumentPath(rs.getString("document_path")); // Enrollment Doc
                    p.setPolicyStatus(rs.getString("policy_status"));
                    p.setUserId(rs.getString("user_id"));
                    
                    // KYC Fields
                    p.setKycStatus(rs.getString("kyc_status"));
                    // We'll reuse the model's kycDocumentPath and kycPortraitPath if added correctly
                    try {
                        p.getClass().getMethod("setKycDocumentPath", String.class).invoke(p, rs.getString("kyc_doc"));
                    } catch (Exception e) {}
                    p.setKycPortraitPath(rs.getString("kyc_portrait_path"));
                    
                    String startStr = rs.getString("start_date");
                    if (startStr != null && startStr.length() >= 10) 
                        p.setStartDate(java.sql.Date.valueOf(startStr.substring(0, 10)));
                        
                    String endStr = rs.getString("end_date");
                    if (endStr != null && endStr.length() >= 10) 
                        p.setEndDate(java.sql.Date.valueOf(endStr.substring(0, 10)));
                    
                    results.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
    public void ensureSystemPolicy(String id, String name, String type) {
        String checkSql = "SELECT id FROM policies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    String insertSql = "INSERT INTO policies (id, policy_name, description, premium_amount, coverage_duration, policy_type, insurance_company_id, status, created_at, updated_at) " +
                                     "VALUES (?, ?, 'System Regulatory Policy', 0, 'N/A', ?, 'NIC-SYSTEM', 'active', datetime('now'), datetime('now'))";
                    try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql)) {
                        insertPstmt.setString(1, id);
                        insertPstmt.setString(2, name);
                        insertPstmt.setString(3, type);
                        insertPstmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
