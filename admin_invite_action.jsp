<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.EmailService" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.UUID" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String action = request.getParameter("action");
    String idStr = request.getParameter("id");

    if (action == null || idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("Companyadmin.jsp?error=invalid_action");
        return;
    }

    int id;
    try {
        id = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("Companyadmin.jsp?error=invalid_id");
        return;
    }

    Account currentUser = (Account) sess.getAttribute("user");
    SystemDAO systemDAO = new SystemDAO();
    String companyId = systemDAO.getCompanyIdByUserId(currentUser.getId());

    AdminInvitation invite = systemDAO.getInvitationById(id);
    if (invite == null || !companyId.equals(invite.getCompanyId())) {
        response.sendRedirect("Companyadmin.jsp?error=not_found");
        return;
    }

    if ("delete".equals(action)) {
        boolean success = systemDAO.deleteInvitation(id);
        if (success) {
            response.sendRedirect("Companyadmin.jsp?success=deleted");
        } else {
            response.sendRedirect("Companyadmin.jsp?error=delete_failed");
        }
    } else if ("resend".equals(action)) {
        // Generate a new secure random token for the link
        String token = UUID.randomUUID().toString();
        invite.setInviteToken(token);
        
        // Reset expiration to 7 days from now
        long sevenDaysInMillis = 7L * 24 * 60 * 60 * 1000;
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + sevenDaysInMillis);
        invite.setExpiresAt(expiresAt);
        
        invite.setUsed(false);

        boolean success = systemDAO.updateInvitation(invite);

        if (success) {
            // Send invitation email with new registration link (auto-detect SMTP vs Resend)
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
            String emailError = EmailService.sendInvitationEmailWithError(invite.getEmail(), token, invite.getInvitedRole(), baseUrl);
            // Also try SMTP if Resend fails and SMTP mode is enabled
            if (emailError != null && "smtp".equals(systemDAO.getSystemSetting("email_mode"))) {
                emailError = EmailService.sendInvitationEmailViaSMTP(invite.getEmail(), token, invite.getInvitedRole(), baseUrl);
            }
            if (emailError != null) {
                response.sendRedirect("Companyadmin.jsp?success=resent&email_error=" + java.net.URLEncoder.encode(emailError, "UTF-8"));
            } else {
                response.sendRedirect("Companyadmin.jsp?success=resent");
            }
        } else {
            response.sendRedirect("Companyadmin.jsp?error=resend_failed");
        }
    } else {
        response.sendRedirect("Companyadmin.jsp?error=unknown_action");
    }
%>
