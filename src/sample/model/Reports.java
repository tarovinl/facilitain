package sample.model;

import java.time.LocalDate;

public class Reports {
    
    private int reportId;
    private int itemLocId;
    private String equipmentType;
    private String building;
    private String floor;
    private String room;
    private String description;
    private LocalDate reportDate;
    private String imagePath;
    
    // Constructors
       public Reports() {}

       public Reports(int reportId, int itemLocId, String equipmentType, String building, String floor, String room, String description, LocalDate reportDate, String imagePath) {
           this.reportId = reportId;
           this.itemLocId = itemLocId;
           this.equipmentType = equipmentType;
           this.building = building;
           this.floor = floor;
           this.room = room;
           this.description = description;
           this.reportDate = reportDate;
           this.imagePath = imagePath;
       }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getReportId() {
        return reportId;
    }

    public void setItemLocId(int itemLocId) {
        this.itemLocId = itemLocId;
    }

    public int getItemLocId() {
        return itemLocId;
    }

    public void setEquipmentType(String equipmentType) {
        this.equipmentType = equipmentType;
    }

    public String getEquipmentType() {
        return equipmentType;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public String getBuilding() {
        return building;
    }

    public void setFloor(String floor) {
        this.floor = floor;
    }

    public String getFloor() {
        return floor;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public String getRoom() {
        return room;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public void setReportDate(LocalDate reportDate) {
        this.reportDate = reportDate;
    }

    public LocalDate getReportDate() {
        return reportDate;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getImagePath() {
        return imagePath;
    }
}
