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

    String roleId = request.getParameter("roleId");
    String permissionId = request.getParameter("permissionId");
    boolean enabled = "true".equals(request.getParameter("enabled"));

    if (roleId != null && permissionId != null) {
        SystemDAO dao = new SystemDAO();
        boolean success = dao.updateRolePermission(roleId, permissionId, enabled);
        if (success) {
            Account user = (Account) sess.getAttribute("user");
            dao.logActivity(user.getId(), "Updated Role Permission", 
                "Changed permission " + permissionId + " for role " + roleId + " to " + (enabled ? "enabled" : "disabled"), 
                "system", "medium");
            out.print("{\"success\":true}");
        } else {
            out.print("{\"success\":false, \"message\":\"Database update failed\"}");
        }
    } else {
        out.print("{\"success\":false, \"message\":\"Missing parameters\"}");
    }
%>
