<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.EmailService" %>
<% 
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    String roleId = (String) sess.getAttribute("roleId");
    if (!"ROLE_SYSTEM_CREATOR".equals(roleId) && !"ROLE_SUPERADMIN".equals(roleId)) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String testEmail = request.getParameter("test_email");
    if (testEmail == null || testEmail.trim().isEmpty()) {
        response.sendRedirect("email_settings.jsp?error=invalid_email");
        return;
    }

    SystemDAO dao = new SystemDAO();
    String emailMode = dao.getSystemSetting("email_mode");
    String apiKey = dao.getSystemSetting("email_api_key");
    
    // Check if email is configured
    boolean configured = false;
    if ("smtp".equals(emailMode)) {
        String smtpHost = dao.getSystemSetting("smtp_host");
        String smtpUser = dao.getSystemSetting("smtp_username");
        configured = smtpHost != null && !smtpHost.isEmpty() && 
                     smtpUser != null && !smtpUser.isEmpty();
    } else {
        configured = apiKey != null && !apiKey.isEmpty() && !apiKey.startsWith("re_XXX");
    }
    
    if (!configured) {
        response.sendRedirect("email_settings.jsp?error=no_api_key");
        return;
    }

    // Send test email based on mode
    String errorMsg = null;
    boolean sent = false;
    
    if ("smtp".equals(emailMode)) {
        String htmlBody = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;'>" +
            "<div style='background:#10b981;color:#fff;padding:20px;border-radius:8px 8px 0 0;text-align:center;'>" +
            "<h2 style='margin:0;'>National Insurance Commission</h2></div>" +
            "<div style='padding:20px;border:1px solid #e5e7eb;border-top:none;'>" +
            "<h3 style='color:#10b981;'>Test Email — NIC Portal</h3>" +
            "<p>This is a test email from the National Insurance Commission Portal.</p>" +
            "<p>If you received this, your <strong>SMTP email configuration</strong> is working correctly!</p>" +
            "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>" +
            "<p style='color:#6b7280;font-size:12px;'>Test email sent via SMTP mode.</p></div></div>";
        
        errorMsg = EmailService.sendEmailViaSMTP(testEmail.trim(), "Test Email — NIC Portal", htmlBody);
        sent = errorMsg == null;
    } else {
        sent = EmailService.sendNotificationEmail(
            testEmail.trim(),
            "Test Email — NIC Portal",
            "This is a test email from the National Insurance Commission Portal. If you received this, your Resend API email configuration is working correctly!",
            "Success"
        );
    }

    if (sent) {
        Account currentUser = (Account) sess.getAttribute("user");
        dao.logActivity(currentUser.getId(), "Sent Test Email", "To: " + testEmail, "config", "low");
        response.sendRedirect("email_settings.jsp?success=test_sent");
    } else {
        // Include error message in redirect
        if (errorMsg != null) {
            response.sendRedirect("email_settings.jsp?error=test_failed&msg=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        } else {
            response.sendRedirect("email_settings.jsp?error=test_failed");
        }
    }
%>
