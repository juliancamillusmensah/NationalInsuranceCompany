package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Publication;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PublicationDAO {

    public PublicationDAO() {
        createTableIfNotExists();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS publications (" +
                "id TEXT PRIMARY KEY, " +
                "title TEXT NOT NULL, " +
                "category TEXT NOT NULL, " +
                "year TEXT, " +
                "description TEXT, " +
                "file_url TEXT, " +
                "file_size TEXT, " +
                "uploaded_at TIMESTAMP DEFAULT (datetime('now'))" +
                ")";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Publication> getAllPublications() {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publications ORDER BY year DESC, uploaded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Publication> getPublicationsByCategory(String category) {
        List<Publication> list = new ArrayList<>();
        String sql = "SELECT * FROM publications WHERE category = ? ORDER BY year DESC, uploaded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addPublication(Publication p) {
        if (p.getId() == null || p.getId().isEmpty()) {
            p.setId("PUB-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        String sql = "INSERT INTO publications (id, title, category, year, description, file_url, file_size, uploaded_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, datetime('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, p.getId());
            pstmt.setString(2, p.getTitle());
            pstmt.setString(3, p.getCategory());
            pstmt.setString(4, p.getYear());
            pstmt.setString(5, p.getDescription());
            pstmt.setString(6, p.getFileUrl());
            pstmt.setString(7, p.getFileSize());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePublication(String id) {
        String sql = "DELETE FROM publications WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Publication mapRow(ResultSet rs) throws SQLException {
        Publication p = new Publication();
        p.setId(rs.getString("id"));
        p.setTitle(rs.getString("title"));
        p.setCategory(rs.getString("category"));
        p.setYear(rs.getString("year"));
        p.setDescription(rs.getString("description"));
        p.setFileUrl(rs.getString("file_url"));
        p.setFileSize(rs.getString("file_size"));
        p.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return p;
    }
}
