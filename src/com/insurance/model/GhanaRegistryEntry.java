package com.insurance.model;

import java.sql.Timestamp;

public class GhanaRegistryEntry {
    private String id;
    private String companyName;
    private String officialEmail;
    private String officialPhone;
    private String headquarters;
    private String type;
    private String licenseNumber;
    private String licenseExpiry;
    private String complianceStatus;
    private String tin;
    private Timestamp createdAt;

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getOfficialEmail() { return officialEmail; }
    public void setOfficialEmail(String officialEmail) { this.officialEmail = officialEmail; }

    public String getOfficialPhone() { return officialPhone; }
    public void setOfficialPhone(String officialPhone) { this.officialPhone = officialPhone; }

    public String getHeadquarters() { return headquarters; }
    public void setHeadquarters(String headquarters) { this.headquarters = headquarters; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getLicenseExpiry() { return licenseExpiry; }
    public void setLicenseExpiry(String licenseExpiry) { this.licenseExpiry = licenseExpiry; }

    public String getComplianceStatus() { return complianceStatus; }
    public void setComplianceStatus(String complianceStatus) { this.complianceStatus = complianceStatus; }

    public String getTin() { return tin; }
    public void setTin(String tin) { this.tin = tin; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
