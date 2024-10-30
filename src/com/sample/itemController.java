package com.sample;

import com.oracle.wls.shaded.org.apache.xalan.lib.Redirect;

import java.io.PrintWriter;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.PooledConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.sql.Date;

@WebServlet(name = "itemController", urlPatterns = { "/itemcontroller" })
public class itemController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
            // Access form parameters
            
        String itemName = request.getParameter("itemCode");
        String itemBuilding = request.getParameter("itemBuilding");
        String itemCat = request.getParameter("itemCat");
        String itemType = request.getParameter("itemType");
        String itemBrand = request.getParameter("itemBrand");
        String itemFloor = request.getParameter("itemAddFloor");
        String itemRoom = request.getParameter("itemAddRoom");
        String itemDateInst = request.getParameter("itemInstalled");
        String itemSchedNum = request.getParameter("itemSchedNum");
        String itemSched = request.getParameter("itemSched");
        String locText = request.getParameter("locText");
        String remarks = request.getParameter("remarks");
        
        String itemEID = request.getParameter("itemEditID");
        String itemEditName = request.getParameter("itemEditCode");
        String itemEditLoc = request.getParameter("itemEditLoc");
        String itemEditCat = request.getParameter("itemEditCat");
        String itemEditType = request.getParameter("itemEditType");
        String itemEditBrand = request.getParameter("itemEditBrand");
        String itemEditFloor = request.getParameter("itemEditFloor");
        String itemEditRoom = request.getParameter("itemEditRoom");
        String itemEditDateInst = request.getParameter("itemEditInstalled");
        String itemEditSchedNum = request.getParameter("itemEditSchedNum");
        String itemEditSched = request.getParameter("itemEditSched");
        String editLocText = request.getParameter("editLocText");
        String editRemarks = request.getParameter("editRemarks");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date sqlDate = null;
        Date sqlEditDate = null;
        
        try {
            if(itemEID == null){
                java.util.Date parsedDate = dateFormat.parse(itemDateInst);
                sqlDate = new Date(parsedDate.getTime()); 
            }else{
                java.util.Date parsedEDate = dateFormat.parse(itemEditDateInst);
                sqlEditDate = new Date(parsedEDate.getTime());
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
//        System.out.println(itemName);
//        System.out.println(itemBuilding);
//        System.out.println(itemCat);
//        System.out.println(itemType);
//        System.out.println(itemBrand);
//        System.out.println(itemFloor);
//        System.out.println(itemRoom);
//        System.out.println(itemDateInst);
//        System.out.println(sqlDate);
//        System.out.println(itemSchedNum + " - " + itemSched);
//        System.out.println(locText);
//        System.out.println(remarks);
        
//        System.out.println(sqlDate);
        

        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            if(itemEID == null){
                sql = "INSERT INTO C##FMO_ADM.FMO_ITEMS (ITEM_TYPE_ID,NAME,LOCATION_ID,LOCATION_TEXT,FLOOR_NO,ROOM_NO,DATE_INSTALLED,BRAND_NAME,REMARKS) values (?,?,?,?,?,?,?,?,?)";
                System.out.println("add this " + itemName);
                
            }else{
                sql = "UPDATE C##FMO_ADM.FMO_ITEMS SET ITEM_TYPE_ID = ?, NAME = ?, LOCATION_ID = ?, LOCATION_TEXT = ?, FLOOR_NO = ?, ROOM_NO = ?, DATE_INSTALLED = ?, BRAND_NAME = ?, REMARKS = ?  WHERE ITEM_ID = ?";
                System.out.println("edit this " + itemEditName);
            }
                
            

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                if(itemEID == null){
                    stmt.setInt(1, Integer.parseInt(itemType));
                    stmt.setString(2, itemName);
                    stmt.setInt(3, Integer.parseInt(itemBuilding));
                    stmt.setString(4, locText);
                    stmt.setString(5, itemFloor);
                    stmt.setString(6, itemRoom);
                    stmt.setDate(7, sqlDate);
                    stmt.setString(8, itemBrand);
                    stmt.setString(9, remarks);
                }else{
                    stmt.setInt(1, Integer.parseInt(itemEditType));
                    stmt.setString(2, itemEditName);
                    stmt.setInt(3, Integer.parseInt(itemEditLoc));
                    stmt.setString(4, editLocText);
                    stmt.setString(5, itemEditFloor);
                    stmt.setString(6, itemEditRoom);
                    stmt.setDate(7, sqlEditDate);
                    stmt.setString(8, itemEditBrand);
                    stmt.setString(9, editRemarks);
                    stmt.setInt(10, Integer.parseInt(itemEID));
                }

                
                stmt.executeUpdate();
            }

            // Redirect to homepage after processing
            response.sendRedirect("./homepage");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while adding/editing item.");
        }

            
    }

    public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
    }

    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                          IOException {
    }
}
