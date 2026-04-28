package com.insurance.dao;

import com.insurance.util.DBConnection;
import java.sql.*;

public class SystemDAO {
    public int getSettingsCount() {
        String sql = "SELECT COUNT(*) FROM system_settings";
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

    public int getInvitationCount() {
        String sql = "SELECT COUNT(*) FROM admin_invitations";
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

    public java.util.List<com.insurance.model.AdminInvitation> getAllInvitations() {
        java.util.List<com.insurance.model.AdminInvitation> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM admin_invitations ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    com.insurance.model.AdminInvitation inv = new com.insurance.model.AdminInvitation(
                        rs.getString("id"),
                        rs.getString("email"),
                        rs.getString("company_id"),
                        rs.getString("invite_token"),
                        rs.getTimestamp("expires_at"),
                        rs.getBoolean("is_used"),
                        rs.getTimestamp("created_at"),
                        rs.getString("invited_role")
                    );
                    list.add(inv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.List<com.insurance.model.AdminInvitation> getInvitationsByCompanyId(String companyId) {
        java.util.List<com.insurance.model.AdminInvitation> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM admin_invitations WHERE company_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    com.insurance.model.AdminInvitation inv = new com.insurance.model.AdminInvitation(
                        rs.getString("id"),
                        rs.getString("email"),
                        rs.getString("company_id"),
                        rs.getString("invite_token"),
                        rs.getTimestamp("expires_at"),
                        rs.getBoolean("is_used"),
                        rs.getTimestamp("created_at"),
                        rs.getString("invited_role")
                    );
                    list.add(inv);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createInvitation(com.insurance.model.AdminInvitation inv) {
        String id = "INV-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO admin_invitations (id, email, company_id, invite_token, expires_at, is_used, invited_role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, inv.getEmail());
            pstmt.setString(3, inv.getCompanyId());
            pstmt.setString(4, inv.getInviteToken());
            pstmt.setTimestamp(5, inv.getExpiresAt());
            pstmt.setBoolean(6, inv.isUsed());
            pstmt.setString(7, inv.getInvitedRole());
            int affected = pstmt.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInvitation(String id) {
        String sql = "DELETE FROM admin_invitations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            int affected = pstmt.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public com.insurance.model.AdminInvitation getInvitationById(int id) {
        String sql = "SELECT * FROM admin_invitations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new com.insurance.model.AdminInvitation(
                        rs.getString("id"),
                        rs.getString("email"),
                        rs.getString("company_id"),
                        rs.getString("invite_token"),
                        rs.getTimestamp("expires_at"),
                        rs.getBoolean("is_used"),
                        rs.getTimestamp("created_at"),
                        rs.getString("invited_role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public com.insurance.model.AdminInvitation getInvitationByToken(String token) {
        String sql = "SELECT * FROM admin_invitations WHERE invite_token = ? AND is_used = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, token);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new com.insurance.model.AdminInvitation(
                        rs.getString("id"),
                        rs.getString("email"),
                        rs.getString("company_id"),
                        rs.getString("invite_token"),
                        rs.getTimestamp("expires_at"),
                        rs.getBoolean("is_used"),
                        rs.getTimestamp("created_at"),
                        rs.getString("invited_role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateInvitation(com.insurance.model.AdminInvitation inv) {
        String sql = "UPDATE admin_invitations SET email = ?, company_id = ?, invite_token = ?, expires_at = ?, is_used = ?, invited_role = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, inv.getEmail());
            pstmt.setString(2, inv.getCompanyId());
            pstmt.setString(3, inv.getInviteToken());
            pstmt.setTimestamp(4, inv.getExpiresAt());
            pstmt.setBoolean(5, inv.isUsed());
            pstmt.setString(6, inv.getInvitedRole());
            pstmt.setString(7, inv.getId());
            int affected = pstmt.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<com.insurance.model.DashboardActivity> getRecentActivitiesByCompany(int limit, String companyId) {
        java.util.List<com.insurance.model.DashboardActivity> activities = new java.util.ArrayList<>();
        
        // 1. Fetch New/Updated Policies (Definitions)
        String sqlPolicies = "SELECT policy_name, created_at, updated_at FROM policies WHERE insurance_company_id = ? ORDER BY updated_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlPolicies)) {
            pstmt.setString(1, companyId);
            pstmt.setInt(2, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp created = rs.getTimestamp("created_at");
                    Timestamp updated = rs.getTimestamp("updated_at");
                    if (updated == null) updated = created;
                    if (updated == null) continue;
                    
                    boolean isNew = created != null && Math.abs(updated.getTime() - created.getTime()) < 5000;
                    activities.add(new com.insurance.model.DashboardActivity(
                        (isNew ? "New Policy: " : "Updated Policy: ") + rs.getString("policy_name"),
                        (isNew ? "Added to platform" : "Modified configuration"),
                        updated,
                        (isNew ? "add" : "edit"),
                        (isNew ? "bg-primary/10 text-primary" : "bg-amber-50 text-amber-600")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 2. Fetch New Enrollments / Cancellations
        String sqlEnrollments = "SELECT p.policy_name, cp.created_at, cp.policy_status FROM customer_policies cp JOIN policies p ON cp.policy_id = p.id WHERE p.insurance_company_id = ? ORDER BY cp.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlEnrollments)) {
            pstmt.setString(1, companyId);
            pstmt.setInt(2, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts == null) continue;
                    String status = rs.getString("policy_status");
                    boolean isCancelled = "cancelled".equalsIgnoreCase(status);
                    
                    activities.add(new com.insurance.model.DashboardActivity(
                        (isCancelled ? "Policy Cancelled" : "New Enrollment"),
                        rs.getString("policy_name"),
                        ts,
                        (isCancelled ? "cancel" : "person_add"),
                        (isCancelled ? "bg-slate-100 text-slate-500" : "bg-emerald-50 text-emerald-600")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 3. Fetch Recent Transactions
        String sqlTransactions = "SELECT p.policy_name, t.amount, t.transaction_date FROM transactions t JOIN policies p ON t.policy_id = p.id WHERE t.payment_status = 'successful' AND p.insurance_company_id = ? ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlTransactions)) {
            pstmt.setString(1, companyId);
            pstmt.setInt(2, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("transaction_date");
                    if (ts == null) continue;
                    activities.add(new com.insurance.model.DashboardActivity(
                        "Payment Received",
                        "GHS " + rs.getBigDecimal("amount") + " for " + rs.getString("policy_name"),
                        ts,
                        "payments",
                        "bg-blue-50 text-blue-600"
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 4. Fetch Recent Claims
        String sqlClaims = "SELECT p.policy_name, c.claim_amount, c.created_at FROM claims c JOIN policies p ON c.policy_id = p.id WHERE p.insurance_company_id = ? ORDER BY c.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlClaims)) {
            pstmt.setString(1, companyId);
            pstmt.setInt(2, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts == null) continue;
                    activities.add(new com.insurance.model.DashboardActivity(
                        "New Claim Filed",
                        "GHS " + rs.getBigDecimal("claim_amount") + " on " + rs.getString("policy_name"),
                        ts,
                        "assignment_late",
                        "bg-red-50 text-red-600"
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Sort all by timestamp descending, safely
        java.util.Collections.sort(activities, (a1, a2) -> {
            if (a1.getTimestamp() == null || a2.getTimestamp() == null) return 0;
            return a2.getTimestamp().compareTo(a1.getTimestamp());
        });

        // Return truncated list
        if (activities.size() > limit) {
            return activities.subList(0, limit);
        }
        return activities;
    }

    public com.insurance.model.CompanySettings getCompanySettings(String companyId) {
        String sql = "SELECT * FROM company_settings WHERE company_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new com.insurance.model.CompanySettings(
                        rs.getString("company_id"),
                        rs.getInt("daily_digest") == 1,
                        rs.getInt("financial_alerts") == 1,
                        rs.getInt("sms_notifications") == 1,
                        rs.getInt("hide_from_superadmin") == 1,
                        rs.getTimestamp("updated_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Return default settings if not found
        return new com.insurance.model.CompanySettings(companyId, true, true, false, false, null);
    }

    public boolean updateCompanySettings(com.insurance.model.CompanySettings settings) {
        String sql = "INSERT INTO company_settings (company_id, daily_digest, financial_alerts, sms_notifications, hide_from_superadmin, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT(company_id) DO UPDATE SET " +
                     "daily_digest = excluded.daily_digest, " +
                     "financial_alerts = excluded.financial_alerts, " +
                     "sms_notifications = excluded.sms_notifications, " +
                     "hide_from_superadmin = excluded.hide_from_superadmin, " +
                     "updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, settings.getCompanyId());
            pstmt.setInt(2, settings.isDailyDigest() ? 1 : 0);
            pstmt.setInt(3, settings.isFinancialAlerts() ? 1 : 0);
            pstmt.setInt(4, settings.isSmsNotifications() ? 1 : 0);
            pstmt.setInt(5, settings.isHideFromSuperadmin() ? 1 : 0);
            int affected = pstmt.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getRoleIdByName(String roleName) {
        if (roleName == null) return "ROLE_CUSTOMER";
        String normalized = roleName.trim().toLowerCase().replace(" ", "").replace("_", "");
        
        if (normalized.equals("systemcreator")) return "ROLE_SYSTEM_CREATOR";
        if (normalized.equals("superadmin")) return "ROLE_SUPERADMIN";
        if (normalized.equals("admin") || normalized.equals("companyadmin")) return "ROLE_ADMIN";
        if (normalized.equals("support")) return "ROLE_SUPPORT";
        if (normalized.equals("auditor")) return "ROLE_AUDITOR";
        if (normalized.equals("customer")) return "ROLE_CUSTOMER";
        
        return "ROLE_CUSTOMER"; // Secure fallback
    }

    public String getCompanyIdByUserId(String userId) {
        String sql = "SELECT company_id FROM company_admins WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("company_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public java.util.List<com.insurance.model.TeamMember> getTeamMembersByCompanyId(String companyId) {
        java.util.List<com.insurance.model.TeamMember> list = new java.util.ArrayList<>();
        String sql = "SELECT a.id, a.full_name, a.email, a.role_id, a.created_at, a.status, r.role_name " +
                     "FROM Account a " +
                     "JOIN company_admins ca ON a.id = ca.user_id " +
                     "JOIN roles r ON a.role_id = r.id " +
                     "WHERE ca.company_id = ? " +
                     "ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new com.insurance.model.TeamMember(
                        rs.getString("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("role_name"),
                        rs.getString("role_id"),
                        rs.getTimestamp("created_at"),
                        rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public java.util.List<com.insurance.model.DashboardActivity> getRecentActivities(int limit) {
        java.util.List<com.insurance.model.DashboardActivity> activities = new java.util.ArrayList<>();
        
        // 1. Fetch New/Updated Policies (Definitions)
        String sqlPolicies = "SELECT policy_name, created_at, updated_at FROM policies ORDER BY updated_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlPolicies)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp created = rs.getTimestamp("created_at");
                    Timestamp updated = rs.getTimestamp("updated_at");
                    if (updated == null) updated = created;
                    if (updated == null) continue;
                    
                    boolean isNew = created != null && Math.abs(updated.getTime() - created.getTime()) < 5000;
                    activities.add(new com.insurance.model.DashboardActivity(
                        (isNew ? "New Policy: " : "Updated Policy: ") + rs.getString("policy_name"),
                        (isNew ? "Added to platform" : "Modified configuration"),
                        updated,
                        (isNew ? "add" : "edit"),
                        (isNew ? "bg-primary/10 text-primary" : "bg-amber-50 text-amber-600")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 2. Fetch New Enrollments / Cancellations
        String sqlEnrollments = "SELECT p.policy_name, cp.created_at, cp.policy_status FROM customer_policies cp JOIN policies p ON cp.policy_id = p.id ORDER BY cp.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlEnrollments)) {
            pstmt.setInt(1, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts == null) continue;
                    String status = rs.getString("policy_status");
                    boolean isCancelled = "cancelled".equalsIgnoreCase(status);
                    
                    activities.add(new com.insurance.model.DashboardActivity(
                        (isCancelled ? "Policy Cancelled" : "New Enrollment"),
                        rs.getString("policy_name"),
                        ts,
                        (isCancelled ? "cancel" : "person_add"),
                        (isCancelled ? "bg-slate-100 text-slate-500" : "bg-emerald-50 text-emerald-600")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 3. Fetch Recent Transactions
        String sqlTransactions = "SELECT p.policy_name, t.amount, t.transaction_date FROM transactions t JOIN policies p ON t.policy_id = p.id WHERE t.payment_status = 'successful' ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlTransactions)) {
            pstmt.setInt(1, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("transaction_date");
                    if (ts == null) continue;
                    activities.add(new com.insurance.model.DashboardActivity(
                        "Payment Received",
                        "GHS " + rs.getBigDecimal("amount") + " for " + rs.getString("policy_name"),
                        ts,
                        "payments",
                        "bg-blue-50 text-blue-600"
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // 4. Fetch Recent Claims
        String sqlClaims = "SELECT p.policy_name, c.claim_amount, c.created_at FROM claims c JOIN policies p ON c.policy_id = p.id ORDER BY c.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlClaims)) {
            pstmt.setInt(1, limit * 2);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts == null) continue;
                    activities.add(new com.insurance.model.DashboardActivity(
                        "New Claim Filed",
                        "GHS " + rs.getBigDecimal("claim_amount") + " on " + rs.getString("policy_name"),
                        ts,
                        "assignment_late",
                        "bg-red-50 text-red-600"
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Sort all by timestamp descending, safely
        java.util.Collections.sort(activities, (a1, a2) -> {
            if (a1.getTimestamp() == null || a2.getTimestamp() == null) return 0;
            return a2.getTimestamp().compareTo(a1.getTimestamp());
        });

        // Return truncated list
        if (activities.size() > limit) {
            return activities.subList(0, limit);
        }
        return activities;
    }
    public java.util.List<com.insurance.model.SystemSetting> getAllSystemSettings() {
        java.util.List<com.insurance.model.SystemSetting> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM system_settings ORDER BY setting_key ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new com.insurance.model.SystemSetting(
                    rs.getInt("id"),
                    rs.getString("setting_key"),
                    rs.getString("setting_value"),
                    rs.getTimestamp("updated_at")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String getSystemSetting(String key) {
        String sql = "SELECT setting_value FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, key);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("setting_value");
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateSystemSetting(String key, String value) {
        String sql = "UPDATE system_settings SET setting_value = ?, updated_at = CURRENT_TIMESTAMP WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, value);
            pstmt.setString(2, key);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean addSystemSetting(String key, String value) {
        String sql = "INSERT INTO system_settings (setting_key, setting_value, updated_at) VALUES (?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, key);
            pstmt.setString(2, value);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean upsertSystemSetting(String key, String value) {
        // Try update first; if 0 rows affected, do insert
        String updateSql = "UPDATE system_settings SET setting_value = ? WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            pstmt.setString(1, value);
            pstmt.setString(2, key);
            if (pstmt.executeUpdate() > 0) return true;
        } catch (SQLException e) { /* fall through to insert */ }

        String insertSql = "INSERT INTO system_settings (setting_key, setting_value) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            pstmt.setString(1, key);
            pstmt.setString(2, value);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteSystemSetting(String key) {
        String sql = "DELETE FROM system_settings WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, key);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public java.util.List<com.insurance.model.SystemLog> getGlobalActivityLogs(int limit) {
        java.util.List<com.insurance.model.SystemLog> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM system_logs ORDER BY timestamp DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new com.insurance.model.SystemLog(
                        rs.getString("id"),
                        rs.getString("user_id"),
                        rs.getString("activity"),
                        rs.getString("details"),
                        rs.getTimestamp("timestamp"),
                        rs.getString("type"),
                        rs.getString("impact")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public void logActivity(String userId, String activity, String details, String type, String impact) {
        String id = "LOG-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO system_logs (id, user_id, activity, details, type, impact) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, userId);
            pstmt.setString(3, activity);
            pstmt.setString(4, details);
            pstmt.setString(5, type);
            pstmt.setString(6, impact);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public java.util.List<com.insurance.model.Permission> getAllPermissions() {
        java.util.List<com.insurance.model.Permission> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM permissions ORDER BY module, permission_name";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new com.insurance.model.Permission(
                    rs.getString("id"),
                    rs.getString("permission_name"),
                    rs.getString("module")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public java.util.Map<String, java.util.List<String>> getRolePermissionsMap() {
        java.util.Map<String, java.util.List<String>> map = new java.util.HashMap<>();
        String sql = "SELECT role_id, permission_id FROM role_permissions";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                String roleId = rs.getString("role_id");
                String permId = rs.getString("permission_id");
                
                if (roleId != null && permId != null) {
                    map.computeIfAbsent(roleId, k -> new java.util.ArrayList<>()).add(permId);
                }
            }
        } catch (SQLException e) { 
            System.err.println("ERROR: getRolePermissionsMap failed: " + e.getMessage());
            e.printStackTrace(); 
        }
        return map;
    }

    public boolean updateRolePermission(String roleId, String permissionId, boolean enabled) {
        String sql = enabled ? 
            "INSERT OR IGNORE INTO role_permissions (role_id, permission_id) VALUES (?, ?)" :
            "DELETE FROM role_permissions WHERE role_id = ? AND permission_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roleId);
            pstmt.setString(2, permissionId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public java.util.List<com.insurance.model.Role> getAllRoles() {
        java.util.List<com.insurance.model.Role> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM roles ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new com.insurance.model.Role(
                    rs.getString("id"),
                    rs.getString("role_name"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
