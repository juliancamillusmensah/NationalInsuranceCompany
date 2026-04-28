package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.util.EmailService;
import com.insurance.util.SMSService;
import com.insurance.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    public List<Notification> getNotificationsByUserId(String userId) {
        List<Notification> notes = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification note = new Notification();
                    note.setId(rs.getString("id"));
                    note.setUserId(rs.getString("user_id"));
                    note.setTitle(rs.getString("title"));
                    note.setMessage(rs.getString("message"));
                    note.setType(rs.getString("type"));
                    note.setRead(rs.getInt("is_read") == 1);
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    notes.add(note);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notes;
    }

    public int getUnreadCount(String userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
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

    public boolean addNotification(Notification note) {
        String id = "NOTE-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO notifications (id, user_id, title, message, type, created_at) VALUES (?, ?, ?, ?, ?, datetime('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, note.getUserId());
            pstmt.setString(3, note.getTitle());
            pstmt.setString(4, note.getMessage());
            pstmt.setString(5, note.getType());
            boolean inserted = pstmt.executeUpdate() > 0;

            // Send email notification alongside in-app notification
            if (inserted) {
                String userEmail = getUserEmail(note.getUserId());
                if (userEmail != null && !userEmail.isEmpty()) {
                    try {
                        EmailService.sendNotificationEmail(userEmail, note.getTitle(), note.getMessage(), note.getType());
                    } catch (Exception e) {
                        System.err.println("WARNING: Failed to send email notification: " + e.getMessage());
                    }
                }
                // Send SMS notification alongside email and in-app
                String userPhone = getUserPhone(note.getUserId());
                if (userPhone != null && !userPhone.isEmpty()) {
                    try {
                        SMSService.sendNotificationSMS(userPhone, note.getTitle(), note.getMessage());
                    } catch (Exception e) {
                        System.err.println("WARNING: Failed to send SMS notification: " + e.getMessage());
                    }
                }
            }

            return inserted;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String getUserEmail(String userId) {
        String sql = "SELECT email FROM Account WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("email");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private String getUserPhone(String userId) {
        // First try AccountPhone table
        String sql = "SELECT phone_number FROM AccountPhone WHERE account_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String phone = rs.getString("phone_number");
                    if (phone != null && !phone.trim().isEmpty()) {
                        return phone.trim();
                    }
                }
            }
        } catch (SQLException e) {
            // Table might not exist, fallback to Account table
        }
        // Fallback: check if Account table has a phone column (some migrations add it)
        try {
            String sql2 = "SELECT phone FROM Account WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql2)) {
                pstmt.setString(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        String phone = rs.getString("phone");
                        if (phone != null && !phone.trim().isEmpty()) {
                            return phone.trim();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        return null;
    }

    public boolean markAsRead(String notificationId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, notificationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearAllNotifications(String userId) {
        String sql = "DELETE FROM notifications WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            return pstmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
