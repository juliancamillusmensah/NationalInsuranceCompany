<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<% 
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SYSTEM_CREATOR".equals(sess.getAttribute("roleId"))) {
        response.setStatus(403);
        out.print("{\"success\":false, \"message\":\"Unauthorized\"}");
        return;
    }

    String key = request.getParameter("key");
    String value = request.getParameter("value");
    Account currentUser = (Account) sess.getAttribute("user");

    if (key != null && value != null) {
        SystemDAO dao = new SystemDAO();
        boolean success = dao.updateSystemSetting(key, value);
        if (success) {
            dao.logActivity(currentUser.getId(), "Updated Configuration", "Key: " + key + " | New Value: " + value, "config", "medium");
            out.print("{\"success\":true}");
        } else {
            out.print("{\"success\":false, \"message\":\"Database update failed\"}");
        }
    } else {
        out.print("{\"success\":false, \"message\":\"Invalid parameters\"}");
    }
%>
