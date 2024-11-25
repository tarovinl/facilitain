package sample.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private String message;
    private String type;
    private boolean isRead;
    private Timestamp createdAt;
    private String locName;
    private int itemLocId;

    // Constructor
    public Notification(int notificationId, String message, String type, boolean isRead, Timestamp createdAt, String locName, int itemLocId) {
        this.notificationId = notificationId;
        this.message = message;
        this.type = type;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.locName = locName;
        this.itemLocId = itemLocId;
    }

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public String getMessage() {
        return message;
    }

    public String getType() {
        return type;
    }

    public boolean getIsRead() { 
        return isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getLocName() {
        return locName;
    }

    public void setLocName(String locName) {
        this.locName = locName;
    }

    public int getItemLocId() {
        return itemLocId;
    }

    public void setItemLocId(int itemLocId) {
        this.itemLocId = itemLocId;
    }
}
