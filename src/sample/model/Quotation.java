package sample.model;
import java.util.Date;

public class Quotation {
    private int quotationId;       
    private int archiveFlag; 
    private String description;      
    private Date dateUploaded;     
    private int itemId;              
    private byte[] quotationFile1;    // First file
    private byte[] quotationFile2;    // Second file
    private String file1Name;         // Original filename for file 1
    private String file2Name;         // Original filename for file 2
    private String file1Type;         // Content type for file 1
    private String file2Type;         // Content type for file 2
   
    // Getters and Setters
    
    public int getArchiveFlag() {
         return archiveFlag;
     }
     public void setArchiveFlag(int archiveFlag) {
         this.archiveFlag = archiveFlag;
     }
     
    public int getQuotationId() {
        return quotationId;
    }
    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public Date getDateUploaded() {
        return dateUploaded;
    }
    public void setDateUploaded(Date dateUploaded) {
        this.dateUploaded = dateUploaded;
    }
    public int getItemId() {
        return itemId;
    }
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    // File 1 getters and setters
    public byte[] getQuotationFile1() {
        return quotationFile1;
    }
    public void setQuotationFile1(byte[] quotationFile1) {
        this.quotationFile1 = quotationFile1;
    }
    
    // File 2 getters and setters
    public byte[] getQuotationFile2() {
        return quotationFile2;
    }
    public void setQuotationFile2(byte[] quotationFile2) {
        this.quotationFile2 = quotationFile2;
    }
    
    public String getFile1Name() {
        return file1Name;
    }
    public void setFile1Name(String file1Name) {
        this.file1Name = file1Name;
    }
    
    public String getFile2Name() {
        return file2Name;
    }
    public void setFile2Name(String file2Name) {
        this.file2Name = file2Name;
    }
    
    public String getFile1Type() {
        return file1Type;
    }
    public void setFile1Type(String file1Type) {
        this.file1Type = file1Type;
    }
    
    public String getFile2Type() {
        return file2Type;
    }
    public void setFile2Type(String file2Type) {
        this.file2Type = file2Type;
    }
    
    // Legacy getter for backward compatibility
    @Deprecated
    public byte[] getQuotationImage() {
        return quotationFile1;
    }
    
    // Legacy setter for backward compatibility
    @Deprecated
    public void setQuotationImage(byte[] quotationImage) {
        this.quotationFile1 = quotationImage;
    }
}