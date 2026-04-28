<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    Account currentUser = (Account) sess.getAttribute("user");
    SystemDAO systemDAO = new SystemDAO();
    String companyId = systemDAO.getCompanyIdByUserId(currentUser.getId());

    boolean dailyDigest = "on".equals(request.getParameter("dailyDigest"));
    boolean financialAlerts = "on".equals(request.getParameter("financialAlerts"));
    boolean smsNotifications = "on".equals(request.getParameter("smsNotifications"));
    boolean hideFromSuperadmin = "on".equals(request.getParameter("hideFromSuperadmin"));

    CompanySettings settings = new CompanySettings();
    settings.setCompanyId(companyId);
    settings.setDailyDigest(dailyDigest);
    settings.setFinancialAlerts(financialAlerts);
    settings.setSmsNotifications(smsNotifications);
    settings.setHideFromSuperadmin(hideFromSuperadmin);

    boolean success = systemDAO.updateCompanySettings(settings);

    if (success) {
        response.sendRedirect("companyadmin_settings.jsp?success=settings_updated");
    } else {
        response.sendRedirect("companyadmin_settings.jsp?error=db_error");
    }
%>
