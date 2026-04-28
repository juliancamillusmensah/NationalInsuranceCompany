package com.insurance.model;

import java.sql.Timestamp;

public class AdminInvitation {
    private String id;
    private String email;
    private String companyId;
    private String inviteToken;
    private Timestamp expiresAt;
    private boolean isUsed;
    private Timestamp createdAt;
    private String invitedRole;

    public AdminInvitation() {
    }

    public AdminInvitation(String id, String email, String companyId, String inviteToken, Timestamp expiresAt, boolean isUsed, Timestamp createdAt, String invitedRole) {
        this.id = id;
        this.email = email;
        this.companyId = companyId;
        this.inviteToken = inviteToken;
        this.expiresAt = expiresAt;
        this.isUsed = isUsed;
        this.createdAt = createdAt;
        this.invitedRole = invitedRole;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getInviteToken() {
        return inviteToken;
    }

    public void setInviteToken(String inviteToken) {
        this.inviteToken = inviteToken;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getInvitedRole() {
        return invitedRole;
    }

    public void setInvitedRole(String invitedRole) {
        this.invitedRole = invitedRole;
    }
}
