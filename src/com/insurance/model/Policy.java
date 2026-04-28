package com.insurance.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Policy {
    private String id;
    private String policyName;
    private String description;
    private BigDecimal premiumAmount;
    private String coverageDuration;
    private String status;
    private Date startDate; // From customer_policies
    private Date endDate; // From customer_policies
    private String policyStatus; // From customer_policies
    private String policyType; // e.g. Auto, Health, Life
    private int customerPolicyId; // The customer_policies.id
    private String insuranceCompanyId;
    private String imageUrl; // Optional custom image URL
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;
    private String insuredItem; // From customer_policies
    private String documentPath; // From customer_policies
    private String customerName; // Join from Account
    private String customerEmail; // Join from Account
    private String userId; // Join from Account
    private String kycStatus; // Join from Account
    private String kycDocumentPath; // Rename existing or add for KYC? Policy already has one for enrollment docs.
    private String kycPortraitPath; // Join from Account

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getKycStatus() { return kycStatus; }
    public void setKycStatus(String kycStatus) { this.kycStatus = kycStatus; }

    public String getKycPortraitPath() { return kycPortraitPath; }
    public void setKycPortraitPath(String kycPortraitPath) { this.kycPortraitPath = kycPortraitPath; }

    public String getKycDocumentPath() { return kycDocumentPath; }
    public void setKycDocumentPath(String kycDocumentPath) { this.kycDocumentPath = kycDocumentPath; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getInsuredItem() { return insuredItem; }
    public void setInsuredItem(String insuredItem) { this.insuredItem = insuredItem; }
    
    public String getDocumentPath() { return documentPath; }
    public void setDocumentPath(String documentPath) { this.documentPath = documentPath; }

    // Getters and Setters
    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getInsuranceCompanyId() {
        return insuranceCompanyId;
    }

    public void setInsuranceCompanyId(String insuranceCompanyId) {
        this.insuranceCompanyId = insuranceCompanyId;
    }

    public String getPolicyType() {
        return policyType;
    }

    public void setPolicyType(String policyType) {
        this.policyType = policyType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPolicyName() {
        return policyName;
    }

    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public String getCoverageDuration() {
        return coverageDuration;
    }

    public void setCoverageDuration(String coverageDuration) {
        this.coverageDuration = coverageDuration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getPolicyStatus() {
        return policyStatus;
    }

    public void setPolicyStatus(String policyStatus) {
        this.policyStatus = policyStatus;
    }

    public int getCustomerPolicyId() {
        return customerPolicyId;
    }

    public void setCustomerPolicyId(int customerPolicyId) {
        this.customerPolicyId = customerPolicyId;
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
