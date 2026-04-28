package com.insurance.model;

import java.sql.Timestamp;

public class Account {
    private String id;
    private String fullName;
    private String email;
    private String roleId;
    private String status;
    private String password;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // KYC Fields
    private String kycStatus;
    private String kycDocumentType;
    private String kycDocumentPath;
    private String kycPortraitPath;

    // Getters and Setters
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // KYC Getters and Setters
    public String getKycStatus() {
        return kycStatus;
    }

    public void setKycStatus(String kycStatus) {
        this.kycStatus = kycStatus;
    }

    public String getKycDocumentType() {
        return kycDocumentType;
    }

    public void setKycDocumentType(String kycDocumentType) {
        this.kycDocumentType = kycDocumentType;
    }

    public String getKycDocumentPath() {
        return kycDocumentPath;
    }

    public void setKycDocumentPath(String kycDocumentPath) {
        this.kycDocumentPath = kycDocumentPath;
    }

    public String getKycPortraitPath() {
        return kycPortraitPath;
    }

    public void setKycPortraitPath(String kycPortraitPath) {
        this.kycPortraitPath = kycPortraitPath;
    }
}
