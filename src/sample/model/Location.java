    package sample.model;
    
    public class Location {
        private int itemLocId;
        private String locName;
        private String locDescription;
        private int activeFlag;
        private String locFloor;
        private String locRoom;
        private int itemLocFlrId;
        private int locArchive;
    
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

    public void setItemLocFlrId(int itemLocFlrId) {
        this.itemLocFlrId = itemLocFlrId;
    }

    public int getItemLocFlrId() {
        return itemLocFlrId;
    }

    public void setLocArchive(int locArchive) {
        this.locArchive = locArchive;
    }

    public int getLocArchive() {
        return locArchive;
    }
}
