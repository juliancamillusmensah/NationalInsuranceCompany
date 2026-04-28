<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
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

    String emailMode = request.getParameter("email_mode");
    String apiKey = request.getParameter("api_key");
    String fromAddress = request.getParameter("from_address");
    // SMTP settings
    String smtpHost = request.getParameter("smtp_host");
    String smtpPort = request.getParameter("smtp_port");
    String smtpUser = request.getParameter("smtp_username");
    String smtpPass = request.getParameter("smtp_password");
    String smtpFrom = request.getParameter("smtp_from");
    String smtpSSL = request.getParameter("smtp_ssl");

    if (emailMode == null) {
        response.sendRedirect("email_settings.jsp?error=invalid_input");
        return;
    }

    SystemDAO dao = new SystemDAO();
    Account currentUser = (Account) sess.getAttribute("user");

    // Save email mode
    boolean modeSaved = dao.upsertSystemSetting("email_mode", emailMode.trim());

    // Save Resend settings
    boolean keySaved = true;
    boolean fromSaved = true;
    if (apiKey != null) {
        keySaved = dao.upsertSystemSetting("email_api_key", apiKey.trim());
    }
    if (fromAddress != null) {
        fromSaved = dao.upsertSystemSetting("email_from_address", fromAddress.trim());
    }

    // Save SMTP settings
    boolean smtpSaved = true;
    if ("smtp".equals(emailMode)) {
        smtpSaved = dao.upsertSystemSetting("smtp_host", smtpHost != null ? smtpHost.trim() : "") &&
                    dao.upsertSystemSetting("smtp_port", smtpPort != null ? smtpPort.trim() : "587") &&
                    dao.upsertSystemSetting("smtp_username", smtpUser != null ? smtpUser.trim() : "") &&
                    dao.upsertSystemSetting("smtp_password", smtpPass != null ? smtpPass.trim() : "") &&
                    dao.upsertSystemSetting("smtp_from", smtpFrom != null ? smtpFrom.trim() : "") &&
                    dao.upsertSystemSetting("smtp_ssl", smtpSSL != null ? smtpSSL.trim() : "false");
    }

    if (modeSaved && keySaved && fromSaved && smtpSaved) {
        dao.logActivity(currentUser.getId(), "Updated Email Settings", 
            "Email mode set to " + emailMode + " with configuration updated", "config", "high");
        response.sendRedirect("email_settings.jsp?success=saved");
    } else {
        response.sendRedirect("email_settings.jsp?error=save_failed");
    }
%>
