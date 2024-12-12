package sample.model;

public class ItemType {
    private int itemTypeId;
    private int itemCatId;
    private String name;
    private String description;
    private int archivedFlag;

    // Getters and Setters
    public int getItemTypeId() { return itemTypeId; }
    public void setItemTypeId(int itemTypeId) { this.itemTypeId = itemTypeId; }

    public int getItemCatId() { return itemCatId; }
    public void setItemCatId(int itemCatId) { this.itemCatId = itemCatId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getArchivedFlag() { return archivedFlag; }
    public void setArchivedFlag(int archivedFlag) { this.archivedFlag = archivedFlag; }
}
