package com.insurance.model;

public class Permission {
    private String id;
    private String permissionName;
    private String module;

    public Permission() {}

    public Permission(String id, String permissionName, String module) {
        this.id = id;
        this.permissionName = permissionName;
        this.module = module;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getPermissionName() { return permissionName; }
    public void setPermissionName(String permissionName) { this.permissionName = permissionName; }
    public String getModule() { return module; }
    public void setModule(String module) { this.module = module; }
}
