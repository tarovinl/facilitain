package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sample.model.Location;
import sample.model.PooledConnection;

@WebServlet(name = "mainController", urlPatterns = { "/maincontroller" })
public class mainController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("mainController doGet method called");

        response.setContentType(CONTENT_TYPE);
        
        List<Location> locations = new ArrayList<>();

        try (
            Connection con = PooledConnection.getConnection();
            PreparedStatement statement = con.prepareCall("SELECT ITEM_LOC_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_LOCATIONS");
        ) {
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Location location = new Location();
                location.setItemLocId(rs.getInt("ITEM_LOC_ID"));
                location.setLocName(rs.getString("NAME"));
                location.setLocDescription(rs.getString("DESCRIPTION"));
                location.setActiveFlag(rs.getInt("ACTIVE_FLAG"));
                
                locations.add(location);

                // Print 
                System.out.println("__________________________");
                System.out.println("ID = " + location.getItemLocId());
                System.out.println("Name = " + location.getLocName());
                System.out.println("Description = " + location.getLocDescription());
                System.out.println("Active Flag = " + location.getActiveFlag());
                System.out.println("__________________________");
            }

            rs.close();
        } catch (SQLException error) {
            error.printStackTrace(); // Print any SQL errors to the console
        }

        // Store locations in the request scope to pass to JSP
        request.setAttribute("locations", locations);

        // Forward the request to your JSP page to display the locations
        request.getRequestDispatcher("/headerClient.jsp").forward(request, response);
    }
}
