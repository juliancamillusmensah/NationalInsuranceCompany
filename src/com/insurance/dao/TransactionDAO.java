package com.insurance.dao;

import com.insurance.util.DBConnection;
import com.insurance.model.Transaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;

public class TransactionDAO {
    public int getTransactionCountByStatusAndCompany(String status, String companyId) {
        String sql = "SELECT COUNT(*) FROM transactions t " +
                     "JOIN policies p ON t.policy_id = p.id " +
                     "WHERE t.payment_status = ? AND p.insurance_company_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, companyId);
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

    public List<Transaction> getTransactionsByUserId(String userId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, p.policy_name, cp.policy_status " +
                "FROM transactions t " +
                "JOIN policies p ON t.policy_id = p.id " +
                "LEFT JOIN customer_policies cp ON t.user_id = cp.user_id AND t.policy_id = cp.policy_id " +
                "WHERE t.user_id = ? " +
                "ORDER BY t.transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getString("id"));
                    t.setPolicyName(rs.getString("policy_name"));
                    t.setPolicyStatus(rs.getString("policy_status"));
                    t.setAmount(rs.getBigDecimal("amount"));
                    t.setTransactionType(rs.getString("transaction_type"));
                    t.setPaymentMethod(rs.getString("payment_method"));
                    t.setPaymentStatus(rs.getString("payment_status"));
                    t.setTransactionDate(rs.getTimestamp("transaction_date"));
                    transactions.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    public boolean recordTransaction(String userId, String policyId, java.math.BigDecimal amount, String transactionType) {
        return recordTransaction(userId, policyId, amount, transactionType, "System Renewal");
    }

    public boolean recordTransaction(String userId, String policyId, java.math.BigDecimal amount, String transactionType, String paymentMethod) {
        String id = "TXN-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String sql = "INSERT INTO transactions (id, user_id, policy_id, amount, transaction_type, payment_method, payment_status, transaction_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'successful', datetime('now'))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, userId);
            pstmt.setString(3, policyId);
            pstmt.setBigDecimal(4, amount);
            pstmt.setString(5, transactionType); // "Enrollment" or "Renewal"
            pstmt.setString(6, paymentMethod != null ? paymentMethod : "Credit Card");
            boolean success = pstmt.executeUpdate() > 0;
            if (success) {
                // Tally into market financials (Skip for Regulatory Fees)
                if (!"NIC-LICENSE-FEE".equals(policyId)) {
                    try {
                        PolicyDAO policyDAO = new PolicyDAO();
                        com.insurance.model.Policy p = policyDAO.getPolicyById(policyId);
                        if (p != null) {
                            FinancialDAO financialDAO = new FinancialDAO();
                            int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                            financialDAO.tallyFromTransaction(p.getInsuranceCompanyId(), p.getPolicyType(), amount, currentYear);
                        }
                    } catch (Exception e) {
                        System.err.println("Failed to tally financial data: " + e.getMessage());
                    }
                }
            }
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Transaction> getTransactionsByCompanyId(String companyId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, p.policy_name, cp.policy_status, a.full_name, a.email " +
                "FROM transactions t " +
                "JOIN policies p ON t.policy_id = p.id " +
                "LEFT JOIN Account a ON t.user_id = a.id " +
                "LEFT JOIN customer_policies cp ON t.user_id = cp.user_id AND t.policy_id = cp.policy_id " +
                "WHERE p.insurance_company_id = ? " +
                "ORDER BY t.transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getString("id"));
                    t.setPolicyName(rs.getString("policy_name"));
                    t.setPolicyStatus(rs.getString("policy_status"));
                    t.setAmount(rs.getBigDecimal("amount"));
                    t.setTransactionType(rs.getString("transaction_type"));
                    t.setPaymentMethod(rs.getString("payment_method"));
                    t.setPaymentStatus(rs.getString("payment_status"));
                    t.setTransactionDate(rs.getTimestamp("transaction_date"));
                    t.setUserName(rs.getString("full_name"));
                    t.setUserEmail(rs.getString("email"));
                    transactions.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }

    public List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, p.policy_name, cp.policy_status, a.full_name, a.email " +
                "FROM transactions t " +
                "JOIN policies p ON t.policy_id = p.id " +
                "LEFT JOIN Account a ON t.user_id = a.id " +
                "LEFT JOIN customer_policies cp ON t.user_id = cp.user_id AND t.policy_id = cp.policy_id " +
                "ORDER BY t.transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Transaction t = new Transaction();
                t.setId(rs.getString("id"));
                t.setPolicyName(rs.getString("policy_name"));
                t.setPolicyStatus(rs.getString("policy_status"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTransactionType(rs.getString("transaction_type"));
                t.setPaymentMethod(rs.getString("payment_method"));
                t.setPaymentStatus(rs.getString("payment_status"));
                t.setTransactionDate(rs.getTimestamp("transaction_date"));
                t.setUserName(rs.getString("full_name"));
                t.setUserEmail(rs.getString("email"));
                transactions.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    public java.math.BigDecimal getRegulatoryRevenue() {
        String sql = "SELECT SUM(amount) FROM transactions WHERE policy_id = 'NIC-LICENSE-FEE' AND payment_status = 'successful'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                java.math.BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : java.math.BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
}
