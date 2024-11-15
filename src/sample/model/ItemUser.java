package sample.model;

public class ItemUser {
    private int empNumber;
    private int userType;
    private String fullName;
    private String userTypeString;  

    // Getters and Setters

    public int getEmpNumber() {
        return empNumber;
    }

    public void setEmpNumber(int empNumber) {
        this.empNumber = empNumber;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // New getter and setter for userTypeString
    public String getUserTypeString() {
        return userTypeString;
    }

    public void setUserTypeString(String userTypeString) {
        this.userTypeString = userTypeString;
    }
}
