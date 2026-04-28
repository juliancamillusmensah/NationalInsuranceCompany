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

    String apiKey = request.getParameter("sms_api_key");
    if (apiKey == null) {
        response.sendRedirect("sms_settings.jsp?error=invalid_input");
        return;
    }

    SystemDAO dao = new SystemDAO();
    Account currentUser = (Account) sess.getAttribute("user");

    boolean saved = dao.upsertSystemSetting("sms_api_key", apiKey.trim());

    if (saved) {
        dao.logActivity(currentUser.getId(), "Updated SMS Settings", "SMS API key updated", "config", "medium");
        response.sendRedirect("sms_settings.jsp?success=saved");
    } else {
        response.sendRedirect("sms_settings.jsp?error=save_failed");
    }
%>
