package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class SearchDAO {

    public Map<String, List<?>> globalSearch(String query, String companyId) {
        Map<String, List<?>> results = new HashMap<>();
        String likeQuery = "%" + query + "%";

        results.put("companies", searchCompanies(likeQuery, companyId));
        results.put("policies", searchPolicies(likeQuery, companyId));
        results.put("claims", searchClaims(likeQuery, companyId));
        results.put("registry", searchRegistry(likeQuery)); // Registry is global

        return results;
    }

    private List<GhanaRegistryEntry> searchRegistry(String query) {
        List<GhanaRegistryEntry> list = new ArrayList<>();
        String sql = "SELECT * FROM ghana_insurance_registry WHERE company_name LIKE ? OR official_email LIKE ? LIMIT 50";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, query);
            pstmt.setString(2, query);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    GhanaRegistryEntry e = new GhanaRegistryEntry();
                    e.setId(rs.getString("id"));
                    e.setCompanyName(rs.getString("company_name"));
                    e.setOfficialEmail(rs.getString("official_email"));
                    e.setOfficialPhone(rs.getString("official_phone"));
                    e.setHeadquarters(rs.getString("headquarters"));
                    e.setType(rs.getString("type"));
                    e.setLicenseNumber(rs.getString("license_number"));
                    e.setLicenseExpiry(rs.getString("license_expiry"));
                    e.setComplianceStatus(rs.getString("compliance_status"));
                    e.setTin(rs.getString("tin"));
                    list.add(e);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Company> searchCompanies(String query, String companyId) {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM insurance_companies WHERE (company_name LIKE ? OR email LIKE ?) ";
        if (companyId != null) {
            sql += " AND id = ? ";
        }
        sql += " LIMIT 50";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, query);
            pstmt.setString(2, query);
            if (companyId != null) pstmt.setString(3, companyId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Company c = new Company();
                    c.setId(rs.getString("id"));
                    c.setName(rs.getString("company_name"));
                    c.setEmail(rs.getString("email"));
                    c.setPhoneNumber(rs.getString("phone_number"));
                    c.setStatus(rs.getString("status"));
                    c.setCompanyType(rs.getString("company_type"));
                    c.setLicenseNumber(rs.getString("license_number"));
                    c.setComplianceStatus(rs.getString("compliance_status"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Policy> searchPolicies(String query, String companyId) {
        List<Policy> list = new ArrayList<>();
        String sql = "SELECT * FROM policies WHERE (policy_name LIKE ? OR description LIKE ?) ";
        if (companyId != null) {
            sql += " AND insurance_company_id = ? ";
        }
        sql += " LIMIT 50";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, query);
            pstmt.setString(2, query);
            if (companyId != null) pstmt.setString(3, companyId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Policy p = new Policy();
                    p.setId(rs.getString("id"));
                    p.setPolicyName(rs.getString("policy_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPolicyType(rs.getString("policy_type"));
                    p.setStatus(rs.getString("status"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Claim> searchClaims(String query, String companyId) {
        List<Claim> list = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_name FROM claims c " +
                     "JOIN policies p ON c.policy_id = p.id " +
                     "WHERE (c.id LIKE ? OR c.description LIKE ?) ";
        if (companyId != null) {
            sql += " AND p.insurance_company_id = ? ";
        }
        sql += " LIMIT 50";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, query);
            pstmt.setString(2, query);
            if (companyId != null) pstmt.setString(3, companyId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Claim c = new Claim();
                    c.setId(rs.getString("id"));
                    c.setPolicyName(rs.getString("policy_name"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
