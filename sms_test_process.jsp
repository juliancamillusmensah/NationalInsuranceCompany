<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.SMSService" %>
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

    String testPhone = request.getParameter("test_phone");
    if (testPhone == null || testPhone.trim().isEmpty()) {
        response.sendRedirect("sms_settings.jsp?error=invalid_phone");
        return;
    }

    boolean sent = SMSService.sendSMS(testPhone.trim(), "This is a test SMS from NIC Ghana Portal. Your SMS integration is working!");

    SystemDAO dao = new SystemDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    dao.logActivity(currentUser.getId(), "Tested SMS Integration", "Sent test SMS to " + testPhone.trim(), "config", "low");

    if (sent) {
        response.sendRedirect("sms_settings.jsp?success=test_success");
    } else {
        response.sendRedirect("sms_settings.jsp?error=test_failed");
    }
%>
