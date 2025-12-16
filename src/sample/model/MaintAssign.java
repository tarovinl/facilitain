package sample.model;

import java.util.Date;

public class MaintAssign {
    private int assignID;          
    private int itemID;        
    private int userID;       
    private int maintTID;
    private Date dateOfMaint;
    private int isCompleted;
    private String userName;
    private Date dateOfPlanned;
    private int turnaroundDays;
    private String maintName;

    public void setMaintName(String maintName) {
        this.maintName = maintName;
    }

    public String getMaintName() {
        return maintName;
    }

    public void setTurnaroundDays(int turnaroundDays) {
        this.turnaroundDays = turnaroundDays;
    }

    public int getTurnaroundDays() {
        return turnaroundDays;
    }

    public void setDateOfPlanned(Date dateOfPlanned) {
        this.dateOfPlanned = dateOfPlanned;
    }

    public Date getDateOfPlanned() {
        return dateOfPlanned;
    }

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

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }
}
