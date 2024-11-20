package sample.model;

public class Maintenance {
    private int itemMsId;
    private int itemTypeId;
    private int noOfDays;
    private String remarks;
    private int noOfDaysWarning;
    private int activeFlag;
    private String itemTypeName;
    private Integer quarterlySchedNo; // Can be NULL
    private Integer yearlySchedNo; // Can be NULL

    // Getters and Setters
    public int getItemMsId() {
        return itemMsId;
    }

    public void setItemMsId(int itemMsId) {
        this.itemMsId = itemMsId;
    }

    public int getItemTypeId() {
        return itemTypeId;
    }

    public void setItemTypeId(int itemTypeId) {
        this.itemTypeId = itemTypeId;
    }

    public int getNoOfDays() {
        return noOfDays;
    }

    public void setNoOfDays(int noOfDays) {
        this.noOfDays = noOfDays;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getItemTypeName() {
        return itemTypeName;
    }

    public void setItemTypeName(String itemTypeName) {
        this.itemTypeName = itemTypeName;
    }

    public int getNoOfDaysWarning() {
        return noOfDaysWarning;
    }

    public void setNoOfDaysWarning(int noOfDaysWarning) {
        this.noOfDaysWarning = noOfDaysWarning;
    }

    public int getActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(int activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Integer getQuarterlySchedNo() {
        return quarterlySchedNo;
    }

    public void setQuarterlySchedNo(Integer quarterlySchedNo) {
        this.quarterlySchedNo = quarterlySchedNo;
    }

    public Integer getYearlySchedNo() {
        return yearlySchedNo;
    }

    public void setYearlySchedNo(Integer yearlySchedNo) {
        this.yearlySchedNo = yearlySchedNo;
    }
}
