package sample.model;

import java.sql.Timestamp;
import java.util.Date;

public class ToDo {
    private int listItemId;
    private int empNumber;
    private String listContent;
    private Timestamp startDate;
    private Timestamp endDate;
    private Date creationDate;
    private int isChecked;


    public void setListItemId(int listItemId) {
        this.listItemId = listItemId;
    }

    public int getListItemId() {
        return listItemId;
    }

    public void setEmpNumber(int empNumber) {
        this.empNumber = empNumber;
    }

    public int getEmpNumber() {
        return empNumber;
    }

    public void setListContent(String listContent) {
        this.listContent = listContent;
    }

    public String getListContent() {
        return listContent;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public void setIsChecked(int isChecked) {
        this.isChecked = isChecked;
    }

    public int getIsChecked() {
        return isChecked;
    }
}
