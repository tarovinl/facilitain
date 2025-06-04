package sample.model;

public class LocationStatus {
    private Location location;
    private int statusRating; // 1 = Critical, 2 = Moderate, 3 = Optimal

        // Getters and setters
    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }

    public int getStatusRating() { return statusRating; }
    public void setStatusRating(int statusRating) { this.statusRating = statusRating; }
}
