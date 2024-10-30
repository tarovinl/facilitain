package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import java.util.HashSet;
import java.util.List;
import java.util.Map;

import java.util.Set;

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
        ArrayList<Item> listItem = new ArrayList<>();
        ArrayList<Item> listTypes = new ArrayList<>();
        ArrayList<Item> listCats = new ArrayList<>();
        ArrayList<Item> listBrands = new ArrayList<>();

     
        try (
             Connection con = PooledConnection.getConnection();
             PreparedStatement statement = con.prepareCall("SELECT ITEM_LOC_ID, NAME, DESCRIPTION, ACTIVE_FLAG FROM C##FMO_ADM.FMO_ITEM_LOCATIONS ORDER BY NAME");
             PreparedStatement stmntFloor = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_LOC_FLOORS ORDER BY ITEM_LOC_ID, CASE WHEN REGEXP_LIKE(NAME, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(NAME, '^[0-9]+')) ELSE 9999 END, NAME");
             PreparedStatement stmntItems = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEMS ORDER BY LOCATION_ID, CASE WHEN REGEXP_LIKE(FLOOR_NO, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(FLOOR_NO, '^[0-9]+')) ELSE 9999 END, ROOM_NO, ITEM_ID");
             PreparedStatement stmntITypes = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_TYPES ORDER BY NAME");
             PreparedStatement stmntICats = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_CATEGORIES ORDER BY NAME");
             PreparedStatement stmntIBrands = con.prepareCall("SELECT DISTINCT UPPER(BRAND_NAME) AS BRAND_NAME FROM C##FMO_ADM.FMO_ITEMS WHERE (TRIM(UPPER(BRAND_NAME)) NOT IN ('MITSUBISHI', 'MITSUBISHI ELECTRIC (IEEI)1', 'MITSUBISHI HEAVY', 'SAFW-WAY', 'SAFE-WSY', 'SAFE-WAY', 'SAFE WAY', 'SAFE-WAAY', 'HITAHI', 'TEST BRAND') OR BRAND_NAME IS NULL) ORDER BY BRAND_NAME")){

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
                items.setItemBrand(rsItem.getString("BRAND_NAME"));
                items.setItemLocText(rsItem.getString("LOCATION_TEXT"));
                items.setItemRemarks(rsItem.getString("REMARKS"));
                items.setDateInstalled(rsItem.getDate("DATE_INSTALLED"));
                listItem.add(items);

                // Print 
//                System.out.println("__________________________");
//                System.out.println("ID = " + items.getItemID());
//                System.out.println("Name = " + items.getItemName());
//                System.out.println("Item Loc ID = " + items.getItemLID());
//                System.out.println("Item Type ID = " + items.getItemTID());
//                System.out.println("Room = " + items.getItemRoom());
//                System.out.println("Floor = " + items.getItemFloor());
//                System.out.println("__________________________");
            }
            rsItem.close();
            
            ResultSet rsType = stmntITypes.executeQuery();
            while (rsType.next()) {
                Item types = new Item();
                types.setItemTID(rsType.getInt("ITEM_TYPE_ID"));
                types.setItemCID(rsType.getInt("ITEM_CAT_ID"));
                types.setItemType(rsType.getString("NAME"));
                listTypes.add(types);

            }
            rsType.close();
            
            ResultSet rsCat = stmntICats.executeQuery();
            while (rsCat.next()) {
                Item cat = new Item();
                cat.setItemCID(rsCat.getInt("ITEM_CAT_ID"));
                cat.setItemCat(rsCat.getString("NAME"));
                listCats.add(cat);
            }
            rsCat.close();
            
            ResultSet rsBrand = stmntIBrands.executeQuery();
            while (rsBrand.next()) {
                Item brand = new Item();
                brand.setItemBrand(rsBrand.getString("BRAND_NAME"));
                listBrands.add(brand);
            }
            rsBrand.close();

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
        
        Set<String> uniqueRooms = new HashSet<>();
                List<Item> resultRoomList = new ArrayList<>();

                for (Item item : listItem) {
                    String uniqueKey = item.getItemLID() + ":" + item.getItemRoom() + ":" + item.getItemFloor();
                    if (!uniqueRooms.contains(uniqueKey)) {
                        uniqueRooms.add(uniqueKey);
                        resultRoomList.add(item);
                    }
                }

//                // Print the unique items
//                for (Item item : resultList) {
//                    System.out.println("_______________________________________________________");
//                    System.out.println("Item LID: " + item.getItemLID() + ", Room: " + item.getItemRoom()+ ", Floor: " + item.getItemFloor()) ;
//                }
        
//        for (Item item : listBrands) {
//                    System.out.println("_______________________________________________________");
//                    System.out.println(item.getItemBrand()) ;
//                    
//                }
        
        // Store locations in the request scope to pass to JSP
        request.setAttribute("locations", locations);
        request.setAttribute("FMO_FLOORS_LIST", groupedFloors);
        request.setAttribute("FMO_ITEMS_LIST", listItem);
        request.setAttribute("uniqueRooms", resultRoomList);
        request.setAttribute("FMO_TYPES_LIST", listTypes);
        request.setAttribute("FMO_CATEGORIES_LIST", listCats);
        request.setAttribute("FMO_BRANDS_LIST", listBrands);
        
        String path = request.getServletPath();
        String queryString = request.getQueryString();

        String locID = request.getParameter("locID");

//        server side redirect when invalid URL test:            
//        boolean locMatchFound = false;
//        boolean flrMatchFound = false;
//        for (Location location : locations) {
//            if (location.getItemLocId() == Integer.parseInt(locID.split("/")[0])) {
//                locMatchFound = true;
//                for (Item item : listItem) {
//                    if (item.getItemFloor() == locID.substring(locID.indexOf("floor=") + 6)) {
//                        flrMatchFound = true;
//                        break;
//                    }
//                }
//                if (flrMatchFound) {
//                            break;
//                }
//            }
//        }
//            
//
//        if (!locMatchFound || !flrMatchFound) {
//            response.sendRedirect(request.getContextPath() + "/homepage"); // Redirect to homepage
//            return; // Ensure no further processing happens
//        }
//        end of server side invalid URl test

        switch (path) {
            case "/homepage":
                request.getRequestDispatcher("/homepage.jsp").forward(request, response);
                break;
            case "/buildingDashboard":
                if (queryString != null && queryString.contains("/manage")) {
                    request.getRequestDispatcher("/manageBuilding.jsp").forward(request, response);
//                    System.out.println(locID);
//                    System.out.println(locID.substring(locID.indexOf("floor=") + 6));
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
