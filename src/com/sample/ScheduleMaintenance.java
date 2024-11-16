package com.sample;

import java.sql.CallableStatement;
import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import java.sql.Statement;

import java.util.ArrayList;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import sample.model.Item;
import sample.model.PooledConnection;

public class ScheduleMaintenance {
    private ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        private ArrayList<Item> itemsList;
        private ArrayList<Item> maintStat;
        private ArrayList<Item> maintSched;

    public void startScheduler() {

        // Schedule performMaintenance to run once, immediately on startup
        //scheduler.schedule(this::performMaintenance, 0, TimeUnit.SECONDS);
    }


    public void stopScheduler() {
            // Disable the DBMS Scheduler job on application undeploy
//            try (
//            Connection con = PooledConnection.getConnection();
//            CallableStatement stmt = con.prepareCall("{CALL C##FMO_ADM.UPDATETESTSCHEDCALL}");) {
//                
//                stmt.execute();
//                System.out.println("DBMS Scheduler job disabled successfully on application undeploy.");
//
//            } catch (SQLException e) {
//                System.err.println("Error disabling DBMS Scheduler job: " + e.getMessage());
//                e.printStackTrace();
//            }
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
        System.out.println("Calling stored procedure...");
//        try (
//            Connection con = PooledConnection.getConnection();
//            CallableStatement stmt = con.prepareCall("{CALL C##FMO_ADM.UPDATETESTSCHEDCALL}");) {
//            
//            stmt.execute();
//            System.out.println("DBMS Scheduler job enabled successfully.");
//        } catch (SQLException error) {
//            error.printStackTrace();
//        }
    }

}
