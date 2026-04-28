package com.insurance.model;

import java.sql.Timestamp;

public class DashboardActivity {
    private String title;
    private String description;
    private Timestamp timestamp;
    private String icon;
    private String colorClass;

    public DashboardActivity() {}

    public DashboardActivity(String title, String description, Timestamp timestamp, String icon, String colorClass) {
        this.title = title;
        this.description = description;
        this.timestamp = timestamp;
        this.icon = icon;
        this.colorClass = colorClass;
    }

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getColorClass() {
        return colorClass;
    }

    public void setColorClass(String colorClass) {
        this.colorClass = colorClass;
    }
}
