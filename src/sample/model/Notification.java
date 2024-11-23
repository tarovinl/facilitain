package sample.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private String message;
    private String type;
    private boolean isRead;
    private Timestamp createdAt;
    private String locName;

    // Constructors
    public Notification(int notificationId, String message, String type, boolean isRead, Timestamp createdAt, String locName) {
          this.notificationId = notificationId;
          this.message = message;
          this.type = type;
          this.isRead = isRead;
          this.createdAt = createdAt;
          this.locName = locName;
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

    public String getType() {
        return type;
    }
    public boolean getIsRead() {  
           return isRead;
       }
    public boolean isRead() {
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
}
