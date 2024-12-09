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
//        scheduler.schedule(this::performMaintenance, 0, TimeUnit.SECONDS);
    }


    public void stopScheduler() {
            // Disable the DBMS Scheduler job on application undeploy
//            try (
//            Connection con = PooledConnection.getConnection();
//            CallableStatement stmt = con.prepareCall("{CALL FMO_ADM.UPDATETESTSCHEDCALL}");) {
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
        System.out.println("Calling stored procedures...");
        try (Connection con = PooledConnection.getConnection()) {
            
            // Call first procedure: CALL_GEN_AUTO_ITEMS
            try (CallableStatement stmt = con.prepareCall("{CALL FMO_ADM.CALL_GEN_AUTO_ITEMS}")) {
                stmt.execute();
                System.out.println("CALL_GEN_AUTO_ITEMS executed successfully.");
            }

            // Call second procedure: CALL_RUN_AUTO_ITEMS
            try (CallableStatement stmt = con.prepareCall("{CALL FMO_ADM.CALL_RUN_AUTO_ITEMS}")) {
                stmt.execute();
                System.out.println("CALL_RUN_AUTO_ITEMS executed successfully.");
            }

            // Call third procedure: CALL_U_FE
            try (CallableStatement stmt = con.prepareCall("{CALL FMO_ADM.CALL_U_FE}")) {
                stmt.execute();
                System.out.println("CALL_U_FE executed successfully.");
            }

            System.out.println("All procedures executed successfully.");
            
        } catch (SQLException error) {
            error.printStackTrace();
        }
    }


}
