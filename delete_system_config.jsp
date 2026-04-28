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
    Account currentUser = (Account) sess.getAttribute("user");

    if (key != null && !key.trim().isEmpty()) {
        SystemDAO dao = new SystemDAO();
        boolean success = dao.deleteSystemSetting(key);
        if (success) {
            dao.logActivity(currentUser.getId(), "Deleted Configuration", "Key: " + key, "config", "high");
            out.print("{\"success\":true}");
        } else {
            out.print("{\"success\":false, \"message\":\"Database deletion failed\"}");
        }
    } else {
        out.print("{\"success\":false, \"message\":\"Invalid parameters\"}");
    }
%>
