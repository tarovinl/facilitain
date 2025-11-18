package sample.model;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;

public class EmailSender {

    public static void sendEmail(String recipientEmail, final String username, final String password, 
                                  String reportCode, String location, String floor, 
                                  String eqmtType, String issue, Date dateIssued) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("UST Facility Management Office - Report Status");

            // Construct HTML content
            String emailContent = 
                "<!DOCTYPE html>" +
                "<html lang='en'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<link href='https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap' rel='stylesheet'>" +
                "<style>" +
                "@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap');" +
                "body { font-family: 'Montserrat', sans-serif; background-color: #F5F5F5; margin: 0; padding: 20px; line-height: 1.6; color: #000000; }" +
                ".email-container { max-width: 600px; margin: 0 auto; background-color: #FFFFFF; border-radius: 12px; box-shadow: 0 6px 12px rgba(0,0,0,0.08); overflow: hidden; }" +
                ".email-header { background-color: #FFCD00; color: #000000; text-align: center; padding: 20px; display: flex; align-items: center; justify-content: center; }" +
                ".email-header img { max-height: 80px; margin-right: 20px; }" +
                ".email-header h1 { margin: 0; font-size: 24px; font-weight: 700; text-transform: uppercase; color: #000000; }" +
                ".email-content { padding: 30px; color: #000000; }" +
                ".report-details { background-color: #F9F9F9; border-left: 5px solid #FFCD00; border-radius: 5px; padding: 20px; margin-bottom: 20px; }" +
                ".report-details ul { list-style-type: none; padding: 0; }" +
                ".report-details li { margin-bottom: 10px; border-bottom: 1px solid #E9ECEF; padding-bottom: 10px; display: flex; justify-content: space-between; color: #000000; }" +
                ".report-details li:last-child { border-bottom: none; }" +
                ".report-details .label { font-weight: 600; color: #8B0000; flex-basis: 40%; }" +
                ".report-details .value { flex-basis: 60%; text-align: right; color: #000000; }" +
                ".status-badge { background-color: #28A745; color: white; padding: 10px 15px; border-radius: 5px; display: inline-block; margin-top: 15px; font-weight: 600; }" +
                ".email-footer { text-align: center; background-color: #F1F1F1; padding: 15px; font-size: 12px; color: #000000; border-top: 1px solid #E9ECEF; }" +
                ".motto { font-style: italic; font-size: 14px; color: #6C757D; margin-top: 10px; }" +
                ".watermark { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-45deg); opacity: 0.1; font-size: 100px; color: #FFCD00; z-index: -1; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='email-container'>" +
                "<div class='email-header'>" +
                "<img src='https://upload.wikimedia.org/wikipedia/en/thumb/2/24/Seal_of_the_University_of_Santo_Tomas.svg/1280px-Seal_of_the_University_of_Santo_Tomas.svg.png' alt='UST Logo'>" +
                "<h1>Facility Management<br>Office Report</h1>" +
                "</div>" +
                "<div class='email-content'>" +
                "<p>Dear Thomasian,</p>" +
                "<p>We are writing to inform you about the status of your facility management report.</p>" +
                "<div class='report-details'>" +
                "<ul>" +
                "<li><span class='label'>Report Code:</span><span class='value'>" + reportCode + "</span></li>" +
                "<li><span class='label'>Location:</span><span class='value'>" + location + "</span></li>" +
                "<li><span class='label'>Floor:</span><span class='value'>" + floor + "</span></li>" +
                "<li><span class='label'>Equipment Type:</span><span class='value'>" + eqmtType + "</span></li>" +
                "<li><span class='label'>Issue:</span><span class='value'>" + issue + "</span></li>" +
                "<li><span class='label'>Date Issued:</span><span class='value'>" + dateIssued + "</span></li>" +
                "</ul>" +
                "<div class='status-badge'>RESOLVED</div>" +
                "</div>" +
                "<p>Thank you for your patience and cooperation in maintaining the facilities of the Pontifical and Royal University.</p>" +
                "</div>" +
                "<div class='email-footer'>" +
                "<p>&copy; 2024 University of Santo Tomas</p>" +
                "<p class='motto'>\"Veritas in Caritate\"</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";

            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setContent(emailContent, "text/html; charset=UTF-8");
            mimeMessage.setFrom(new InternetAddress(username));
            mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            mimeMessage.setSubject("UST FMO Report Status");

            Transport.send(mimeMessage);
            System.out.println("Email sent successfully.");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Sends email notification for maintenance assignment
     */
    public static void sendMaintenanceAssignmentEmail(String recipientEmail, final String username, 
                                                      final String password, String equipmentName,
                                                      String location, String floor, String room,
                                                      String equipmentType, String maintenanceType,
                                                      Date dateOfMaintenance) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {
            String emailContent = 
                "<!DOCTYPE html>" +
                "<html lang='en'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<link href='https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap' rel='stylesheet'>" +
                "<style>" +
                "@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap');" +
                "body { font-family: 'Montserrat', sans-serif; background-color: #F5F5F5; margin: 0; padding: 20px; line-height: 1.6; color: #000000; }" +
                ".email-container { max-width: 600px; margin: 0 auto; background-color: #FFFFFF; border-radius: 12px; box-shadow: 0 6px 12px rgba(0,0,0,0.08); overflow: hidden; }" +
                ".email-header { background-color: #FFCD00; color: #000000; text-align: center; padding: 20px; display: flex; align-items: center; justify-content: center; }" +
                ".email-header img { max-height: 80px; margin-right: 20px; }" +
                ".email-header h1 { margin: 0; font-size: 24px; font-weight: 700; text-transform: uppercase; color: #000000; }" +
                ".email-content { padding: 30px; color: #000000; }" +
                ".maintenance-details { background-color: #F9F9F9; border-left: 5px solid #FFCD00; border-radius: 5px; padding: 20px; margin-bottom: 20px; }" +
                ".maintenance-details ul { list-style-type: none; padding: 0; }" +
                ".maintenance-details li { margin-bottom: 10px; border-bottom: 1px solid #E9ECEF; padding-bottom: 10px; display: flex; justify-content: space-between; color: #000000; }" +
                ".maintenance-details li:last-child { border-bottom: none; }" +
                ".maintenance-details .label { font-weight: 600; color: #8B0000; flex-basis: 40%; }" +
                ".maintenance-details .value { flex-basis: 60%; text-align: right; color: #000000; }" +
                ".status-badge { background-color: #FFC107; color: #000000; padding: 10px 15px; border-radius: 5px; display: inline-block; margin-top: 15px; font-weight: 600; }" +
                ".email-footer { text-align: center; background-color: #F1F1F1; padding: 15px; font-size: 12px; color: #000000; border-top: 1px solid #E9ECEF; }" +
                ".motto { font-style: italic; font-size: 14px; color: #6C757D; margin-top: 10px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='email-container'>" +
                "<div class='email-header'>" +
                "<img src='https://upload.wikimedia.org/wikipedia/en/thumb/2/24/Seal_of_the_University_of_Santo_Tomas.svg/1280px-Seal_of_the_University_of_Santo_Tomas.svg.png' alt='UST Logo'>" +
                "<h1>Facility Management<br>Maintenance Assignment</h1>" +
                "</div>" +
                "<div class='email-content'>" +
                "<p>Dear Maintenance Personnel,</p>" +
                "<p>You have been assigned a new maintenance task. Please review the details below:</p>" +
                "<div class='maintenance-details'>" +
                "<ul>" +
                "<li><span class='label'>Equipment Name:</span><span class='value'>" + equipmentName + "</span></li>" +
                "<li><span class='label'>Equipment Type:</span><span class='value'>" + equipmentType + "</span></li>" +
                "<li><span class='label'>Maintenance Type:</span><span class='value'>" + maintenanceType + "</span></li>" +
                "<li><span class='label'>Location:</span><span class='value'>" + location + "</span></li>" +
                "<li><span class='label'>Floor:</span><span class='value'>" + floor + "</span></li>" +
                (room != null && !room.isEmpty() ? "<li><span class='label'>Room:</span><span class='value'>" + room + "</span></li>" : "") +
                "<li><span class='label'>Scheduled Date:</span><span class='value'>" + dateOfMaintenance + "</span></li>" +
                "</ul>" +
                "<div class='status-badge'>ASSIGNED</div>" +
                "</div>" +
                "<p>Please ensure that the maintenance task is completed on or before the scheduled date. " +
                "Log in to the FMO system to update the status once completed.</p>" +
                "<p>Thank you for your dedication to maintaining the facilities of the Pontifical and Royal University.</p>" +
                "</div>" +
                "<div class='email-footer'>" +
                "<p>&copy; 2024 University of Santo Tomas</p>" +
                "<p class='motto'>\"Veritas in Caritate\"</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";

            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setContent(emailContent, "text/html; charset=UTF-8");
            mimeMessage.setFrom(new InternetAddress(username));
            mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            mimeMessage.setSubject("UST FMO - New Maintenance Assignment");

            Transport.send(mimeMessage);
            System.out.println("Maintenance assignment email sent successfully to: " + recipientEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Failed to send maintenance assignment email to: " + recipientEmail);
        }
    }
}