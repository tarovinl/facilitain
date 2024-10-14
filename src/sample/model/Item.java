package sample.model;

import java.util.Date;

public class Item {
    
    private int itemID;
    private int itemTID;
    private int itemLID;
    private int itemCID;
    private String itemName;
    private String itemRoom;
    private String itemFloor;
    private String itemLocText;
    private String itemBrand;
    private String itemType;
    private String itemCat;
    private Date dateInstalled;

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public int getItemID() {
        return itemID;
    }

    public void setItemTID(int itemTID) {
        this.itemTID = itemTID;
    }

    public int getItemTID() {
        return itemTID;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemRoom(String itemRoom) {
        this.itemRoom = itemRoom;
    }

    public String getItemRoom() {
        return itemRoom;
    }

    public void setItemFloor(String itemFloor) {
        this.itemFloor = itemFloor;
    }

    public String getItemFloor() {
        return itemFloor;
    }

    public void setItemLocText(String itemLocText) {
        this.itemLocText = itemLocText;
    }

    public String getItemLocText() {
        return itemLocText;
    }

    public void setDateInstalled(Date dateInstalled) {
        this.dateInstalled = dateInstalled;
    }

    public Date getDateInstalled() {
        return dateInstalled;
    }

    public void setItemLID(int itemLID) {
        this.itemLID = itemLID;
    }

    public int getItemLID() {
        return itemLID;
    }

    public void setItemBrand(String itemBrand) {
        this.itemBrand = itemBrand;
    }

    public String getItemBrand() {
        return itemBrand;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemCat(String itemCat) {
        this.itemCat = itemCat;
    }

    public String getItemCat() {
        return itemCat;
    }

    public void setItemCID(int itemCID) {
        this.itemCID = itemCID;
    }

    public int getItemCID() {
        return itemCID;
    }
}
