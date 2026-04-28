package com.insurance.model;

import java.sql.Timestamp;

public class SystemLog {
    private String id;
    private String userId;
    private String activity;
    private String details;
    private Timestamp timestamp;
    private String type;
    private String impact;

    public SystemLog() {}

    public SystemLog(String id, String userId, String activity, String details, Timestamp timestamp, String type, String impact) {
        this.id = id;
        this.userId = userId;
        this.activity = activity;
        this.details = details;
        this.timestamp = timestamp;
        this.type = type;
        this.impact = impact;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getActivity() { return activity; }
    public void setActivity(String activity) { this.activity = activity; }
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    public Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(Timestamp timestamp) { this.timestamp = timestamp; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getImpact() { return impact; }
    public void setImpact(String impact) { this.impact = impact; }
}
