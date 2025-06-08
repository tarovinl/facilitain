package sample.model;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

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
    private List<String> maintenanceItems; // For grouped maintenance notifications
    private String assignedUserName; // For assignment notifications

    // Constructor for Reports
    public Notification(int notificationId, String message, String type, boolean isRead, Timestamp createdAt, String locName, int itemLocId) {
        this.notificationId = notificationId;
        this.message = message;
        this.type = type;
        this.isRead = isRead;
        this.createdAt = createdAt;
        this.locName = locName;
        this.itemLocId = itemLocId;
        this.maintenanceItems = new ArrayList<>();
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
           this.maintenanceItems = new ArrayList<>();
       }

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public boolean getIsRead() { 
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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

    public List<String> getMaintenanceItems() {
        return maintenanceItems;
    }

    public void setMaintenanceItems(List<String> maintenanceItems) {
        this.maintenanceItems = maintenanceItems;
    }

    public String getAssignedUserName() {
        return assignedUserName;
    }

    public void setAssignedUserName(String assignedUserName) {
        this.assignedUserName = assignedUserName;
    }

    public boolean isGroupedMaintenance() {
        return "MAINTENANCE".equals(type) && !maintenanceItems.isEmpty();
    }

    public int getMaintenanceItemCount() {
        return maintenanceItems.size();
    }

    public boolean isAssignmentNotification() {
        return "ASSIGN".equals(type);
    }
}
