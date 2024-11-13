package sample.model;

public class Maintenance {
    private int itemMsId;
    private int itemTypeId;
    private int noOfDays;
    private String remarks;
    private int noOfDaysWarning;
    private String itemTypeName;

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
}
