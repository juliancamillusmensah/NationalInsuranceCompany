package com.insurance.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Claim {
    private String id;
    private String userId;
    private String policyId;
    private String policyName;
    private BigDecimal claimAmount;
    private String description;
    private String incidentDate;
    private String status;
    private Timestamp createdAt;
    private String userName;
    private String userEmail;

    private Timestamp acknowledgedAt;
    private Timestamp docsSubmittedAt;
    private Timestamp dischargeVoucherAt;
    private Timestamp settledAt;
    private String rejectionReason;
    private String assignedAdjuster;
    private String documentPath;

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getPolicyId() { return policyId; }
    public void setPolicyId(String policyId) { this.policyId = policyId; }

    public String getPolicyName() { return policyName; }
    public void setPolicyName(String policyName) { this.policyName = policyName; }

    public BigDecimal getClaimAmount() { return claimAmount; }
    public void setClaimAmount(BigDecimal claimAmount) { this.claimAmount = claimAmount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIncidentDate() { return incidentDate; }
    public void setIncidentDate(String incidentDate) { this.incidentDate = incidentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public Timestamp getAcknowledgedAt() { return acknowledgedAt; }
    public void setAcknowledgedAt(Timestamp acknowledgedAt) { this.acknowledgedAt = acknowledgedAt; }

    public Timestamp getDocsSubmittedAt() { return docsSubmittedAt; }
    public void setDocsSubmittedAt(Timestamp docsSubmittedAt) { this.docsSubmittedAt = docsSubmittedAt; }

    public Timestamp getDischargeVoucherAt() { return dischargeVoucherAt; }
    public void setDischargeVoucherAt(Timestamp dischargeVoucherAt) { this.dischargeVoucherAt = dischargeVoucherAt; }

    public Timestamp getSettledAt() { return settledAt; }
    public void setSettledAt(Timestamp settledAt) { this.settledAt = settledAt; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public String getAssignedAdjuster() { return assignedAdjuster; }
    public void setAssignedAdjuster(String assignedAdjuster) { this.assignedAdjuster = assignedAdjuster; }

    public String getDocumentPath() { return documentPath; }
    public void setDocumentPath(String documentPath) { this.documentPath = documentPath; }
}
