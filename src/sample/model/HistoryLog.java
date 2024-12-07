package sample.model;

import java.sql.Timestamp;

public class HistoryLog {
    private int logId;
    private String tableName;
    private String operationType;
    private Timestamp operationTimestamp;
    private String username;
    private String rowData;

    public HistoryLog(int logId, String tableName, String operationType, Timestamp operationTimestamp, String username, String rowData) {
        this.logId = logId;
        this.tableName = tableName;
        this.operationType = operationType;
        this.operationTimestamp = operationTimestamp;
        this.username = username;
        this.rowData = rowData;
    }

    public int getLogId() {
        return logId;
    }

    public String getTableName() {
        return tableName;
    }

    public String getOperationType() {
        return operationType;
    }

    public Timestamp getOperationTimestamp() {
        return operationTimestamp;
    }

    public String getUsername() {
        return username;
    }

    public String getRowData() {
        return rowData;
    }

    // This method formats the rowData into a user-friendly format
    public String getFormattedRowData() {
       
        if (rowData == null || rowData.isEmpty()) {
            return "No data available";
        }

        // Split the rowData string by commas
        String[] dataParts = rowData.split(",");
        StringBuilder formattedData = new StringBuilder();

        for (String part : dataParts) {
            // Trim extra spaces and add a new line for each part
            formattedData.append(part.trim()).append("<br>");
        }

        return formattedData.toString();
    }

    public String toJson() {
        String timestamp = operationTimestamp != null ? operationTimestamp.toString() : "null";
        return "{"
            + "\"logId\": " + logId + ", "
            + "\"tableName\": \"" + tableName + "\", "
            + "\"operationType\": \"" + operationType + "\", "
            + "\"operationTimestamp\": \"" + timestamp + "\", "
            + "\"username\": \"" + username + "\", "
            + "\"rowData\": \"" + rowData + "\""
            + "}";
    }
}
