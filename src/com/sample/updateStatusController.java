package com.sample;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import java.math.BigDecimal;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import sample.model.PooledConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Timestamp;

import java.util.Arrays;
import java.util.Map;

import javax.servlet.annotation.MultipartConfig;

@WebServlet(name = "updateStatusController", urlPatterns = { "/updatestatuscontroller" })
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5 MB file size limit
public class updateStatusController extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        request.setCharacterEncoding("UTF-8");
        String action = "";
        String status = "success";
        
        String updateEquipmentID = request.getParameter("equipmentId");
        String oldEquipmentStatus = request.getParameter("equipmentStatus");
        String newEquipmentStatus = request.getParameter("statusNew");
        
        String description = request.getParameter("description");
        Part filePart = request.getPart("quotationFile");
        Map<String, String[]> parameterMap = request.getParameterMap();
            for (String key : parameterMap.keySet()) {
              System.out.println("Parameter: " + key + " = " + Arrays.toString(parameterMap.get(key)));
            }
        BigDecimal itemID = (updateEquipmentID != null && !updateEquipmentID.isEmpty()) ? new BigDecimal(updateEquipmentID) : null;
        InputStream fileInputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileInputStream = filePart.getInputStream();
        }

        
//        System.out.println("equip ID: " + updateEquipmentID);
//        System.out.println("old equip status: " + oldEquipmentStatus);
//        System.out.println("new equip status: " + newEquipmentStatus);
        
        
        
        try (Connection conn = PooledConnection.getConnection()) {
            String sql;
            
            sql = "UPDATE C##FMO_ADM.FMO_ITEMS SET MAINTENANCE_STATUS = ? WHERE ITEM_ID = ?";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(newEquipmentStatus));
                stmt.setInt(2, Integer.parseInt(updateEquipmentID));

                stmt.executeUpdate();
            }
            
            // Insert Quotation Only If File Exists and Required Fields Are Filled
            if ((oldEquipmentStatus.equals("2") && newEquipmentStatus.equals("3")) &&
                description != null && filePart != null && filePart.getSize() > 0) {
                BigDecimal quotationID = generateQuotationID(conn);


                String insertSQL = "INSERT INTO C##FMO_ADM.FMO_ITEM_QUOTATIONS (ITEM_ID, DESCRIPTION, QUOTATION_ID, QUOTATION_IMAGE, DATE_UPLOADED) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
                    pstmt.setBigDecimal(1, itemID);
                    pstmt.setString(2, description);
                    pstmt.setBigDecimal(3, quotationID);
                    pstmt.setBlob(4, fileInputStream);
                    pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                    pstmt.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                action = "modify_status";
            }
            
            //in maintenance to operational turn maint_assign entry is_completed to 1
            if (oldEquipmentStatus.equals("3") && newEquipmentStatus.equals("1")) {
                String assSQL = "UPDATE C##FMO_ADM.FMO_MAINTENANCE_ASSIGN SET IS_COMPLETED = 1 WHERE ITEM_ID = ?";
                try (PreparedStatement astmt = conn.prepareStatement(assSQL)) {
                    astmt.setInt(1, Integer.parseInt(updateEquipmentID));
                    astmt.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                action = "3to1";
            }
            
            response.sendRedirect("maintenancePage" + "?action=" + action + "&status=" + status);
        } catch (SQLException e) {
            status = "error";
            e.printStackTrace();
        }
    }
    
    private BigDecimal generateQuotationID(Connection conn) {
        BigDecimal newID = BigDecimal.ONE;
        String query = "SELECT MAX(QUOTATION_ID) FROM C##FMO_ADM.FMO_ITEM_QUOTATIONS";
        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                BigDecimal maxID = rs.getBigDecimal(1);
                if (maxID != null) {
                    newID = maxID.add(BigDecimal.ONE);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newID;
    }

}
