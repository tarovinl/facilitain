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
    private String itemRemarks;
    private String itemTypeDescription;
    private Date dateInstalled;  
    private int activeFlag; 
    private int itemArchive;
    private int itemMaintStat;
    
    private int itemPCC;
    private int acACCU;
    private int acFCU;
    private int acINVERTER;
    private int itemCapacity;
    private String itemUnitMeasure;
    private int itemEV;
    private int itemEPH;
    private int itemEHZ;
    
    private String maintStatName;
    private int maintSchedDays;
    private int maintSchedWarn;
    private Date expiration;
    private Date lastMaintDate;

    // Getters and Setters
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

    public void setItemLID(int itemLID) {
        this.itemLID = itemLID;
    }

    public int getItemLID() {
        return itemLID;
    }

    public void setItemCID(int itemCID) {
        this.itemCID = itemCID;
    }

    public int getItemCID() {
        return itemCID;
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

    public void setActiveFlag(int activeFlag) {
        this.activeFlag = activeFlag;
    }

    public int getActiveFlag() {
        return activeFlag;
    }


    public void setItemRemarks(String itemRemarks) {
        this.itemRemarks = itemRemarks;
    }

    public String getItemRemarks() {
        return itemRemarks;

    }
    
    public void setItemTypeDescription(String itemTypeDescription) {
        this.itemTypeDescription = itemTypeDescription;
    }

    public String getItemTypeDescription() {
        return itemTypeDescription;
    }

    public void setItemArchive(int itemArchive) {
        this.itemArchive = itemArchive;
    }

    public int getItemArchive() {
        return itemArchive;
    }

    public void setExpiration(Date expiration) {
        this.expiration = expiration;
    }

    public Date getExpiration() {
        return expiration;
    }

    public void setItemMaintStat(int itemMaintStat) {
        this.itemMaintStat = itemMaintStat;
    }

    public int getItemMaintStat() {
        return itemMaintStat;
    }

    public void setMaintStatName(String maintStatName) {
        this.maintStatName = maintStatName;
    }

    public String getMaintStatName() {
        return maintStatName;
    }

    public void setMaintSchedDays(int maintSchedDays) {
        this.maintSchedDays = maintSchedDays;
    }

    public int getMaintSchedDays() {
        return maintSchedDays;
    }

    public void setMaintSchedWarn(int maintSchedWarn) {
        this.maintSchedWarn = maintSchedWarn;
    }

    public int getMaintSchedWarn() {
        return maintSchedWarn;
    }

    public void setItemPCC(int itemPCC) {
        this.itemPCC = itemPCC;
    }

    public int getItemPCC() {
        return itemPCC;
    }

    public void setAcACCU(int acACCU) {
        this.acACCU = acACCU;
    }

    public int getAcACCU() {
        return acACCU;
    }

    public void setAcFCU(int acFCU) {
        this.acFCU = acFCU;
    }

    public int getAcFCU() {
        return acFCU;
    }

    public void setAcINVERTER(int acINVERTER) {
        this.acINVERTER = acINVERTER;
    }

    public int getAcINVERTER() {
        return acINVERTER;
    }

    public void setItemCapacity(int itemCapacity) {
        this.itemCapacity = itemCapacity;
    }

    public int getItemCapacity() {
        return itemCapacity;
    }

    public void setItemUnitMeasure(String itemUnitMeasure) {
        this.itemUnitMeasure = itemUnitMeasure;
    }

    public String getItemUnitMeasure() {
        return itemUnitMeasure;
    }

    public void setItemEV(int itemEV) {
        this.itemEV = itemEV;
    }

    public int getItemEV() {
        return itemEV;
    }

    public void setItemEPH(int itemEPH) {
        this.itemEPH = itemEPH;
    }

    public int getItemEPH() {
        return itemEPH;
    }

    public void setItemEHZ(int itemEHZ) {
        this.itemEHZ = itemEHZ;
    }

    public int getItemEHZ() {
        return itemEHZ;
    }

    public void setLastMaintDate(Date lastMaintDate) {
        this.lastMaintDate = lastMaintDate;
    }

    public Date getLastMaintDate() {
        return lastMaintDate;
    }
}
