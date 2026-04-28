<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.sql.*" %>
<%
    // 1. Security Check
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    Account currentUser = (Account) sess.getAttribute("user");
    String memberIdStr = request.getParameter("id");
    String action = request.getParameter("action"); // "deactivate" or "activate"

    if (memberIdStr == null || action == null) {
        response.sendRedirect("companyadmin_settings.jsp?error=invalid_action");
        return;
    }

    String memberId = memberIdStr;
    SystemDAO systemDAO = new SystemDAO();
    AccountDAO accountDAO = new AccountDAO();

    // 2. Validate Company Isolation
    // Ensure the target memberId belongs to the same company as currentUser
    String adminCompanyId = systemDAO.getCompanyIdByUserId(currentUser.getId());
    String memberCompanyId = systemDAO.getCompanyIdByUserId(memberId);

    if (adminCompanyId == null || !adminCompanyId.equals(memberCompanyId)) {
        response.sendRedirect("companyadmin_settings.jsp?error=unauthorized_access");
        return;
    }

    // 3. Process Action
    String newStatus = "active";
    if ("deactivate".equals(action)) {
        newStatus = "deactivated";
    }

    boolean success = accountDAO.updateAccountStatus(memberId, newStatus);
    
    if (success) {
        response.sendRedirect("companyadmin_settings.jsp?success=status_updated");
    } else {
        response.sendRedirect("companyadmin_settings.jsp?error=update_failed");
    }
%>
