<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.PaystackService" %>
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

    String testEmail = request.getParameter("test_email");
    if (testEmail == null || testEmail.trim().isEmpty()) {
        response.sendRedirect("paystack_settings.jsp?error=invalid_email");
        return;
    }

    SystemDAO dao = new SystemDAO();
    String secretKey = dao.getSystemSetting("paystack_secret_key");
    
    if (secretKey == null || secretKey.isEmpty() || secretKey.startsWith("sk_test_XXX")) {
        response.sendRedirect("paystack_settings.jsp?error=no_key");
        return;
    }

    // Initialize a test transaction (GHS 1.00)
    String reference = "NIC-TEST-" + java.util.UUID.randomUUID().toString().substring(0, 12).toUpperCase();
    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
    String callbackUrl = baseUrl + "/paystack_settings.jsp?success=test_success";

    String authUrl = PaystackService.initializeTransaction(testEmail.trim(), 1.00, reference, callbackUrl);

    if (authUrl != null) {
        Account currentUser = (Account) sess.getAttribute("user");
        dao.logActivity(currentUser.getId(), "Tested Paystack Connection", "Initialized test transaction ref: " + reference, "config", "low");
        response.sendRedirect(authUrl); // Redirect to Paystack test payment page
    } else {
        response.sendRedirect("paystack_settings.jsp?error=test_failed");
    }
%>
