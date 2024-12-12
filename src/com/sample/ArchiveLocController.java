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

@WebServlet(name = "ArchiveLocController", urlPatterns = { "/archiveloccontroller" })
public class ArchiveLocController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";


    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
        String locID = request.getParameter("archiveLocID");
        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            sql = "UPDATE FMO_ADM.FMO_ITEM_LOCATIONS SET ARCHIVED_FLAG = 2 WHERE ITEM_LOC_ID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, Integer.parseInt(locID));
                    
                    stmt.executeUpdate();
                }          
            
            response.sendRedirect("homepage");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while archiving building.");
        }
    }
}
