package com.sample;

import java.io.IOException;


import java.sql.Blob;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.time.LocalDate;

import java.util.ArrayList;
import java.util.Date;
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

import sample.model.Repairs;
import sample.model.Quotation;

import sample.model.SharedData;

@WebServlet(name = "mainController", urlPatterns = { "/homepage", "/buildingDashboard","/manage", "/edit", "/notification",
                                                     "/calendar", "/history", "/settings", "/maintenanceSchedule" })
public class mainController extends HttpServlet {

    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";


    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
      
        // Get the current date
        LocalDate currentDate = LocalDate.now();
        int currentYear = currentDate.getYear();
        int currentMonth = currentDate.getMonthValue();

        
        List<Quotation> quotations = new ArrayList<>();
        List<Location> locations = new ArrayList<>();
        
        ArrayList<Location> listFloor = new ArrayList<>();
        ArrayList<Item> listItem = new ArrayList<>();
        ArrayList<Item> listTypes = new ArrayList<>();
        ArrayList<Item> listCats = new ArrayList<>();
        ArrayList<Item> listBrands = new ArrayList<>();

        ArrayList<Item> listMaintStat = new ArrayList<>();
        ArrayList<Item> listMaintSched = new ArrayList<>();
        
        ArrayList<Repairs> listRepairs = new ArrayList<>();
        
        List<String> months = new ArrayList<>();
            months.add("January");
            months.add("February");
            months.add("March");
            months.add("April");
            months.add("May");
            months.add("June");
            months.add("July");
            months.add("August");
            months.add("September");
            months.add("October");
            months.add("November");
            months.add("December");

        
        try (
             Connection con = PooledConnection.getConnection();
             PreparedStatement statement = con.prepareCall("SELECT * FROM FMO_ITEM_LOCATIONS ORDER BY NAME");
             PreparedStatement stmntFloor = con.prepareCall("SELECT * \n" + 
             "FROM FMO_ITEM_LOC_FLOORS \n" + 
             "ORDER BY \n" + 
             "    ITEM_LOC_ID, \n" + 
             "    CASE \n" + 
             "        WHEN NAME REGEXP '^[0-9]+F' THEN CAST(SUBSTRING_INDEX(NAME, 'F', 1) AS UNSIGNED) \n" + 
             "        ELSE 9999 \n" + 
             "    END, \n" + 
             "    NAME;\n");
             PreparedStatement stmntItems = con.prepareCall("SELECT * \n" + 
             "FROM FMO_ITEMS \n" + 
             "ORDER BY \n" + 
             "    LOCATION_ID, \n" + 
             "    CASE \n" + 
             "        WHEN FLOOR_NO REGEXP '^[0-9]+F' THEN CAST(SUBSTRING_INDEX(FLOOR_NO, 'F', 1) AS UNSIGNED) \n" + 
             "        ELSE 9999 \n" + 
             "    END, \n" + 
             "    ROOM_NO, \n" + 
             "    ITEM_ID;\n");
             PreparedStatement stmntITypes = con.prepareCall("SELECT * FROM FMO_ITEM_TYPES ORDER BY NAME");
             PreparedStatement stmntICats = con.prepareCall("SELECT * FROM FMO_ITEM_CATEGORIES ORDER BY NAME");
             PreparedStatement stmntIBrands = con.prepareCall("SELECT DISTINCT UPPER(BRAND_NAME) AS BRAND_NAME FROM FMO_ITEMS WHERE (TRIM(UPPER(BRAND_NAME)) NOT IN ('MITSUBISHI', 'MITSUBISHI ELECTRIC (IEEI)1', 'MITSUBISHI HEAVY', 'SAFW-WAY', 'SAFE-WSY', 'SAFE-WAY', 'SAFE WAY', 'SAFE-WAAY', 'HITAHI', 'TEST BRAND') OR BRAND_NAME IS NULL) ORDER BY BRAND_NAME")){
             PreparedStatement stmntMaintStat = con.prepareCall("SELECT * FROM FMO_ITEM_MAINTENANCE_STATUS ORDER BY STATUS_ID");
             PreparedStatement stmntMaintSched = con.prepareCall("SELECT * FROM FMO_ITEM_MAINTENANCE_SCHED WHERE ACTIVE_FLAG = 1 ORDER BY ITEM_MS_ID");
             PreparedStatement stmntRepairs = con.prepareCall("SELECT * FROM FMO_ITEM_REPAIRS ORDER BY REPAIR_YEAR, REPAIR_MONTH, ITEM_LOC_ID");
             PreparedStatement stmntQuotations = con.prepareCall("SELECT * FROM FMO_ITEM_QUOTATIONS ORDER BY QUOTATION_ID");

            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Location location = new Location();
                location.setItemLocId(rs.getInt("ITEM_LOC_ID"));
                location.setLocName(rs.getString("NAME"));
                location.setLocDescription(rs.getString("DESCRIPTION"));
                location.setActiveFlag(rs.getInt("ACTIVE_FLAG"));
                location.setLocArchive(rs.getInt("ARCHIVED_FLAG"));

                // Check if the image exists for this location
                Blob imageBlob = rs.getBlob("IMAGE");
                if (imageBlob != null && imageBlob.length() > 0) {
                    location.setHasImage(true);
                    byte[] imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                    location.setLocationImage(imageBytes); // Set the image bytes
                } else {
                    location.setHasImage(false);
                }

                locations.add(location);
            }

            rs.close();

            ResultSet rsFlr = stmntFloor.executeQuery();
            while (rsFlr.next()) {
                Location itemFloor = new Location();
                itemFloor.setItemLocId(rsFlr.getInt("ITEM_LOC_ID"));
                itemFloor.setItemLocFlrId(rsFlr.getInt("ITEM_LOC_FLR_ID"));
                itemFloor.setLocFloor(rsFlr.getString("NAME"));
                itemFloor.setLocDescription(rsFlr.getString("DESCRIPTION"));
                itemFloor.setLocArchive(rsFlr.getInt("ARCHIVED_FLAG"));
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
                items.setExpiration(rsItem.getDate("EXPIRY_DATE"));
                items.setItemArchive(rsItem.getInt("ITEM_STAT_ID"));
                items.setItemMaintStat(rsItem.getInt("MAINTENANCE_STATUS"));
                
                items.setItemPCC(rsItem.getInt("PC_CODE"));
                items.setAcACCU(rsItem.getInt("AC_ACCU"));
                items.setAcFCU(rsItem.getInt("AC_FCU"));
                items.setAcINVERTER(rsItem.getInt("AC_INVERTER"));
                items.setItemCapacity(rsItem.getInt("CAPACITY"));
                items.setItemUnitMeasure(rsItem.getString("UNIT_OF_MEASURE"));
                items.setItemEV(rsItem.getInt("ELECTRICAL_V"));
                items.setItemEPH(rsItem.getInt("ELECTRICAL_PH"));
                items.setItemEHZ(rsItem.getInt("ELECTRICAL_HZ"));
                
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
            
            ResultSet rsMaintStat = stmntMaintStat.executeQuery();
            while (rsMaintStat.next()) {
                Item mstat = new Item();
                mstat.setItemMaintStat(rsMaintStat.getInt("STATUS_ID"));
                mstat.setMaintStatName(rsMaintStat.getString("STATUS_NAME"));
                listMaintStat.add(mstat);
            }
            rsMaintStat.close();
            
            ResultSet rsMaintSched = stmntMaintSched.executeQuery();
            while (rsMaintSched.next()) {
                Item msched = new Item();
                msched.setItemID(rsMaintSched.getInt("ITEM_MS_ID"));
                msched.setItemTID(rsMaintSched.getInt("ITEM_TYPE_ID"));
                msched.setMaintSchedDays(rsMaintSched.getInt("NO_OF_DAYS"));
                msched.setItemRemarks(rsMaintSched.getString("REMARKS"));
                msched.setMaintSchedWarn(rsMaintSched.getInt("NO_OF_DAYS_WARNING"));
                listMaintSched.add(msched);
            }
            rsMaintSched.close();
            
            ResultSet rsQuot = stmntQuotations.executeQuery();
            while (rsQuot.next()) {
                Quotation quotation = new Quotation();
                quotation.setQuotationId(rsQuot.getInt("QUOTATION_ID"));
                quotation.setDescription(rsQuot.getString("DESCRIPTION"));
                quotation.setDateUploaded(rsQuot.getDate("DATE_UPLOADED"));
                quotation.setItemId(rsQuot.getInt("ITEM_ID"));
                Blob blob = rsQuot.getBlob("QUOTATION_IMAGE");
                byte[] imageBytes = null;

                if (blob != null) {
                    // Convert Blob to byte[]
                    imageBytes = blob.getBytes(1, (int) blob.length());
                }
                // Use the setter to store the image as byte[]
                quotation.setQuotationImage(imageBytes);
                quotations.add(quotation);
            }
            rsQuot.close();

            ResultSet rsRepairs = stmntRepairs.executeQuery();
            while (rsRepairs.next()) {
                Repairs reps = new Repairs();
                reps.setRepairID(rsRepairs.getInt("REPAIR_ID"));
                reps.setRepairLocID(rsRepairs.getInt("ITEM_LOC_ID"));
                reps.setRepairMonth(rsRepairs.getInt("REPAIR_MONTH"));
                reps.setRepairYear(rsRepairs.getInt("REPAIR_YEAR"));
                reps.setRepairCount(rsRepairs.getInt("NUM_OF_REPAIRS"));
                listRepairs.add(reps);
            }
            rsRepairs.close();

            
        } catch (SQLException error) {
            error.printStackTrace();
        }
        
        

//        // Group floors in proper order
        Map<Integer, List<String>> groupedFloors = new HashMap<>();
        for (Location floor : listFloor) {
            int locID = floor.getItemLocId();
            String floorName = floor.getLocFloor();
            int archID = floor.getLocArchive();
            // Only add floorName if archID is 1
            if (archID == 1) {
                groupedFloors.computeIfAbsent(locID, k -> new ArrayList<>()).add(floorName);
            }
        }
        

//        Map<Integer, List<String>> groupedFloors = new HashMap<>();
//        for (Location floor : listFloor) {
//            int locID = floor.getItemLocId();
//            String floorName = floor.getLocFloor();
//            if (!groupedFloors.containsKey(locID)) {
//                groupedFloors.put(locID, new ArrayList<>());
//            }
//            groupedFloors.get(locID).add(floorName);
//        }

        
        Set<String> uniqueRooms = new HashSet<>();
                List<Item> resultRoomList = new ArrayList<>();

                for (Item item : listItem) {
                    String uniqueKey = item.getItemLID() + ":" + item.getItemRoom() + ":" + item.getItemFloor();
                    if (!uniqueRooms.contains(uniqueKey)) {
                        uniqueRooms.add(uniqueKey);
                        resultRoomList.add(item);
                    }
                }
        
        Set<String> uniqueRooms2 = new HashSet<>();
                List<Item> resultRoomList2 = new ArrayList<>();

                for (Item itemzz : listItem) {
                    String uniqueKey2 = itemzz.getItemLID() + ":" + itemzz.getItemRoom();
                    if (!uniqueRooms2.contains(uniqueKey2)) {
                        uniqueRooms2.add(uniqueKey2);
                        resultRoomList2.add(itemzz);
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
        request.setAttribute("FMO_FLOORS_LIST2", listFloor);
        request.setAttribute("FMO_ITEMS_LIST", listItem);
        request.setAttribute("uniqueRooms", resultRoomList);
        request.setAttribute("uniqueRooms2", resultRoomList2);
        request.setAttribute("FMO_TYPES_LIST", listTypes);
        request.setAttribute("FMO_CATEGORIES_LIST", listCats);
        request.setAttribute("FMO_BRANDS_LIST", listBrands);
        request.setAttribute("maintenanceList", listMaintSched);
        request.setAttribute("FMO_MAINTSTAT_LIST", listMaintStat);

        request.setAttribute("currentYear", currentYear);
        request.setAttribute("currentMonth", currentMonth);
        
        request.setAttribute("monthsList", months);
        request.setAttribute("REPAIRS_PER_MONTH", listRepairs);
        
        request.setAttribute("quotations", quotations);
        getServletContext().setAttribute("quotations", quotations);

//        SharedData.getInstance().setItemsList(listItem);
//        SharedData.getInstance().setMaintStat(listMaintStat);
//        SharedData.getInstance().setMaintSched(listMaintSched);
        
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
                } else if (queryString != null && queryString.contains("/edit")) {
                    request.getRequestDispatcher("/editLocation.jsp").forward(request, response);
                }
                  else  {
                    request.getRequestDispatcher("/buildingDashboard.jsp").forward(request, response);
                }
                break;
            case "/notification":
                request.getRequestDispatcher("/notification.jsp").forward(request, response);
                break;
            case "/calendar":
                request.getRequestDispatcher("/calendar.jsp").forward(request, response);
                break;
            case "/history":
                request.getRequestDispatcher("/history.jsp").forward(request, response);
                break;
            case "/feedback":
                request.getRequestDispatcher("/feedback.jsp").forward(request, response);
                break;
            case "/reports":
                request.getRequestDispatcher("/reports.jsp").forward(request, response);
                break;
            case "/settings":
                request.getRequestDispatcher("/settings.jsp").forward(request, response);
                break;
            case "/maintenanceSchedule":
                request.getRequestDispatcher("/maintenanceSchedule.jsp").forward(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
        
    }}

    
