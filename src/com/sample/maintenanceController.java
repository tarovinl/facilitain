package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sample.model.Maintenance;
import sample.model.PooledConnection;

@WebServlet(name = "MaintenanceController", urlPatterns = { "/maintenanceSchedule" })
public class maintenanceController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Maintenance> maintenanceList = new ArrayList<>();

        try (Connection con = PooledConnection.getConnection()) {
            System.out.println("Connection established successfully!");

            PreparedStatement ps = con.prepareStatement(
                "SELECT ITEM_MS_ID, ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED");
            ResultSet rs = ps.executeQuery();
            System.out.println("Query executed successfully!");

            // Print column headers
            System.out.println("ITEM_MS_ID | ITEM_TYPE_ID | NO_OF_DAYS | REMARKS | NO_OF_DAYS_WARNING");

            while (rs.next()) {
                Maintenance maintenance = new Maintenance();
                maintenance.setItemMsId(rs.getInt("ITEM_MS_ID"));
                maintenance.setItemTypeId(rs.getInt("ITEM_TYPE_ID"));
                maintenance.setNoOfDays(rs.getInt("NO_OF_DAYS"));
                maintenance.setRemarks(rs.getString("REMARKS"));
                maintenance.setNoOfDaysWarning(rs.getInt("NO_OF_DAYS_WARNING"));
                maintenanceList.add(maintenance);

                // Print each row of data retrieved
                System.out.printf("%d | %d | %d | %s | %d%n", 
                    maintenance.getItemMsId(),
                    maintenance.getItemTypeId(),
                    maintenance.getNoOfDays(),
                    maintenance.getRemarks(),
                    maintenance.getNoOfDaysWarning());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Maintenance list size: " + maintenanceList.size());

        // Set the maintenance list as an attribute to pass to the JSP
        request.setAttribute("maintenanceList", maintenanceList);

        // Forward the request to the JSP
        request.getRequestDispatcher("/maintenanceSchedule.jsp").forward(request, response);
        System.out.println("Forwarding to JSP page: maintenanceSchedule.jsp");
    }
}
