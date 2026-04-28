package com.insurance.model;

import java.sql.Timestamp;

public class TeamMember {
    private String id;
    private String fullName;
    private String email;
    private String roleName;
    private String roleId;
    private Timestamp joinedAt;
    private String status;

    public TeamMember() {}

    public TeamMember(String id, String fullName, String email, String roleName, String roleId, Timestamp joinedAt, String status) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.roleName = roleName;
        this.roleId = roleId;
        this.joinedAt = joinedAt;
        this.status = status;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getRoleId() { return roleId; }
    public void setRoleId(String roleId) { this.roleId = roleId; }

    public Timestamp getJoinedAt() { return joinedAt; }
    public void setJoinedAt(Timestamp joinedAt) { this.joinedAt = joinedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
