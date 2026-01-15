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

import javax.servlet.http.HttpSession;

import sample.model.Location;
import sample.model.Item;
import sample.model.Maps;
import sample.model.PooledConnection;

import sample.model.Repairs;
import sample.model.Jobs;
import sample.model.Maintenance;
import sample.model.Quotation;
import sample.model.ToDo;
import sample.model.MaintAssign;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.TreeSet;

import sample.model.ItemUser;
import sample.model.LocationStatus;

@WebServlet(name = "mainController", urlPatterns = { "/homepage", "/buildingDashboard","/manage", "/allDashboard", "/edit",
                                                     "/allDashboard/manage", "/calendar", "/settings", "/maintenanceSchedule", "/mapView"})
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
        ArrayList<Maintenance> listMaintSched = new ArrayList<>();
        ArrayList<Maintenance> listMaintType = new ArrayList<>();
        
        ArrayList<Repairs> listRepairs = new ArrayList<>();
        ArrayList<Repairs> listAllReps = new ArrayList<>();
        ArrayList<Jobs> listJobs = new ArrayList<>();
        ArrayList<ToDo> listToDo = new ArrayList<>();
        ArrayList<Maps> listMap = new ArrayList<>();
        ArrayList<MaintAssign> listAssign = new ArrayList<>();
        ArrayList<ItemUser> listDUsers = new ArrayList<>();
        
        List<LocationStatus> locationStatuses = new ArrayList<>();
        
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
             PreparedStatement statement = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_LOCATIONS WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG = 1 ORDER BY UPPER(NAME)");
             PreparedStatement stmntFloor = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_LOC_FLOORS ORDER BY ITEM_LOC_ID, CASE WHEN REGEXP_LIKE(NAME, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(NAME, '^[0-9]+')) ELSE 9999 END, NAME");
             PreparedStatement stmntItems = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEMS ORDER BY LOCATION_ID, CASE WHEN REGEXP_LIKE(FLOOR_NO, '^[0-9]+F') THEN TO_NUMBER(REGEXP_SUBSTR(FLOOR_NO, '^[0-9]+')) ELSE 9999 END, ROOM_NO, ITEM_ID");
             PreparedStatement stmntITypes = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_TYPES ORDER BY NAME");
             PreparedStatement stmntICats = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_CATEGORIES ORDER BY NAME");
             PreparedStatement stmntIBrands = con.prepareCall("SELECT DISTINCT UPPER(BRAND_NAME) AS BRAND_NAME FROM C##FMO_ADM.FMO_ITEMS WHERE (TRIM(UPPER(BRAND_NAME)) NOT IN ('MITSUBISHI', 'MITSUBISHI ELECTRIC (IEEI)1', 'MITSUBISHI HEAVY', 'SAFW-WAY', 'SAFE-WSY', 'SAFE-WAY', 'SAFE WAY', 'SAFE-WAAY', 'HITAHI', 'TEST BRAND') OR BRAND_NAME IS NULL) ORDER BY BRAND_NAME");
             PreparedStatement stmntMaintStat = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_STATUS ORDER BY STATUS_ID");
             PreparedStatement stmntMaintSched = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED WHERE ACTIVE_FLAG = 1 AND ARCHIVED_FLAG = 1 ORDER BY ITEM_MS_ID");
             PreparedStatement stmntMaintType = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES");
             PreparedStatement stmntRepairs = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_REPAIRS ORDER BY REPAIR_YEAR, REPAIR_MONTH, ITEM_LOC_ID");
             PreparedStatement stmntAllReps = con.prepareCall("SELECT repair_month, SUM(num_of_repairs) AS total_repairs FROM C##FMO_ADM.fmo_item_repairs WHERE repair_year = EXTRACT(YEAR FROM SYSDATE) GROUP BY repair_month ORDER BY repair_month");
             PreparedStatement stmntAssign = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ORDER BY DATE_OF_MAINTENANCE");
             PreparedStatement stmntDUsers = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_DUSERS ORDER BY USER_ID");
             PreparedStatement stmntQuotations = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS ORDER BY QUOTATION_ID");
             PreparedStatement stmntToDo = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_TO_DO_LIST");
             PreparedStatement stmntMap = con.prepareCall("SELECT * FROM C##FMO_ADM.FMO_ITEM_LOC_MAP");
             PreparedStatement stmntJobs = con.prepareCall("SELECT a.JOB_NAME, a.JOB_ACTION, a.START_DATE, a.REPEAT_INTERVAL, b.CREATED FROM DBA_SCHEDULER_JOBS a JOIN ALL_OBJECTS b ON a.JOB_NAME = b.OBJECT_NAME WHERE a.JOB_NAME LIKE 'UPDATE_ITEM_JOB_CAT%'");
             ){

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
                items.setLastMaintDate(rsItem.getDate("LAST_MAINTENANCE_DATE"));
                items.setPlannedMaintDate(rsItem.getDate("PLANNED_MAINTENANCE_DATE"));
                
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
                types.setItemArchive(rsType.getInt("ARCHIVED_FLAG"));
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
                Maintenance msched = new Maintenance();
                msched.setItemMsId(rsMaintSched.getInt("ITEM_MS_ID"));
                msched.setItemTypeId(rsMaintSched.getInt("ITEM_TYPE_ID"));
                msched.setNoOfDays(rsMaintSched.getInt("NO_OF_DAYS"));
                msched.setRemarks(rsMaintSched.getString("REMARKS"));
                msched.setNoOfDaysWarning(rsMaintSched.getInt("NO_OF_DAYS_WARNING"));
                msched.setQuarterlySchedNo(rsMaintSched.getInt("QUARTERLY_SCHED_NO"));
                msched.setYearlySchedNo(rsMaintSched.getInt("YEARLY_SCHED_NO"));
                msched.setArchiveFlag(rsMaintSched.getInt("ARCHIVED_FLAG"));
                listMaintSched.add(msched);
            }
            rsMaintSched.close();
            
            ResultSet rsMaintType = stmntMaintType.executeQuery();
            while (rsMaintType.next()) {
                Maintenance mtype = new Maintenance();
                mtype.setItemTypeId(rsMaintType.getInt("MAIN_TYPE_ID"));
                mtype.setItemTypeName(rsMaintType.getString("NAME"));
                listMaintType.add(mtype);
            }
            rsMaintType.close();
            
            ResultSet rsAssign = stmntAssign.executeQuery();
            while (rsAssign.next()) {
                MaintAssign mass = new MaintAssign();
                mass.setAssignID(rsAssign.getInt("ASSIGN_ID"));
                mass.setItemID(rsAssign.getInt("ITEM_ID"));
                mass.setUserID(rsAssign.getInt("USER_ID"));
                mass.setMaintTID(rsAssign.getInt("MAIN_TYPE_ID"));
                mass.setDateOfMaint(rsAssign.getDate("DATE_OF_MAINTENANCE"));
                mass.setIsCompleted(rsAssign.getInt("IS_COMPLETED"));
                listAssign.add(mass);
            }
            rsAssign.close();
            
            ResultSet rsDUsers = stmntDUsers.executeQuery();
            while (rsDUsers.next()) {
                ItemUser itemUser = new ItemUser();
                itemUser.setUserId(rsDUsers.getInt("USER_ID"));
                itemUser.setName(rsDUsers.getString("NAME"));
                itemUser.setEmail(rsDUsers.getString("EMAIL"));
                itemUser.setRole(rsDUsers.getString("ROLE"));
                listDUsers.add(itemUser);
            }
            rsDUsers.close();
            
            ResultSet rsQuot = stmntQuotations.executeQuery();
            while (rsQuot.next()) {
                Quotation quotation = new Quotation();
                quotation.setQuotationId(rsQuot.getInt("QUOTATION_ID"));
                quotation.setDescription(rsQuot.getString("DESCRIPTION"));
                quotation.setDateUploaded(rsQuot.getDate("DATE_UPLOADED"));
                quotation.setItemId(rsQuot.getInt("ITEM_ID"));
                quotation.setArchiveFlag(rsQuot.getInt("ARCHIVED_FLAG"));
                
                // Handle File 1
                Blob blob1 = rsQuot.getBlob("QUOTATION_FILE1");
                if (blob1 != null) {
                    byte[] file1Bytes = blob1.getBytes(1, (int) blob1.length());
                    quotation.setQuotationFile1(file1Bytes);
                }
                quotation.setFile1Name(rsQuot.getString("FILE1_NAME"));
                quotation.setFile1Type(rsQuot.getString("FILE1_TYPE"));
                
                // Handle File 2
                Blob blob2 = rsQuot.getBlob("QUOTATION_FILE2");
                if (blob2 != null) {
                    byte[] file2Bytes = blob2.getBytes(1, (int) blob2.length());
                    quotation.setQuotationFile2(file2Bytes);
                }
                quotation.setFile2Name(rsQuot.getString("FILE2_NAME"));
                quotation.setFile2Type(rsQuot.getString("FILE2_TYPE"));
                
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
            
            ResultSet rsAllReps = stmntAllReps.executeQuery();
            while (rsAllReps.next()) {
                Repairs areps = new Repairs();
                areps.setRepairMonth(rsAllReps.getInt("REPAIR_MONTH"));
                areps.setRepairCount(rsAllReps.getInt("TOTAL_REPAIRS"));
                listAllReps.add(areps);
            }
            rsAllReps.close();
            
            ResultSet rsToDo = stmntToDo.executeQuery();
            while (rsToDo.next()) {
                ToDo todo = new ToDo();
                todo.setListItemId(rsToDo.getInt("LIST_ITEM_ID"));
                todo.setEmpNumber(rsToDo.getInt("EMP_NUMBER"));
                todo.setListContent(rsToDo.getString("LIST_CONTENT"));
                todo.setStartDate(rsToDo.getTimestamp("START_DATE"));
                todo.setEndDate(rsToDo.getTimestamp("END_DATE"));
                todo.setCreationDate(rsToDo.getDate("CREATION_DATE"));
                todo.setIsChecked(rsToDo.getInt("IS_CHECKED"));
                
                listToDo.add(todo);
            }
            rsToDo.close();
            
            ResultSet rsMap = stmntMap.executeQuery();
            while (rsMap.next()) {
                Maps imthemap = new Maps();
                imthemap.setCoordId(rsMap.getInt("COORD_ID"));
                imthemap.setItemLocId(rsMap.getInt("ITEM_LOC_ID"));
                imthemap.setLatitude(rsMap.getDouble("LATITUDE"));
                imthemap.setLongitude(rsMap.getDouble("LONGITUDE"));
                listMap.add(imthemap);
            }
            rsMap.close();
            
            ResultSet rsJobs = stmntJobs.executeQuery();
            while (rsJobs.next()) {
                Jobs jobs = new Jobs();
                jobs.setJobName(rsJobs.getString("JOB_NAME"));
                jobs.setJobAction(rsJobs.getString("JOB_ACTION"));
                jobs.setStartDate(rsJobs.getDate("START_DATE"));
                jobs.setRepeatInterval(rsJobs.getString("REPEAT_INTERVAL"));
                jobs.setJobCreated(rsJobs.getDate("CREATED"));
                listJobs.add(jobs);
            }
            rsJobs.close();
            
           
        } catch (SQLException error) {
            error.printStackTrace();
        }
        
        

//        AI was used to refine grouping of floors in proper order
        // Tool: ChatGPT, Prompt: "Create a map that stores all floors in every building, and attach their location id to those floors"
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
        
//        original floor mapping here (not working anymore):
//        Map<Integer, List<String>> groupedFloors = new HashMap<>();
//        for (Location floor : listFloor) {
//            int locID = floor.getItemLocId();
//            String floorName = floor.getLocFloor();
//            if (!groupedFloors.containsKey(locID)) {
//                groupedFloors.put(locID, new ArrayList<>());
//            }
//            groupedFloors.get(locID).add(floorName);
//        }

        // AI was used to refine grouping of floors in proper order
        // Tool: ChatGPT, Prompt: "Map items using their IDs and NAMEs to their Room_No"
        Map<Integer, String> itemIdToName = new HashMap<>();

        Set<String> uniqueRooms = new HashSet<>();
                List<Item> resultRoomList = new ArrayList<>();

                for (Item item : listItem) {
                    itemIdToName.put(item.getItemID(), item.getItemName());
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
        
        List<Item> filteredCategories = new ArrayList<>();
        // Iterate over each category
        for (Item cat : listCats) {
            // Check if any type in listTypes matches the category's itemCID
            boolean hasMatchingType = false;
            for (Item type : listTypes) {
                if (type.getItemCID() == cat.getItemCID() && type.getItemArchive() == 1) {
                    hasMatchingType = true;
                    break;
                }
            }
            // If a matching type is found, add the category to the filtered list
            if (hasMatchingType) {
                filteredCategories.add(cat);
            }
        }
        
        for (Location loc : locations) {
            int totalItems = 0;
            int nonOptimalItems = 0;

            for (Item item : listItem) {
                if (item.getItemLID() == loc.getItemLocId()) {
                    totalItems++;
                    if (item.getItemMaintStat() != 1) {
                        nonOptimalItems++;
                    }
                }
            }

            int status = 3; // Default to Optimal
            if (totalItems > 0) {
                double percentage = (double) nonOptimalItems / totalItems;

                if (percentage <= 0.33) {
                    status = 3; // Optimal
                } else if (percentage <= 0.66) {
                    status = 2; // Moderate
                } else {
                    status = 1; // Critical
                }
            }

            LocationStatus locStatus = new LocationStatus();
            locStatus.setLocation(loc);
            locStatus.setStatusRating(status);
            locationStatuses.add(locStatus);
        }

        // Store locations in the request scope to pass to JSP
        request.setAttribute("locations", locations);
        request.setAttribute("FMO_FLOORS_LIST", groupedFloors);
        request.setAttribute("FMO_FLOORS_LIST2", listFloor);
        request.setAttribute("FMO_ITEMS_LIST", listItem);
        request.setAttribute("uniqueRooms", resultRoomList);
        request.setAttribute("uniqueRooms2", resultRoomList2);
        request.setAttribute("FMO_TYPES_LIST", listTypes);
        request.setAttribute("FMO_CATEGORIES_LIST", filteredCategories);
        request.setAttribute("FMO_BRANDS_LIST", listBrands);
        request.setAttribute("maintenanceList", listMaintSched);
        request.setAttribute("FMO_MAINTSTAT_LIST", listMaintStat);
        request.setAttribute("FMO_MAINTTYPE_LIST", listMaintType);

        request.setAttribute("currentYear", currentYear);
        request.setAttribute("currentMonth", currentMonth);
        
        request.setAttribute("monthsList", months);
        request.setAttribute("REPAIRS_PER_MONTH", listRepairs);
        request.setAttribute("ALL_REPAIRS_PER_MONTH", listAllReps);
        request.setAttribute("FMO_MAP_LIST", listMap);
        request.setAttribute("calendarSched", listJobs);
        request.setAttribute("FMO_TO_DO_LIST", listToDo);
        request.setAttribute("FMO_MAINT_ASSIGN", listAssign);
        request.setAttribute("FMO_USERS", listDUsers);
        request.setAttribute("itemIdToName", itemIdToName);
        
        request.setAttribute("quotations", quotations); // per session
        
        request.setAttribute("FMO_LOCATION_STATUS_LIST", locationStatuses);


//        SharedData.getInstance().setItemsList(listItem);
//        SharedData.getInstance().setMaintStat(listMaintStat);
//        SharedData.getInstance().setMaintSched(listMaintSched);
        
        String path = request.getServletPath();
        String queryString = request.getQueryString();
        HttpSession session = request.getSession(false); // Use false to avoid creating a new session if none exists
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        String locID = request.getParameter("locID");
        
        System.out.println("_______________________________________________________");
        System.out.println("path: "+path); System.out.println("qstring: "+queryString);
        System.out.println("_______________________________________________________");
        
        if (!isValidPathAndQuery(path, queryString, request)) {
            request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
            return;
        }

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
                            String itemHIDParam = request.getParameter("itemHID");
                            // AI was used to create the logic for itemHID to pull for maintenance history of an equipment
                            // Tool: ChatGPT, Prompt: "Create a list that displays upon ajax request using this query [SQL query from preparedstatement below here]"
                            System.out.println("query string: "+queryString);
                            System.out.println("Equipment History Item ID Param: "+itemHIDParam);
                            if (itemHIDParam != null && !itemHIDParam.isEmpty()) {
                                int itemHID = Integer.parseInt(itemHIDParam);
                                List<MaintAssign> historyList = new ArrayList<>();
                                
                                try (Connection conn = PooledConnection.getConnection();
                                     PreparedStatement stmt = conn.prepareStatement(
                                         "SELECT ma.ASSIGN_ID, ma.MAIN_TYPE_ID, ma.USER_ID, ma.DATE_OF_MAINTENANCE, NVL(ma.DATE_OF_MAINTENANCE - ma.ORIGINAL_PLANNED_DATE, 0) AS TURNAROUND_DAYS, u.NAME AS NAME, mt.NAME AS MAINT_TYPE " +
                                         "FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                                         "JOIN C##FMO_ADM.FMO_ITEM_DUSERS u ON ma.USER_ID = u.USER_ID " +
                                         "JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES mt ON ma.MAIN_TYPE_ID = mt.MAIN_TYPE_ID " +
                                         "WHERE ma.ITEM_ID = ? AND ma.IS_COMPLETED = 1")) {
                                    
                                    stmt.setInt(1, itemHID);
                                    ResultSet rsH = stmt.executeQuery();
                                    
                                    while (rsH.next()) {
                                        MaintAssign massH = new MaintAssign();
                                        massH.setAssignID(rsH.getInt("ASSIGN_ID"));
                                        massH.setUserID(rsH.getInt("USER_ID"));
                                        massH.setUserName(rsH.getString("NAME"));
                                        massH.setMaintName(rsH.getString("MAINT_TYPE"));
                                        massH.setDateOfMaint(rsH.getDate("DATE_OF_MAINTENANCE"));
                                        massH.setTurnaroundDays(rsH.getInt("TURNAROUND_DAYS"));
                                        historyList.add(massH);
                                    }
                                    rsH.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                                System.out.println("Equipment History Item ID: "+itemHID);
                                response.setContentType("application/json");
                                response.setCharacterEncoding("UTF-8");
                                response.getWriter().write(new Gson().toJson(historyList));
                            } else {
                                System.out.println("itemHID is null or empty, handle logic here.");
                                request.getRequestDispatcher("/manageBuilding.jsp").forward(request, response);
                            }
        //                    System.out.println(locID);
        //                    System.out.println(locID.substring(locID.indexOf("floor=") + 6));
                        } else if (queryString != null && queryString.contains("/edit")) {
                            // Check if role is "Admin"
                            if ("Admin".equals(role)) {
                                request.getRequestDispatcher("/editLocation.jsp").forward(request, response);
                            } else {
                                // Redirect to an error page or homepage
                                response.sendRedirect(request.getContextPath() + "/homepage");
                            }
                        } else {
                            request.getRequestDispatcher("/buildingDashboard.jsp").forward(request, response);
                        }
                        break;
                    case "/allDashboard/manage":
                            String itemHIDParam2 = request.getParameter("itemHID");
                                System.out.println("query string: "+queryString);
                                System.out.println("Equipment History Item ID Param: "+itemHIDParam2);
                            if (itemHIDParam2 != null && !itemHIDParam2.isEmpty()) {
                                int itemHID2 = Integer.parseInt(itemHIDParam2);
                                List<MaintAssign> historyList2 = new ArrayList<>();
                                    
                                try (Connection conn2 = PooledConnection.getConnection();
                                     PreparedStatement stmt2 = conn2.prepareStatement(
                                         "SELECT ma.ASSIGN_ID, ma.MAIN_TYPE_ID, ma.USER_ID, ma.DATE_OF_MAINTENANCE, NVL(ma.DATE_OF_MAINTENANCE - ma.ORIGINAL_PLANNED_DATE, 0) AS TURNAROUND_DAYS, u.NAME AS NAME, mt.NAME AS MAINT_TYPE " +
                                         "FROM C##FMO_ADM.FMO_MAINTENANCE_ASSIGN ma " +
                                         "JOIN C##FMO_ADM.FMO_ITEM_DUSERS u ON ma.USER_ID = u.USER_ID " +
                                         "JOIN C##FMO_ADM.FMO_ITEM_MAINTENANCE_TYPES mt ON ma.MAIN_TYPE_ID = mt.MAIN_TYPE_ID " +
                                         "WHERE ma.ITEM_ID = ? AND ma.IS_COMPLETED = 1")) {
                                        
                                     stmt2.setInt(1, itemHID2);
                                     ResultSet rsH2 = stmt2.executeQuery();
                                    
                                    while (rsH2.next()) {
                                        MaintAssign massH = new MaintAssign();
                                        massH.setAssignID(rsH2.getInt("ASSIGN_ID"));
                                        massH.setUserID(rsH2.getInt("USER_ID"));
                                        massH.setUserName(rsH2.getString("NAME"));
                                        massH.setMaintName(rsH2.getString("MAINT_TYPE"));
                                        massH.setDateOfMaint(rsH2.getDate("DATE_OF_MAINTENANCE"));
                                        massH.setTurnaroundDays(rsH2.getInt("TURNAROUND_DAYS"));
                                        historyList2.add(massH);
                                    }
                                    rsH2.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                                System.out.println("Equipment History Item ID: "+itemHID2);
                                response.setContentType("application/json");
                                response.setCharacterEncoding("UTF-8");
                                response.getWriter().write(new Gson().toJson(historyList2));
                            } else {
                                System.out.println("itemHID is null or empty, handle logic here.");
                                request.getRequestDispatcher("/manageEquipment.jsp").forward(request, response);
                            }
                            //                    System.out.println(locID);
                            //                    System.out.println(locID.substring(locID.indexOf("floor=") + 6));
                        
                        break;
        //            case "/notification":
        //                request.getRequestDispatcher("/notification.jsp").forward(request, response);
        //                break;
                    case "/calendar":
                        String eventCat = request.getParameter("eventCat");
                        String eventItID = request.getParameter("eventItID");
                            //System.out.println("controller eventCat " + eventCat);
                                    if (eventCat != null) {
                                        // Process the dynamic locations logic
                                        Set<String> uniqueLocations = new TreeSet<>();

                                            for (Location location : locations) {
                                                for (Item item : listItem) {
                                                    if (location.getItemLocId() == item.getItemLID()) {
                                                        for (Item type : listTypes) { 
                                                            if (item.getItemTID() == type.getItemTID()) {
                                                                for (Item category : filteredCategories) { 
                                                                    if (category.getItemCat().equals(eventCat) && category.getItemCID() == type.getItemCID()) {
                                                                        for (Maintenance maintenance : listMaintSched) { 
                                                                            if (maintenance.getItemTypeId() == type.getItemTID()) {
                                                                                uniqueLocations.add(location.getLocName());

                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }

//                                        System.out.println("Unique locations size: " + uniqueLocations.size());
//                                        for (String loc : uniqueLocations) {
//                                            System.out.println("Location: " + loc);
//                                        }

                                        // Return the uniqueLocations as a JSON response
                                        response.setContentType("application/json");
                                        response.setCharacterEncoding("UTF-8");
                                        response.getWriter().write(new Gson().toJson(uniqueLocations));

                                        } else if (eventItID != null) {
                                            String locationNameEv = null;
                                            String itemNameEv = null;

                                            for (Item item : listItem) {
                                                if (String.valueOf(item.getItemID()).equals(eventItID)) {
                                                    itemNameEv = item.getItemName(); // Get item name
                                                    int itemLID = item.getItemLID(); // Get location ID

                                                    for (Location loc : locations) {
                                                        if (loc.getItemLocId() == itemLID) {
                                                            locationNameEv = loc.getLocName(); // Get location name
                                                            break;
                                                        }
                                                    }

                                                    break;
                                                }
                                            }

                                            // Package itemName and locationName into a JSON object
                                            JsonObject json = new JsonObject();
                                            json.addProperty("itemNameEv", itemNameEv);
                                            json.addProperty("locationNameEv", locationNameEv);

                                            response.setContentType("application/json");
                                            response.setCharacterEncoding("UTF-8");
                                            response.getWriter().write(json.toString());
                                        } else {
                                        // If it's not an AJAX request, forward to the calendar page
                                        request.getRequestDispatcher("/calendar.jsp").forward(request, response);
                                    }
                                    break;
        //            case "/history":
        //                request.getRequestDispatcher("/history.jsp").forward(request, response);
        //                break;
        //            case "/feedback":
        //                request.getRequestDispatcher("/feedback.jsp").forward(request, response);
        //                break;
        //            case "/reports":
        //                request.getRequestDispatcher("/reports.jsp").forward(request, response);
        //                break;
                    case "/settings":
                        request.getRequestDispatcher("/settings.jsp").forward(request, response);
                        break;
                    case "/allDashboard":
                        request.getRequestDispatcher("/allDashboard.jsp").forward(request, response);
                        break;
                    case "/maintenanceSchedule":
                        request.getRequestDispatcher("/maintenanceSchedule.jsp").forward(request, response);
                        break;
                    case "/mapView":
                        request.getRequestDispatcher("/mapView.jsp").forward(request, response);
                        break;
                    default:
                        request.getRequestDispatcher("/errorPage.jsp").forward(request, response);
                        break;
                }
        
        
    }
    private boolean isValidPathAndQuery(String path, String queryString, HttpServletRequest request) {
        if (path == null) return false;
        boolean isAjax = isAjaxRequest(request);

        // Remove global "harmless" parameters (action=..., status=...) regardless of values
        // Only strip harmless global params if NOT an AJAX request
        if (!isAjax && queryString != null) {
            queryString = queryString
                .replaceAll("(?i)&?action=[\\w\\-]+", "")
                .replaceAll("(?i)&?status=[\\w\\-]+", "")
                .replaceAll("^&+", "")
                .replaceAll("&{2,}", "&");

            if (queryString.isEmpty()) {
                queryString = null;
            }
        }

        switch (path) {
            case "/buildingDashboard":
                if (queryString == null) return true;

                // AI was used to generate regex patterns for URL security. Comments were made to describe what the regexes do
                // Tool: ChatGPT, Prompt: "Make a regex that [insert descriptions above the regex if conditions below]"
                // Accept AJAX-friendly malformed pattern: locID=/manage?floor=&itemHID=795
                if (queryString.matches("locID=/manage\\?floor=(&?itemHID=\\d+)?") ||
                    queryString.matches("locID=\\d+/manage\\?floor=\\w*&itemHID=\\d+")) {
                    return true;
                }
            
                // Explicitly allow "locID=all"
//                if ("locID=all".equalsIgnoreCase(queryString)) {
//                    return true;
//                }

                // Validate expected patterns
                if (queryString.matches("locID=\\d+(/manage)?") ||
                    queryString.matches("locID=\\d+(/edit)?") ||
                    queryString.matches("locID=\\d+(/manage\\?floor=\\w+)?(&itemHID=\\d+)?") ||
                    queryString.matches("locID=\\d+(/manage\\?itemHID=\\d+)?")) {
                    return true;
                }

                // Additional patterns for redirects with action & status (including empty action)
                if (queryString.matches("locID=\\d+/manage\\?floor=\\w+&action=[^&]*&status=[\\w_]+") ||
                    queryString.matches("locID=\\d+/manage\\?floor=\\w+&status=[\\w_]+")) {
                    return true;
                }

                // Already allowed ones with floor only
                if (queryString.matches("locID=\\d+/manage\\?floor=[\\w%]+") ||
                    queryString.matches("locID=\\d+/manage\\?floor=[\\w%]+&itemHID=\\d+")) {
                    return true;
                }
            
            // Allow quotation upload/archive result parameters
               if (queryString.matches("locID=\\d+/manage\\?floor=[\\w%]+&uploadResult=\\w+&uploadMessage=[\\w%\\+]+&itemID=\\d+") ||
                   queryString.matches("locID=\\d+/manage\\?floor=[\\w%]+&quotationResult=\\w+&quotationMessage=[\\w%\\+]+&itemID=\\d+")) {
                   return true;
                       }
                       
                       // Allow with just uploadResult or quotationResult (in case some params are missing)
                       if (queryString.matches("locID=\\d+/manage\\?floor=[\\w%]+((&uploadResult=\\w+)|(&quotationResult=\\w+)).*")) {
                           return true;
                       }
            
              if (queryString.matches("locID=\\d+/edit&error=\\w+&errorMsg=[\\w%\\+\\.]+") ||
                            queryString.matches("locID=\\d+/edit&error=\\w+")) {
                            return true;
                        }


                return false;

            case "/allDashboard/manage":
                if (queryString == null) return true;
            
                if (queryString.matches("manage\\?itemHID=\\d+")) {
                    return true;
                }
            
                if (queryString.matches("itemHID=\\d+")) return true;
                if (queryString.matches(
                    "(uploadResult=\\w+&uploadMessage=[\\w%\\+]+&itemID=\\d+)|" +
                    "(quotationResult=\\w+&quotationMessage=[\\w%\\+]+&itemID=\\d+)"
                )) return true;
                // Allow action + status redirects (only _ allowed as special char)
                if (queryString.matches("action=[A-Za-z0-9_]*&status=[A-Za-z0-9_]+")) return true;
                
                
                return false;
            case "/homepage":
            case "/allDashboard":
            case "/calendar":
            case "/settings":
            case "/mapView":
            case "/maintenanceSchedule":
           
                return true;

            default:
                return false;
        }
    }
    
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return requestedWith != null && "XMLHttpRequest".equals(requestedWith);
    }


}



    
