  package com.sample;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import sample.model.PooledConnection;

@WebServlet({"/maintenanceSave"})
public class maintenanceController extends HttpServlet {
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getParameter("action");
      String redirectParams = "";

      try {
         Connection con = PooledConnection.getConnection();
         Throwable var6 = null;

         try {
            int itemTypeId;
            if ("archive".equals(action)) {
               itemTypeId = Integer.parseInt(request.getParameter("itemMsId"));
               String updateSql = "UPDATE C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED SET ARCHIVED_FLAG = 2 WHERE ITEM_MS_ID = ?";
               PreparedStatement ps = con.prepareStatement(updateSql);
               Throwable var10 = null;

               try {
                  ps.setInt(1, itemTypeId);
                  int rowsUpdated = ps.executeUpdate();
                  if (rowsUpdated > 0) {
                     redirectParams = "?action=archived";
                  } else {
                     redirectParams = "?error=true";
                  }
               } catch (Throwable var62) {
                  var10 = var62;
                  throw var62;
               } finally {
                  if (ps != null) {
                     if (var10 != null) {
                        try {
                           ps.close();
                        } catch (Throwable var61) {
                           var10.addSuppressed(var61);
                        }
                     } else {
                        ps.close();
                     }
                  }

               }
            } else {
               itemTypeId = Integer.parseInt(request.getParameter("itemTypeId"));
               int noOfDays = Integer.parseInt(request.getParameter("noOfDays"));
               String remarks = request.getParameter("remarks");
               int noOfDaysWarning = Integer.parseInt(request.getParameter("noOfDaysWarning"));
               String quarterlySchedule = request.getParameter("quarterlySchedule");
               String yearlySchedule = request.getParameter("yearlySchedule");
               String itemMsIdStr = request.getParameter("itemMsId");
               System.out.println("itemTypeId: " + itemTypeId);
               System.out.println("noOfDays: " + noOfDays);
               System.out.println("remarks: " + remarks);
               System.out.println("noOfDaysWarning: " + noOfDaysWarning);
               System.out.println("quarterlySchedule: " + quarterlySchedule);
               System.out.println("yearlySchedule: " + yearlySchedule);
               System.out.println("itemMsIdStr: " + itemMsIdStr);
               boolean isEdit = itemMsIdStr != null && !itemMsIdStr.trim().isEmpty();
               String sql;
               if (isEdit) {
                  sql = "UPDATE C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED SET ITEM_TYPE_ID = ?, NO_OF_DAYS = ?, REMARKS = ?, NO_OF_DAYS_WARNING = ?, QUARTERLY_SCHED_NO = ?, YEARLY_SCHED_NO = ? WHERE ITEM_MS_ID = ?";
               } else {
                  sql = "INSERT INTO C##FMO_ADM.FMO_ITEM_MAINTENANCE_SCHED (ITEM_MS_ID, ITEM_TYPE_ID, NO_OF_DAYS, REMARKS, NO_OF_DAYS_WARNING, QUARTERLY_SCHED_NO, YEARLY_SCHED_NO, ARCHIVED_FLAG, MAIN_TYPE_ID) VALUES (C##FMO_ADM.FMO_ITEM_MS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, 1, 1)";
               }

               PreparedStatement ps = con.prepareStatement(sql);
               Throwable var17 = null;

               try {
                  ps.setInt(1, itemTypeId);
                  ps.setInt(2, noOfDays);
                  ps.setString(3, remarks);
                  ps.setInt(4, noOfDaysWarning);
                  if (noOfDays == 90 && quarterlySchedule != null && !quarterlySchedule.isEmpty()) {
                     ps.setInt(5, Integer.parseInt(quarterlySchedule));
                     ps.setNull(6, 4);
                  } else if ((noOfDays == 365 || noOfDays == 180) && yearlySchedule != null && !yearlySchedule.isEmpty()) {
                     ps.setNull(5, 4);
                     ps.setInt(6, Integer.parseInt(yearlySchedule));
                  } else {
                     ps.setNull(5, 4);
                     ps.setNull(6, 4);
                  }

                  if (isEdit) {
                     ps.setInt(7, Integer.parseInt(itemMsIdStr));
                  }

                  int result = ps.executeUpdate();
                  if (result > 0) {
                     redirectParams = isEdit ? "?action=updated" : "?action=added";
                  } else {
                     redirectParams = "?error=true";
                  }
               } catch (Throwable var63) {
                  var17 = var63;
                  throw var63;
               } finally {
                  if (ps != null) {
                     if (var17 != null) {
                        try {
                           ps.close();
                        } catch (Throwable var60) {
                           var17.addSuppressed(var60);
                        }
                     } else {
                        ps.close();
                     }
                  }

               }
            }
         } catch (Throwable var66) {
            var6 = var66;
            throw var66;
         } finally {
            if (con != null) {
               if (var6 != null) {
                  try {
                     con.close();
                  } catch (Throwable var59) {
                     var6.addSuppressed(var59);
                  }
               } else {
                  con.close();
               }
            }

         }
      } catch (Exception var68) {
         var68.printStackTrace();
         redirectParams = "?error=true";
      }

      response.sendRedirect("maintenanceSchedule" + redirectParams);
   }
}