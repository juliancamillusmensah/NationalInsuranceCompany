package com.insurance.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

// SMTP imports for manual email mode
import jakarta.mail.*;
import jakarta.mail.internet.*;
import com.insurance.dao.SystemDAO;

/**
 * Email service using Resend REST API (https://resend.com).
 * Free tier: 3,000 emails/month, 100 emails/day.
 * 
 * Setup:
 * 1. Sign up at https://resend.com and get an API key
 * 2. Add system settings in the DB:
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('email_api_key', 're_xxxxxxxxxx');
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('email_from_address', 'NIC <noreply@yourdomain.com>');
 * 3. Verify your sender domain at Resend dashboard
 */
public class EmailService {

    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final String RESEND_API_URL = "https://api.resend.com/emails";

    /**
     * Send an email via Resend API.
     *
     * @param to      Recipient email address
     * @param subject Email subject
     * @param htmlBody HTML content of the email
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendEmail(String to, String subject, String htmlBody) {
        return sendEmail(new String[]{to}, subject, htmlBody) == null;
    }

    /**
     * Send an email and return error message if failed, null if success.
     */
    public static String sendEmailWithError(String to, String subject, String htmlBody) {
        return sendEmail(new String[]{to}, subject, htmlBody);
    }

    /**
     * Send an email to multiple recipients via Resend API.
     *
     * @param recipients Array of recipient email addresses
     * @param subject    Email subject
     * @param htmlBody   HTML content of the email
     * @return null if success, error message string if failed
     */
    private static String sendEmail(String[] recipients, String subject, String htmlBody) {
        String apiKey = getApiKey();
        String fromAddress = getFromAddress();

        if (apiKey == null || apiKey.isEmpty() || apiKey.startsWith("re_XXX")) {
            LOGGER.warning("Email API key not configured. Skipping email send.");
            return "Email API key not configured. Please set it in Email Settings.";
        }

        if (recipients == null || recipients.length == 0) {
            LOGGER.warning("No recipients provided. Skipping email send.");
            return "No recipients provided.";
        }

        try {
            // Build JSON payload
            StringBuilder toList = new StringBuilder("[");
            for (int i = 0; i < recipients.length; i++) {
                if (i > 0) toList.append(",");
                toList.append("\"").append(escapeJson(recipients[i])).append("\"");
            }
            toList.append("]");

            String jsonPayload = "{" +
                "\"from\":\"" + escapeJson(fromAddress) + "\"," +
                "\"to\":" + toList.toString() + "," +
                "\"subject\":\"" + escapeJson(subject) + "\"," +
                "\"html\":\"" + escapeJson(htmlBody) + "\"" +
                "}";

            URL url = new URL(RESEND_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(15000);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();

            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                        responseCode >= 400 ? conn.getErrorStream() : conn.getInputStream(),
                        StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode >= 200 && responseCode < 300) {
                LOGGER.info("Email sent successfully to " + String.join(", ", recipients) + " | Subject: " + subject);
                return null;
            } else {
                String responseBody = response.toString();
                String errorMsg;
                if (responseCode == 403 && responseBody.contains("own email address")) {
                    errorMsg = "Resend Free Tier Limit: You can only send emails to your own email address (juliancamillusmensah17@gmail.com). " +
                        "To send to other recipients, verify a domain at https://resend.com/domains";
                } else if (responseCode == 403 && responseBody.contains("not verified")) {
                    errorMsg = "Sender domain not verified in Resend. " +
                        "Go to https://resend.com/domains to verify your domain, " +
                        "or set email_from_address to 'NIC <onboarding@resend.dev>' for testing.";
                } else {
                    errorMsg = "Email send failed. HTTP " + responseCode + ": " + responseBody;
                }
                LOGGER.severe(errorMsg);
                return errorMsg;
            }

        } catch (Exception e) {
            String errorMsg = "Failed to send email: " + e.getMessage();
            LOGGER.log(Level.SEVERE, errorMsg, e);
            return errorMsg;
        }
    }

    // ========== Convenience Methods for Common Email Types ==========

    /**
     * Send a notification email (in-app notification mirrored to email).
     */
    public static boolean sendNotificationEmail(String toEmail, String title, String message, String type) {
        String color = switch (type != null ? type.toLowerCase() : "info") {
            case "success" -> "#10b981";
            case "warning" -> "#f59e0b";
            case "error", "danger" -> "#ef4444";
            default -> "#3b82f6"; // info
        };

        String html = "<div style=\"font-family:Arial,sans-serif;max-width:600px;margin:0 auto;\">" +
            "<div style=\"background:#1e3a5f;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;\">" +
            "<h2 style=\"margin:0;\">National Insurance Commission</h2></div>" +
            "<div style=\"padding:20px;border:1px solid #e5e7eb;border-top:none;\">" +
            "<h3 style=\"color:" + color + ";\">" + escapeHtml(title) + "</h3>" +
            "<p>" + escapeHtml(message) + "</p>" +
            "<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:20px 0;\">" +
            "<p style=\"color:#6b7280;font-size:12px;\">This is an automated notification from the NIC Portal. " +
            "Do not reply to this email.</p></div></div>";

        return sendEmail(toEmail, title + " — NIC Portal", html);
    }

    /**
     * Send an admin invitation email with registration link.
     * @return null if success, error message if failed
     */
    public static String sendInvitationEmailWithError(String toEmail, String inviteToken, String invitedRole, String baseUrl) {
        String registrationLink = baseUrl + "/register_admin.jsp?token=" + inviteToken;

        String html = "<div style=\"font-family:Arial,sans-serif;max-width:600px;margin:0 auto;\">" +
            "<div style=\"background:#1e3a5f;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;\">" +
            "<h2 style=\"margin:0;\">National Insurance Commission</h2></div>" +
            "<div style=\"padding:20px;border:1px solid #e5e7eb;border-top:none;\">" +
            "<h3>You're Invited!</h3>" +
            "<p>You have been invited to join the NIC Portal as <strong>" + escapeHtml(invitedRole) + "</strong>.</p>" +
            "<p>Click the button below to complete your registration:</p>" +
            "<a href=\"" + escapeHtml(registrationLink) + "\" " +
            "style=\"display:inline-block;background:#1e3a5f;color:#fff;padding:12px 24px;" +
            "border-radius:6px;text-decoration:none;font-weight:bold;margin:10px 0;\">" +
            "Complete Registration</a>" +
            "<p style=\"color:#6b7280;font-size:14px;\">Or copy this link:<br>" +
            "<a href=\"" + escapeHtml(registrationLink) + "\">" + escapeHtml(registrationLink) + "</a></p>" +
            "<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:20px 0;\">" +
            "<p style=\"color:#6b7280;font-size:12px;\">This invitation link is time-limited. " +
            "If you did not expect this invitation, please ignore this email.</p></div></div>";

        return sendEmailWithError(toEmail, "NIC Portal — Invitation to Join as " + invitedRole, html);
    }

    /**
     * Send an admin invitation email with registration link (legacy boolean return).
     */
    public static boolean sendInvitationEmail(String toEmail, String inviteToken, String invitedRole, String baseUrl) {
        return sendInvitationEmailWithError(toEmail, inviteToken, invitedRole, baseUrl) == null;
    }

    /**
     * Send a new claim notification to company admin.
     */
    public static boolean sendClaimNotificationEmail(String adminEmail, String claimId, String claimAmount, String policyName, String customerName) {
        String html = "<div style=\"font-family:Arial,sans-serif;max-width:600px;margin:0 auto;\">" +
            "<div style=\"background:#1e3a5f;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;\">" +
            "<h2 style=\"margin:0;\">National Insurance Commission</h2></div>" +
            "<div style=\"padding:20px;border:1px solid #e5e7eb;border-top:none;\">" +
            "<h3 style=\"color:#ef4444;\">New Claim Filed</h3>" +
            "<p>A new claim has been submitted and requires your attention:</p>" +
            "<table style=\"width:100%;border-collapse:collapse;\">" +
            "<tr><td style=\"padding:8px;border:1px solid #e5e7eb;font-weight:bold;\">Claim ID</td>" +
            "<td style=\"padding:8px;border:1px solid #e5e7eb;\">" + escapeHtml(claimId) + "</td></tr>" +
            "<tr><td style=\"padding:8px;border:1px solid #e5e7eb;font-weight:bold;\">Amount</td>" +
            "<td style=\"padding:8px;border:1px solid #e5e7eb;\">GHS " + escapeHtml(claimAmount) + "</td></tr>" +
            "<tr><td style=\"padding:8px;border:1px solid #e5e7eb;font-weight:bold;\">Policy</td>" +
            "<td style=\"padding:8px;border:1px solid #e5e7eb;\">" + escapeHtml(policyName) + "</td></tr>" +
            "<tr><td style=\"padding:8px;border:1px solid #e5e7eb;font-weight:bold;\">Filed By</td>" +
            "<td style=\"padding:8px;border:1px solid #e5e7eb;\">" + escapeHtml(customerName) + "</td></tr>" +
            "</table>" +
            "<p>Please log in to the NIC Portal to review and process this claim.</p>" +
            "<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:20px 0;\">" +
            "<p style=\"color:#6b7280;font-size:12px;\">This is an automated notification from the NIC Portal.</p></div></div>";

        return sendEmail(adminEmail, "New Claim Filed — " + claimId, html);
    }

    /**
     * Send an approval request email.
     */
    public static boolean sendApprovalRequestEmail(String approverEmail, String requestType, String requesterName, String details, String baseUrl) {
        String portalLink = baseUrl + "/Superadmin.jsp";

        String html = "<div style=\"font-family:Arial,sans-serif;max-width:600px;margin:0 auto;\">" +
            "<div style=\"background:#1e3a5f;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;\">" +
            "<h2 style=\"margin:0;\">National Insurance Commission</h2></div>" +
            "<div style=\"padding:20px;border:1px solid #e5e7eb;border-top:none;\">" +
            "<h3 style=\"color:#f59e0b;\">Approval Request</h3>" +
            "<p><strong>" + escapeHtml(requesterName) + "</strong> has submitted a request that requires your approval:</p>" +
            "<div style=\"background:#f9fafb;padding:15px;border-radius:6px;border-left:4px solid #f59e0b;\">" +
            "<p style=\"margin:0;\"><strong>Request Type:</strong> " + escapeHtml(requestType) + "</p>" +
            "<p style=\"margin:5px 0 0 0;\"><strong>Details:</strong> " + escapeHtml(details) + "</p></div>" +
            "<a href=\"" + escapeHtml(portalLink) + "\" " +
            "style=\"display:inline-block;background:#f59e0b;color:#fff;padding:12px 24px;" +
            "border-radius:6px;text-decoration:none;font-weight:bold;margin:15px 0;\">" +
            "Review in Portal</a>" +
            "<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:20px 0;\">" +
            "<p style=\"color:#6b7280;font-size:12px;\">This is an automated notification from the NIC Portal.</p></div></div>";

        return sendEmail(approverEmail, "Approval Request — " + requestType, html);
    }

    // ========== Private Helpers ==========

    private static String getApiKey() {
        try {
            return new com.insurance.dao.SystemDAO().getSystemSetting("email_api_key");
        } catch (Exception e) {
            LOGGER.warning("Could not read email_api_key from system settings: " + e.getMessage());
            return null;
        }
    }

    private static String getFromAddress() {
        try {
            String from = new com.insurance.dao.SystemDAO().getSystemSetting("email_from_address");
            return (from != null && !from.isEmpty()) ? from : "NIC <onboarding@resend.dev>";
        } catch (Exception e) {
            return "NIC <onboarding@resend.dev>";
        }
    }

    // ========== SMTP (Manual Mode) Methods ==========

    /**
     * Send email via SMTP without using Resend API.
     * Supports Gmail, Outlook, or any SMTP server.
     */
    public static String sendEmailViaSMTP(String to, String subject, String htmlBody) {
        try {
            SystemDAO dao = new SystemDAO();
            String smtpHost = dao.getSystemSetting("smtp_host");
            String smtpPort = dao.getSystemSetting("smtp_port");
            String smtpUser = dao.getSystemSetting("smtp_username");
            String smtpPass = dao.getSystemSetting("smtp_password");
            String smtpFrom = dao.getSystemSetting("smtp_from");
            String smtpSSL = dao.getSystemSetting("smtp_ssl");

            if (smtpHost == null || smtpHost.isEmpty()) {
                return "SMTP not configured. Please set SMTP settings.";
            }

            // Default values
            if (smtpPort == null || smtpPort.isEmpty()) smtpPort = "587";
            if (smtpFrom == null || smtpFrom.isEmpty()) smtpFrom = smtpUser;

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", smtpPort);
            
            // Gmail and most modern SMTP servers use STARTTLS on port 587
            // Port 465 uses SSL directly (older method)
            boolean useSSL = "true".equals(smtpSSL);
            
            if ("465".equals(smtpPort)) {
                // SSL/TLS direct connection
                props.put("mail.smtp.ssl.enable", "true");
                props.put("mail.smtp.starttls.enable", "false");
            } else if ("587".equals(smtpPort) || useSSL) {
                // STARTTLS (upgrade connection to TLS after initial handshake)
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.ssl.enable", "false");
                // Trust all hosts (helpful for debugging, remove in production if security is critical)
                props.put("mail.smtp.ssl.trust", "*");
            } else {
                // No encryption
                props.put("mail.smtp.starttls.enable", "false");
                props.put("mail.smtp.ssl.enable", "false");
            }

            // Debug logging
            LOGGER.info("SMTP Config: host=" + smtpHost + ", port=" + smtpPort + ", user=" + smtpUser + ", tls=" + useSSL);

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(smtpUser, smtpPass);
                }
            });
            
            // Enable session debug for troubleshooting
            session.setDebug(true);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpFrom));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            LOGGER.info("SMTP email sent successfully to " + to);
            return null; // Success

        } catch (AuthenticationFailedException e) {
            LOGGER.log(Level.SEVERE, "SMTP authentication failed", e);
            return "SMTP authentication failed. Check username and password. For Gmail: (1) Enable 2FA, (2) Generate App Password at myaccount.google.com/apppasswords, (3) Use that 16-char password here (not your regular password).";
        } catch (MessagingException e) {
            String msg = e.getMessage();
            LOGGER.log(Level.SEVERE, "Failed to send SMTP email: " + msg, e);
            if (msg != null && msg.contains("EOF")) {
                return "SMTP connection failed. This usually means: (1) Wrong port - try 587 for Gmail with TLS checked, (2) Firewall blocking connection, or (3) ISP blocking port 587. Try port 465 with SSL instead.";
            }
            return "SMTP error: " + msg;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error sending SMTP email", e);
            return "Error: " + e.getMessage();
        }
    }

    /**
     * Send invitation email via SMTP.
     * @return null if success, error message if failed
     */
    public static String sendInvitationEmailViaSMTP(String toEmail, String inviteToken, String invitedRole, String baseUrl) {
        String registrationLink = baseUrl + "/register_admin.jsp?token=" + inviteToken;

        String html = "<div style=\"font-family:Arial,sans-serif;max-width:600px;margin:0 auto;\">" +
            "<div style=\"background:#1e3a5f;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;\">" +
            "<h2 style=\"margin:0;\">National Insurance Commission</h2></div>" +
            "<div style=\"padding:20px;border:1px solid #e5e7eb;border-top:none;\">" +
            "<h3>You're Invited!</h3>" +
            "<p>You have been invited to join the NIC Portal as <strong>" + escapeHtml(invitedRole) + "</strong>.</p>" +
            "<p>Click the button below to complete your registration:</p>" +
            "<a href=\"" + escapeHtml(registrationLink) + "\" " +
            "style=\"display:inline-block;background:#1e3a5f;color:#fff;padding:12px 24px;" +
            "border-radius:6px;text-decoration:none;font-weight:bold;margin:10px 0;\">" +
            "Complete Registration</a>" +
            "<p style=\"color:#6b7280;font-size:14px;\">Or copy this link:<br>" +
            "<a href=\"" + escapeHtml(registrationLink) + "\">" + escapeHtml(registrationLink) + "</a></p>" +
            "<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:20px 0;\">" +
            "<p style=\"color:#6b7280;font-size:12px;\">This invitation link is time-limited. " +
            "If you did not expect this invitation, please ignore this email.</p></div></div>";

        return sendEmailViaSMTP(toEmail, "NIC Portal — Invitation to Join as " + invitedRole, html);
    }

    /**
     * Detect email mode and send accordingly.
     * Returns error message or null on success.
     */
    public static String sendEmailAuto(String to, String subject, String htmlBody) {
        SystemDAO dao = new SystemDAO();
        String mode = dao.getSystemSetting("email_mode");
        if ("smtp".equals(mode)) {
            return sendEmailViaSMTP(to, subject, htmlBody);
        } else {
            return sendEmailWithError(to, subject, htmlBody);
        }
    }

    private static String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    private static String escapeHtml(String str) {
        if (str == null) return "";
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
    }
}
