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

    String secretKey = request.getParameter("secret_key");
    String publicKey = request.getParameter("public_key");

    if (secretKey == null || publicKey == null) {
        response.sendRedirect("paystack_settings.jsp?error=invalid_input");
        return;
    }

    SystemDAO dao = new SystemDAO();
    Account currentUser = (Account) sess.getAttribute("user");

    boolean secretSaved = dao.upsertSystemSetting("paystack_secret_key", secretKey.trim());
    boolean publicSaved = dao.upsertSystemSetting("paystack_public_key", publicKey.trim());

    if (secretSaved && publicSaved) {
        dao.logActivity(currentUser.getId(), "Updated Paystack Settings", "API keys updated", "config", "high");
        response.sendRedirect("paystack_settings.jsp?success=saved");
    } else {
        response.sendRedirect("paystack_settings.jsp?error=save_failed");
    }
%>
