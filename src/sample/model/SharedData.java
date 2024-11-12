package sample.model;

import java.util.ArrayList;

public class SharedData {
    private static SharedData instance;
    private ArrayList<Item> itemsList;
    private ArrayList<Item> maintStat;
    private ArrayList<Item> maintSched;


    private SharedData() {
        itemsList = new ArrayList<>();
        maintStat = new ArrayList<>();
        maintSched = new ArrayList<>();
    }

    public static synchronized SharedData getInstance() {
        if (instance == null) {
            instance = new SharedData();
        }
        return instance;
    }

    public ArrayList<Item> getItemsList() {
        return itemsList;
    }

    public void setItemsList(ArrayList<Item> itemsList) {
        this.itemsList = itemsList;
    }

    public void setMaintStat(ArrayList<Item> maintStat) {
        this.maintStat = maintStat;
    }

    public ArrayList<Item> getMaintStat() {
        return maintStat;
    }

    public void setMaintSched(ArrayList<Item> maintSched) {
        this.maintSched = maintSched;
    }

    public ArrayList<Item> getMaintSched() {
        return maintSched;
    }
}
