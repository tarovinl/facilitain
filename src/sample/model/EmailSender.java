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
    

    public static void sendEmail(String recipientEmail, final String username, final String password, String reportCode, String location, String floor, String eqmtType, String issue, Date dateIssued) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // Trust Gmail's SSL certificate

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
            message.setSubject("FMO REPORT STATUS");
            message.setText("Your report status on:\n" +
                "CODE: " + reportCode + "\n" +
                "LOCATION: " + location + "\n" +
                "FLOOR: " + floor + "\n" +
                "EQUIPMENT TYPE: " + eqmtType + "\n" +
                "ISSUE: " + issue + "\n" +
                "DATE ISSUED: " + dateIssued + "\n\n" +
                "is now RESOLVED");

            Transport.send(message);

            System.out.println("Email sent successfully.");

        } catch (MessagingException e) {
            e.printStackTrace(); // Print the exception stack trace for debugging
            // Handle the exception gracefully or log it for further investigation
        }
    }
}