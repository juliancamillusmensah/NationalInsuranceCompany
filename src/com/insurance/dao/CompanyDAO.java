package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Company;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {
    public int getCompanyCount() {
        String sql = "SELECT COUNT(*) FROM insurance_companies";
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

    public List<Company> getAllCompanies() {
        List<Company> companies = new ArrayList<>();
        String sql = "SELECT * FROM insurance_companies ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Company c = new Company();
                c.setId(rs.getString("id"));
                c.setName(rs.getString("company_name"));
                c.setEmail(rs.getString("email"));
                c.setPhoneNumber(rs.getString("phone_number"));
                c.setAddress(rs.getString("address"));
                c.setStatus(rs.getString("status"));
                c.setCompanyType(rs.getString("company_type"));
                c.setLicenseNumber(rs.getString("license_number"));
                c.setLicenseExpiry(rs.getString("license_expiry"));
                c.setComplianceStatus(rs.getString("compliance_status"));
                c.setTin(rs.getString("tin"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));
                companies.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return companies;
    }

    public boolean addCompany(Company c) {
        if (c.getId() == null || c.getId().isEmpty()) {
            c.setId("COMP-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        String sql = "INSERT INTO insurance_companies (id, company_name, email, phone_number, address, status, company_type, license_number, license_expiry, compliance_status, tin, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'), datetime('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, c.getId());
            pstmt.setString(2, c.getName());
            pstmt.setString(3, c.getEmail());
            pstmt.setString(4, c.getPhoneNumber());
            pstmt.setString(5, c.getAddress());
            pstmt.setString(6, c.getStatus() != null ? c.getStatus() : "Active");
            pstmt.setString(7, c.getCompanyType() != null ? c.getCompanyType() : "Non-Life");
            pstmt.setString(8, c.getLicenseNumber() != null ? c.getLicenseNumber() : "NIC-TBD");
            pstmt.setString(9, c.getLicenseExpiry());
            pstmt.setString(10, c.getComplianceStatus() != null ? c.getComplianceStatus() : "Compliant");
            pstmt.setString(11, c.getTin());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCompany(Company c) {
        String sql = "UPDATE insurance_companies SET company_name = ?, email = ?, phone_number = ?, address = ?, status = ?, company_type = ?, license_number = ?, license_expiry = ?, compliance_status = ?, tin = ?, updated_at = datetime('now') WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, c.getName());
            pstmt.setString(2, c.getEmail());
            pstmt.setString(3, c.getPhoneNumber());
            pstmt.setString(4, c.getAddress());
            pstmt.setString(5, c.getStatus());
            pstmt.setString(6, c.getCompanyType());
            pstmt.setString(7, c.getLicenseNumber());
            pstmt.setString(8, c.getLicenseExpiry());
            pstmt.setString(9, c.getComplianceStatus());
            pstmt.setString(10, c.getTin());
            pstmt.setString(11, c.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Company getCompanyById(String id) {
        String sql = "SELECT * FROM insurance_companies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Company c = new Company();
                    c.setId(rs.getString("id"));
                    c.setName(rs.getString("company_name"));
                    c.setEmail(rs.getString("email"));
                    c.setPhoneNumber(rs.getString("phone_number"));
                    c.setAddress(rs.getString("address"));
                    c.setStatus(rs.getString("status"));
                    c.setCompanyType(rs.getString("company_type"));
                    c.setLicenseNumber(rs.getString("license_number"));
                    c.setLicenseExpiry(rs.getString("license_expiry"));
                    c.setComplianceStatus(rs.getString("compliance_status"));
                    c.setTin(rs.getString("tin"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateComplianceStatus(String id, String status) {
        String sql = "UPDATE insurance_companies SET compliance_status = ?, updated_at = datetime('now') WHERE id = ?";
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

    public boolean renewLicense(String id, String newExpiryDate) {
        String sql = "UPDATE insurance_companies SET license_expiry = ?, compliance_status = 'Compliant', updated_at = datetime('now') WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newExpiryDate);
            pstmt.setString(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
