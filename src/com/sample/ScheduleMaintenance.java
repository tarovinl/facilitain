package com.sample;

import java.util.ArrayList;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import sample.model.Item;

public class ScheduleMaintenance {
    private ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        private ArrayList<Item> itemsList;
        private ArrayList<Item> maintStat;
        private ArrayList<Item> maintSched;

    public void startScheduler() {
        //scheduler.scheduleAtFixedRate(this::performMaintenance, 0, 10, TimeUnit.SECONDS);
    }

    public void stopScheduler() {
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
        }
    }

    private void performMaintenance() {
        System.out.println("automatic printing");
    }
}
