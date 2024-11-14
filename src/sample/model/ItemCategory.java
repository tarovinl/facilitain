package sample.model;

public class ItemCategory {

    private int itemCID;          
    private String categoryName;  
    private String description;    
    private int activeFlag;       
    private int archivedFlag;    

    // Getters and Setters
    public void setItemCID(int itemCID) {
        this.itemCID = itemCID;
    }

    public int getItemCID() {
        return itemCID;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public void setActiveFlag(int activeFlag) {
        this.activeFlag = activeFlag;
    }

    public int getActiveFlag() {
        return activeFlag;
    }

    public void setArchivedFlag(int archivedFlag) {
        this.archivedFlag = archivedFlag;
    }

    public int getArchivedFlag() {
        return archivedFlag;
    }
}
