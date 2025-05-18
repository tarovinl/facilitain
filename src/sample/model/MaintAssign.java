package sample.model;

import java.util.Date;

public class MaintAssign {
    private int assignID;          
    private int itemID;        
    private int userID;       
    private int maintTID;
    private Date dateOfMaint;
    private int isCompleted;

    public void setIsCompleted(int isCompleted) {
        this.isCompleted = isCompleted;
    }

    public int getIsCompleted() {
        return isCompleted;
    }

    public void setAssignID(int assignID) {
        this.assignID = assignID;
    }

    public int getAssignID() {
        return assignID;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getUserID() {
        return userID;
    }

    public void setMaintTID(int maintTID) {
        this.maintTID = maintTID;
    }

    public int getMaintTID() {
        return maintTID;
    }

    public void setDateOfMaint(Date dateOfMaint) {
        this.dateOfMaint = dateOfMaint;
    }

    public Date getDateOfMaint() {
        return dateOfMaint;
    }
}
