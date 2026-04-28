package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Enquiry;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {

    public ContactDAO() {
        initializeTable();
    }

    private void initializeTable() {
        String sql = "CREATE TABLE IF NOT EXISTS contact_enquiries (" +
                     "id TEXT PRIMARY KEY, " +
                     "full_name TEXT NOT NULL, " +
                     "email TEXT NOT NULL, " +
                     "subject TEXT, " +
                     "message TEXT, " +
                     "created_at DATETIME DEFAULT CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean saveEnquiry(Enquiry enquiry) {
        String id = "ENQ-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO contact_enquiries (id, full_name, email, subject, message) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, enquiry.getFullName());
            pstmt.setString(3, enquiry.getEmail());
            pstmt.setString(4, enquiry.getSubject());
            pstmt.setString(5, enquiry.getMessage());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Enquiry> getAllEnquiries() {
        List<Enquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_enquiries ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Enquiry e = new Enquiry();
                e.setId(rs.getString("id"));
                e.setFullName(rs.getString("full_name"));
                e.setEmail(rs.getString("email"));
                e.setSubject(rs.getString("subject"));
                e.setMessage(rs.getString("message"));
                e.setSubmittedAt(rs.getTimestamp("created_at"));
                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
