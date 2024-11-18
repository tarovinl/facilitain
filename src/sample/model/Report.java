package sample.model;

public class Report {

    private String repEquipment; 
    private String locName;  
    private String repfloor;    
    private String reproom;      
    private String repissue;     
    private String repfileName;
    
    public Report() {}
    
    public Report(String equipment, String building, String floor, String room, String issue, String fileName) {
            this.repEquipment = equipment;
            this.locName = building;
            this.repfloor = floor;
            this.reproom = room;
            this.repissue = issue;
            this.repfileName = fileName;
        }

    public void setRepEquipment(String repEquipment) {
        this.repEquipment = repEquipment;
    }

    public String getRepEquipment() {
        return repEquipment;
    }

    public void setLocName(String locName) {
        this.locName = locName;
    }

    public String getLocName() {
        return locName;
    }

    public void setRepfloor(String repfloor) {
        this.repfloor = repfloor;
    }

    public String getRepfloor() {
        return repfloor;
    }

    public void setReproom(String reproom) {
        this.reproom = reproom;
    }

    public String getReproom() {
        return reproom;
    }

    public void setRepissue(String repissue) {
        this.repissue = repissue;
    }

    public String getRepissue() {
        return repissue;
    }

    public void setRepfileName(String repfileName) {
        this.repfileName = repfileName;
    }

    public String getRepfileName() {
        return repfileName;
    }
}


