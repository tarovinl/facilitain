package sample.model;

import java.util.Date;

public class Report {

    private int reportId; 
    private String repEquipment; 
    private String locName;  
    private String repfloor;    
    private String reproom;      
    private String repissue;     
    private byte[] reportImage; // Store image as bytes
    private Date recInstDt; 
    private String instBy;
    private int status;
    private String reportCode;
    private int archivedFlag;
    
    // Flag to check if image exists
    private boolean hasImage;

    public Report() {}

    public Report(int reportId, String equipment, String building, String floor, 
                      String room, String issue, byte[] reportImage, Date recInstDt, String instBy, int status, String reportCode) {
        this.reportId = reportId;
        this.repEquipment = equipment;
        this.locName = building;
        this.repfloor = floor;
        this.reproom = room;
        this.repissue = issue;
        this.reportImage = reportImage;
        this.recInstDt = recInstDt;
        this.hasImage = reportImage != null;
        this.instBy = instBy;
        this.status = status;
        this.reportCode = reportCode;
        
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getRepEquipment() {
        return repEquipment;
    }

    public void setRepEquipment(String repEquipment) {
        this.repEquipment = repEquipment;
    }

    public String getLocName() {
        return locName;
    }

    public void setLocName(String locName) {
        this.locName = locName;
    }

    public String getRepfloor() {
        return repfloor;
    }

    public void setRepfloor(String repfloor) {
        this.repfloor = repfloor;
    }

    public String getReproom() {
        return reproom;
    }

    public void setReproom(String reproom) {
        this.reproom = reproom;
    }

    public String getRepissue() {
        return repissue;
    }

    public void setRepissue(String repissue) {
        this.repissue = repissue;
    }

    public byte[] getReportImage() {
        return reportImage;
    }

    public void setReportImage(byte[] reportImage) {
        this.reportImage = reportImage;
        this.hasImage = reportImage != null;
    }

    public Date getRecInstDt() {
        return recInstDt;
    }

    public void setRecInstDt(Date recInstDt) {
        this.recInstDt = recInstDt;
    }

    public boolean isHasImage() {
        return hasImage;
    }

    public void setHasImage(boolean hasImage) {
        this.hasImage = hasImage;
    }
    
    public void setInstBy(String instBy) {
        this.instBy = instBy;
    }
    
    public String getInstBy() {
        return instBy;
    }
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    
    public String getReportCode() {
        return reportCode;
    }

    public void setReportCode(String reportCode) {
        this.reportCode = reportCode;
    }
    public int getArchivedFlag() {
        return archivedFlag;
    }

    public void setArchivedFlag(int archivedFlag) {
        this.archivedFlag = archivedFlag;
    }
}