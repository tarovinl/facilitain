package com.sample;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;


@WebListener
public class MaintenanceListener implements ServletContextListener {
    private ScheduleMaintenance scheduleMaintenance;

    public void contextInitialized(ServletContextEvent event) {
        scheduleMaintenance = new ScheduleMaintenance();
        scheduleMaintenance.startScheduler();
        System.out.println("ScheduleMaintenance started upon deployment.");
    }

    public void contextDestroyed(ServletContextEvent event) {
        if (scheduleMaintenance != null) {
            scheduleMaintenance.stopScheduler();
            System.out.println("ScheduleMaintenance stopped upon undeployment.");
        }
    }
}
