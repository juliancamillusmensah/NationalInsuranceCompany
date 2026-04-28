package com.insurance.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class MarketFinancials {
    private int id;
    private String companyId;
    private String sector;
    private int reportingYear;
    private BigDecimal commissionIncome;
    private BigDecimal adminExp;
    private BigDecimal operationalResults;
    private BigDecimal investmentIncome;
    private BigDecimal profitLossAfterTax;
    private Timestamp updatedAt;

    public MarketFinancials() {}

    public MarketFinancials(String companyId, String sector, int reportingYear) {
        this.companyId = companyId;
        this.sector = sector;
        this.reportingYear = reportingYear;
        this.commissionIncome = BigDecimal.ZERO;
        this.adminExp = BigDecimal.ZERO;
        this.operationalResults = BigDecimal.ZERO;
        this.investmentIncome = BigDecimal.ZERO;
        this.profitLossAfterTax = BigDecimal.ZERO;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }

    public String getSector() { return sector; }
    public void setSector(String sector) { this.sector = sector; }

    public int getReportingYear() { return reportingYear; }
    public void setReportingYear(int reportingYear) { this.reportingYear = reportingYear; }

    public BigDecimal getCommissionIncome() { return commissionIncome; }
    public void setCommissionIncome(BigDecimal commissionIncome) { this.commissionIncome = commissionIncome; }

    public BigDecimal getAdminExp() { return adminExp; }
    public void setAdminExp(BigDecimal adminExp) { this.adminExp = adminExp; }

    public BigDecimal getOperationalResults() { return operationalResults; }
    public void setOperationalResults(BigDecimal operationalResults) { this.operationalResults = operationalResults; }

    public BigDecimal getInvestmentIncome() { return investmentIncome; }
    public void setInvestmentIncome(BigDecimal investmentIncome) { this.investmentIncome = investmentIncome; }

    public BigDecimal getProfitLossAfterTax() { return profitLossAfterTax; }
    public void setProfitLossAfterTax(BigDecimal profitLossAfterTax) { this.profitLossAfterTax = profitLossAfterTax; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
