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
    private String roomNo;
    private String floorNo;
    private String itemName;

    // Constructor for Reports
    public Notification(int notificationId, String message, String type, boolean isRead, Timestamp createdAt, String locName, int itemLocId) {
        this.notificationId = notificationId;
        this.message = message;
        this.type = type;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.locName = locName;
        this.itemLocId = itemLocId;
        
        
    }
    // Constructor for quotation
    public Notification(int notificationId, String message, String type, boolean isRead, Timestamp createdAt, 
                           String locName, int itemLocId, String roomNo, String floorNo, String itemName) {
           this.notificationId = notificationId;
           this.message = message;
           this.type = type;
           this.isRead = isRead;
           this.createdAt = createdAt;
           this.locName = locName;
           this.itemLocId = itemLocId;
           this.roomNo = roomNo;
           this.floorNo = floorNo;
           this.itemName = itemName; 
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
    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public String getFloorNo() {
        return floorNo;
    }

    public void setFloorNo(String floorNo) {
        this.floorNo = floorNo;
    }
    public String getItemName() {
           return itemName;
       }

       public void setItemName(String itemName) {
           this.itemName = itemName;
       }
}
