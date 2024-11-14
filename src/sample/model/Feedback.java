package sample.model;

import java.util.Date;

public class Feedback {
    private int feedbackId;
    private int itemLocId;

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getFeedbackId() {
        return feedbackId;
    }
    private String room;
    private int rating;
    private String suggestions;
    private Date recInsDt; 

    // Constructor
    public Feedback(int itemLocId, String room, int rating, String suggestions, Date recInsDt) {
        this.itemLocId = itemLocId;
        this.room = room;
        this.rating = rating;
        this.suggestions = suggestions;
        this.recInsDt = recInsDt;
    }

    // Getters and Setters
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
}
