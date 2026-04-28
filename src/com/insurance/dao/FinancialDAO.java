package com.insurance.dao;

import com.insurance.model.MarketFinancials;
import com.insurance.util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FinancialDAO {

    public List<MarketFinancials> getFinancialsByYear(int year) {
        List<MarketFinancials> list = new ArrayList<>();
        String sql = "SELECT * FROM market_financials WHERE reporting_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, year);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFinancials(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public MarketFinancials getFinancials(String companyId, String sector, int year) {
        String sql = "SELECT * FROM market_financials WHERE company_id = ? AND sector = ? AND reporting_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            pstmt.setString(2, sector);
            pstmt.setInt(3, year);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFinancials(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateFinancials(MarketFinancials mf) {
        String sql = "INSERT INTO market_financials (company_id, sector, reporting_year, commission_income, admin_exp, operational_results, investment_income, profit_loss_after_tax, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT(company_id, reporting_year, sector) DO UPDATE SET " +
                     "commission_income = excluded.commission_income, " +
                     "admin_exp = excluded.admin_exp, " +
                     "operational_results = excluded.operational_results, " +
                     "investment_income = excluded.investment_income, " +
                     "profit_loss_after_tax = excluded.profit_loss_after_tax, " +
                     "updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, mf.getCompanyId());
            pstmt.setString(2, mf.getSector());
            pstmt.setInt(3, mf.getReportingYear());
            pstmt.setBigDecimal(4, mf.getCommissionIncome());
            pstmt.setBigDecimal(5, mf.getAdminExp());
            pstmt.setBigDecimal(6, mf.getOperationalResults());
            pstmt.setBigDecimal(7, mf.getInvestmentIncome());
            pstmt.setBigDecimal(8, mf.getProfitLossAfterTax());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean tallyFromTransaction(String companyId, String policyType, BigDecimal amount, int year) {
        String sector = determineSector(policyType);
        BigDecimal commission = amount.multiply(new BigDecimal("0.10")); // 10% default commission tally
        
        String sql = "INSERT INTO market_financials (company_id, sector, reporting_year, commission_income, operational_results, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT(company_id, reporting_year, sector) DO UPDATE SET " +
                     "commission_income = commission_income + excluded.commission_income, " +
                     "operational_results = operational_results + excluded.operational_results, " +
                     "updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, companyId);
            pstmt.setString(2, sector);
            pstmt.setInt(3, year);
            pstmt.setBigDecimal(4, commission);
            pstmt.setBigDecimal(5, amount); // Operational Results tallying total premiums/revenue
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String determineSector(String policyType) {
        if (policyType == null) return "NONLIFE";
        String pt = policyType.toUpperCase();
        if (pt.contains("LIFE")) return "LIFE";
        if (pt.contains("BROKER")) return "BROKER";
        return "NONLIFE";
    }

    private MarketFinancials mapResultSetToFinancials(ResultSet rs) throws SQLException {
        MarketFinancials mf = new MarketFinancials();
        mf.setId(rs.getInt("id"));
        mf.setCompanyId(rs.getString("company_id"));
        mf.setSector(rs.getString("sector"));
        mf.setReportingYear(rs.getInt("reporting_year"));
        mf.setCommissionIncome(rs.getBigDecimal("commission_income"));
        mf.setAdminExp(rs.getBigDecimal("admin_exp"));
        mf.setOperationalResults(rs.getBigDecimal("operational_results"));
        mf.setInvestmentIncome(rs.getBigDecimal("investment_income"));
        mf.setProfitLossAfterTax(rs.getBigDecimal("profit_loss_after_tax"));
        mf.setUpdatedAt(rs.getTimestamp("updated_at"));
        return mf;
    }
}
