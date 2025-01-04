package sample.model;

import java.util.Date;

public class Feedback {
    private int feedbackId;
    private int itemLocId;
    private String location;
    private String room;
    private int rating;
    private String suggestions;
    private Date recInsDt;
    private String recInsBy;
    private Date recUpdDt;
    private String recUpdBy;
    private int itemCatId;
    private String specify;
    private String itemCatName;

    // Constructor for ClientController
    public Feedback(int itemLocId, String room, int rating, String suggestions, Date recInsDt, String specify, int itemCatId) {
        this.itemLocId = itemLocId;
        this.room = room;
        this.rating = rating;
        this.suggestions = suggestions;
        this.recInsDt = recInsDt;
        this.specify = specify;
        this.itemCatId = itemCatId;
    }


            //for displaying
   
            public Feedback(int feedbackId, String location, String room, int rating, String suggestions, 
                            Date recInsDt, String itemCatName) {
                this.feedbackId = feedbackId;
                this.location = location;  
                this.room = room;
                this.rating = rating;
                this.suggestions = suggestions;
                this.recInsDt = recInsDt;
                this.itemCatName = itemCatName; 
            }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getLocation() {
        return location;
    }

    // Getters and Setters for all fields
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getItemLocId() {
        return itemLocId;
    }

    public void setItemLocId(int itemLocId) {
        this.itemLocId = itemLocId;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(String suggestions) {
        this.suggestions = suggestions;
    }

    public Date getRecInsDt() {
        return recInsDt;
    }

    public void setRecInsDt(Date recInsDt) {
        this.recInsDt = recInsDt;
    }

    public String getRecInsBy() {
        return recInsBy;
    }

    public void setRecInsBy(String recInsBy) {
        this.recInsBy = recInsBy;
    }

    public Date getRecUpdDt() {
        return recUpdDt;
    }

    public void setRecUpdDt(Date recUpdDt) {
        this.recUpdDt = recUpdDt;
    }

    public String getRecUpdBy() {
        return recUpdBy;
    }

    public void setRecUpdBy(String recUpdBy) {
        this.recUpdBy = recUpdBy;
    }

    public int getItemCatId() {
        return itemCatId;
    }

    public void setItemCatId(int itemCatId) {
        this.itemCatId = itemCatId;
    }

    public String getSpecify() {
        return specify;
    }

    public void setSpecify(String specify) {
        this.specify = specify;
    }
    public void setItemCatName(String itemCatName) {
        this.itemCatName = itemCatName;
    }

    public String getItemCatName() {
        return itemCatName;
    }

}
