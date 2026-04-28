package com.insurance.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class CompanySettings implements Serializable {
    private String companyId;
    private boolean dailyDigest;
    private boolean financialAlerts;
    private boolean smsNotifications;
    private boolean hideFromSuperadmin;
    private Timestamp updatedAt;

    public CompanySettings() {}

    public CompanySettings(String companyId, boolean dailyDigest, boolean financialAlerts, boolean smsNotifications, boolean hideFromSuperadmin, Timestamp updatedAt) {
        this.companyId = companyId;
        this.dailyDigest = dailyDigest;
        this.financialAlerts = financialAlerts;
        this.smsNotifications = smsNotifications;
        this.hideFromSuperadmin = hideFromSuperadmin;
        this.updatedAt = updatedAt;
    }

    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }

    public boolean isDailyDigest() { return dailyDigest; }
    public void setDailyDigest(boolean dailyDigest) { this.dailyDigest = dailyDigest; }

    public boolean isFinancialAlerts() { return financialAlerts; }
    public void setFinancialAlerts(boolean financialAlerts) { this.financialAlerts = financialAlerts; }

    public boolean isSmsNotifications() { return smsNotifications; }
    public void setSmsNotifications(boolean smsNotifications) { this.smsNotifications = smsNotifications; }

    public boolean isHideFromSuperadmin() { return hideFromSuperadmin; }
    public void setHideFromSuperadmin(boolean hideFromSuperadmin) { this.hideFromSuperadmin = hideFromSuperadmin; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
