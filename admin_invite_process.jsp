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

    String email = request.getParameter("email");
    String role = request.getParameter("role");

    if (email == null || email.trim().isEmpty() || role == null || role.trim().isEmpty()) {
        response.sendRedirect("companyadmin_settings.jsp?error=invalid_input");
        return;
    }

    Account currentUser = (Account) sess.getAttribute("user");
    SystemDAO systemDAO = new SystemDAO();
    String companyId = systemDAO.getCompanyIdByUserId(currentUser.getId());

    AdminInvitation invite = new AdminInvitation();
    invite.setEmail(email.trim());
    invite.setCompanyId(companyId);
    invite.setInvitedRole(role.trim());
    
    // Generate a secure random token for the link
    String token = UUID.randomUUID().toString();
    invite.setInviteToken(token);
    
    // Set expiration to 7 days from now
    long sevenDaysInMillis = 7L * 24 * 60 * 60 * 1000;
    Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + sevenDaysInMillis);
    invite.setExpiresAt(expiresAt);
    
    invite.setUsed(false);

    boolean success = systemDAO.createInvitation(invite);

    if (success) {
        // Send invitation email with registration link (auto-detect SMTP vs Resend)
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
        String emailError = EmailService.sendInvitationEmailWithError(email.trim(), token, role.trim(), baseUrl);
        // Also try SMTP if Resend fails and SMTP mode is enabled
        if (emailError != null && "smtp".equals(systemDAO.getSystemSetting("email_mode"))) {
            emailError = EmailService.sendInvitationEmailViaSMTP(email.trim(), token, role.trim(), baseUrl);
        }
        if (emailError != null) {
            response.sendRedirect("companyadmin_settings.jsp?success=invited&email_error=" + java.net.URLEncoder.encode(emailError, "UTF-8"));
        } else {
            response.sendRedirect("companyadmin_settings.jsp?success=invited");
        }
    } else {
        response.sendRedirect("companyadmin_settings.jsp?error=db_error");
    }
%>
