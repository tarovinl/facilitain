package com.sample;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.PreparedStatement;

import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.PooledConnection;

@WebServlet(name = "floorController", urlPatterns = { "/floorcontroller" })
public class floorController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String action = "";
        String status = "success";
        
        String locID = request.getParameter("locID"); // locID is used for editing
        
        String editFlrID = request.getParameter("editFlrID");
        String editFlrName = request.getParameter("editFlrName");
        String editFlrDesc = request.getParameter("editFlrDesc");
        
//        String addFlrLocId = request.getParameter("addFlrLocID");
        String addFlrName = request.getParameter("addFlrName");
        String addFlrDesc = request.getParameter("addFlrDesc");
        
//        String archFlrLocID = request.getParameter("archiveFlrLocID");
        String archFlrID = request.getParameter("archiveFlrID");
        String archFlr = request.getParameter("archiveFlr");
        
        String actFlrID = request.getParameter("activateFlrID");
        String actFlr = request.getParameter("activateFlr");

//        System.out.println(archFlrID);
//        System.out.println(archFlr);
//            System.out.println(editFlrID);
//        System.out.println(editFlrName);
//        System.out.println(editFlrDesc);

        try (Connection conn = PooledConnection.getConnection()) {
            String sql;

                if (editFlrID != null && !editFlrID.isEmpty()) {
                            sql = "UPDATE FMO_ADM.FMO_ITEM_LOC_FLOORS SET NAME = ?, DESCRIPTION = ? WHERE ITEM_LOC_FLR_ID = ?";
                        } else if (archFlrID != null && !archFlrID.isEmpty()) {
                            sql = "UPDATE FMO_ADM.FMO_ITEM_LOC_FLOORS SET ARCHIVED_FLAG = 2 WHERE ITEM_LOC_FLR_ID = ?";
                        } else if (actFlrID != null && !actFlrID.isEmpty()) {
                            sql = "UPDATE FMO_ADM.FMO_ITEM_LOC_FLOORS SET ARCHIVED_FLAG = 1 WHERE ITEM_LOC_FLR_ID = ?";
                        } else {
                            sql = "INSERT INTO FMO_ADM.FMO_ITEM_LOC_FLOORS (ITEM_LOC_ID, NAME, DESCRIPTION, ARCHIVED_FLAG) VALUES (?, ?, ?, 1)";
                        }
                        
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            if (editFlrID != null && !editFlrID.isEmpty()) {
                                stmt.setString(1, editFlrName);
                                stmt.setString(2, editFlrDesc);
                                stmt.setInt(3, Integer.parseInt(editFlrID));
                                
                                action = "floor_update";
                            } else if (archFlrID != null && !archFlrID.isEmpty()) {
                                stmt.setInt(1, Integer.parseInt(archFlrID));
                                
                                action = "floor_archive";
                            } else if (actFlrID != null && !actFlrID.isEmpty()) {
                                stmt.setInt(1, Integer.parseInt(actFlrID));
                            } else {
                                stmt.setInt(1, Integer.parseInt(locID));
                                stmt.setString(2, addFlrName);
                                stmt.setString(3, addFlrDesc);
                                
                                action = "floor_add";
                            }
                            
                            stmt.executeUpdate();
                        }

            // Redirect to building dashboard after saving changes
            response.sendRedirect("buildingDashboard?locID=" + locID + "/edit" + "&action=" + action + "&status=" + status);
        } catch (SQLException e) {
            e.printStackTrace();
            status = "error";
            throw new ServletException("Database error while adding/editing building.");
        }
    }
}