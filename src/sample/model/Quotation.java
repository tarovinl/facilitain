package sample.model;

import java.util.Date;

public class Quotation {
    private int quotationId;       
    private int archiveFlag; 
    private String description;      
    private Date dateUploaded;     
    private int itemId;              
    private byte[] quotationImage;    
   
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

    public byte[] getQuotationImage() {
        return quotationImage;
    }

    public void setQuotationImage(byte[] quotationImage) {
        this.quotationImage = quotationImage;
    }
}