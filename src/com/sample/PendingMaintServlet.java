package com.sample;

import com.google.gson.Gson;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.sql.SQLException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import sample.model.PooledConnection;

@WebServlet("/PendingMaintServlet")
public class PendingMaintServlet extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1252";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String locID = request.getParameter("locID");

        List<Map<String, Object>> dataList = new ArrayList<>();

        String query = 
        "SELECT " + 
        "    c.item_cat_id AS CATEGORY_ID, " + 
        "    c.name AS CATEGORY_NAME, " + 
        "    COUNT(i.item_id) AS ITEM_COUNT " + 
        "FROM FMO_ADM.FMO_ITEM_CATEGORIES c " + 
        "JOIN " + 
        "    FMO_ADM.FMO_ITEM_TYPES t " + 
        "    ON c.item_cat_id = t.item_cat_id " + 
        "JOIN " + 
        "    FMO_ADM.FMO_ITEMS i " + 
        "    ON i.item_type_id = t.item_type_id " + 
        "WHERE " + 
        "    i.location_id = ? " + 
        "    AND i.item_stat_id = 1 " + 
        "    AND i.maintenance_status = 2 " + 
        "GROUP BY " + 
        "    c.item_cat_id, c.name " + 
        "ORDER BY " + 
        "    c.name ";

        try (Connection conn = PooledConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, Integer.parseInt(locID));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("category", rs.getString("CATEGORY_NAME"));
                    data.put("count", rs.getInt("ITEM_COUNT"));
                    dataList.add(data);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Convert Java list to JSON
        String json = new Gson().toJson(dataList);
        response.getWriter().write(json);
    }
}
