package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sample.model.Location;
import sample.model.Item;
import sample.model.PooledConnection;

@WebServlet(name = "mainController", urlPatterns = { "/homepage", "/buildingDashboard","/manage" })
public class mainController extends HttpServlet {

    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";


    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
        List<Location> locations = new ArrayList<>();
        ArrayList<Location> listFloor = new ArrayList<>();
        List<Item> listItem = new ArrayList<>();

     
        try (
             Connection con = PooledConnection.getConnection();
             PreparedStatement statement = con.prepareCall("SELECT ITEM_LOC_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_LOCATIONS ORDER BY NAME");
             PreparedStatement stmntFloor = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_LOC_FLOORS ORDER BY ITEM_LOC_ID, CASE WHEN REGEXP_LIKE(NAME, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(NAME, '^[0-9]+')) ELSE 9999 END, NAME");
             PreparedStatement stmntItems = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEMS WHERE LOCATION_ID = 23 ORDER BY FLOOR_NO")) {

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Location location = new Location();
                location.setItemLocId(rs.getInt("ITEM_LOC_ID"));
                location.setLocName(rs.getString("NAME"));
                location.setLocDescription(rs.getString("DESCRIPTION"));
                location.setActiveFlag(rs.getInt("ACTIVE_FLAG"));
                locations.add(location);
                
            }
            rs.close();

            ResultSet rsFlr = stmntFloor.executeQuery();
            while (rsFlr.next()) {
                Location itemFloor = new Location();
                itemFloor.setItemLocId(rsFlr.getInt("ITEM_LOC_ID"));
                itemFloor.setLocFloor(rsFlr.getString("NAME"));
                listFloor.add(itemFloor);
            }
            rsFlr.close();

            ResultSet rsItem = stmntItems.executeQuery();
            while (rsItem.next()) {
                Item items = new Item();
                items.setItemID(rsItem.getInt("ITEM_ID"));
                items.setItemLID(rsItem.getInt("LOCATION_ID"));
                items.setItemTID(rsItem.getInt("ITEM_TYPE_ID"));
                items.setItemName(rsItem.getString("NAME"));
                items.setItemRoom(rsItem.getString("ROOM_NO"));
                items.setItemFloor(rsItem.getString("FLOOR_NO"));
                items.setItemLocText(rsItem.getString("LOCATION_TEXT"));
                items.setDateInstalled(rsItem.getDate("DATE_INSTALLED"));
                listItem.add(items);

                // Print 
                System.out.println("__________________________");
                System.out.println("ID = " + items.getItemID());
                System.out.println("Name = " + items.getItemName());
                System.out.println("Item Loc ID = " + items.getItemLID());
                System.out.println("Item Type ID = " + items.getItemTID());
                System.out.println("Room = " + items.getItemRoom());
                System.out.println("Floor = " + items.getItemFloor());
                System.out.println("__________________________");
            }
            rsItem.close();

        } catch (SQLException error) {
            error.printStackTrace();
        }

        // Group floors in proper order
        Map<Integer, List<String>> groupedFloors = new HashMap<>();
        for (Location floor : listFloor) {
            int locID = floor.getItemLocId();
            String floorName = floor.getLocFloor();
            if (!groupedFloors.containsKey(locID)) {
                groupedFloors.put(locID, new ArrayList<>());
            }
            groupedFloors.get(locID).add(floorName);
        }
        
        // Store locations in the request scope to pass to JSP
        request.setAttribute("locations", locations);
        request.setAttribute("FMO_FLOORS_LIST", groupedFloors);
        request.setAttribute("FMO_ITEMS_LIST", listItem);

        String path = request.getServletPath();
        String queryString = request.getQueryString();

        switch (path) {
            case "/homepage":
                request.getRequestDispatcher("/homepage.jsp").forward(request, response);
                break;
            case "/buildingDashboard":
                if (queryString != null && queryString.contains("/manage")) {
                    request.getRequestDispatcher("/manageBuilding.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/buildingDashboard.jsp").forward(request, response);
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }

    }
}
