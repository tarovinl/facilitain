    package sample.model;
    
    public class Location {
        private int itemLocId;
        private String locName;
        private String locDescription;
        private int activeFlag;
        private String locFloor;
        private String locRoom;
    
        // Getters and Setters
        public int getItemLocId() {
            return itemLocId;
        }
    
        public void setItemLocId(int itemLocId) {
            this.itemLocId = itemLocId;
        }
    
        public String getLocName() {
            return locName;
        }
    
        public void setLocName(String name) {
            this.locName = name;
        }
    
        public String getLocDescription() {
            return locDescription;
        }
    
        public void setLocDescription(String description) {
            this.locDescription = description;
        }
    
        public int getActiveFlag() {
            return activeFlag;
        }
    
        public void setActiveFlag(int activeFlag) {
            this.activeFlag = activeFlag;
        }
    
        public void setLocFloor(String locFloor) {
            this.locFloor = locFloor;
        }
    
        public String getLocFloor() {
            return locFloor;
        }
    
        public void setLocRoom(String locRoom) {
            this.locRoom = locRoom;
        }
    
        public String getLocRoom() {
            return locRoom;
        }
    }
