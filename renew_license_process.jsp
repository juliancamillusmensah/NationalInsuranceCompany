<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.PaystackService" %>
<% 
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null) ? (String)sess.getAttribute("roleId") : null;
    Account currentUser = (sess != null) ? (Account)sess.getAttribute("user") : null;

    if (sess == null || currentUser == null || (!"ROLE_SUPERADMIN".equals(roleId) && !"ROLE_ADMIN".equals(roleId))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("auth_redirect.jsp");
        return;
    }

    String companyId = request.getParameter("companyId");
    String licenseExpiry = request.getParameter("licenseExpiry");
    
    // Security check: Company Admin can only renew their own company
    if ("ROLE_ADMIN".equals(roleId)) {
        String sessionCompanyId = (String) sess.getAttribute("companyId");
        if (companyId == null || !companyId.equals(sessionCompanyId)) {
            response.sendRedirect("Companyadmin.jsp?error=unauthorized");
            return;
        }
    }
    
    if (companyId == null || companyId.isEmpty() || licenseExpiry == null || licenseExpiry.isEmpty()) {
        String redirectPage = "ROLE_SUPERADMIN".equals(roleId) ? "superadmin_companies.jsp" : "Companyadmin.jsp";
        response.sendRedirect(redirectPage + "?error=invalid_input");
        return;
    }

    CompanyDAO companyDAO = new CompanyDAO();
    Company c = companyDAO.getCompanyById(companyId);
    java.math.BigDecimal feeAmount = new java.math.BigDecimal("5000"); // Default for Insurance Companies
    if (c != null && c.getCompanyType() != null && c.getCompanyType().toUpperCase().contains("BROKER")) {
        feeAmount = new java.math.BigDecimal("1000"); // Lower fee for Brokers
    }

    // Check if Paystack is configured
    SystemDAO systemDAO = new SystemDAO();
    String paystackKey = systemDAO.getSystemSetting("paystack_secret_key");
    boolean usePaystack = paystackKey != null && !paystackKey.isEmpty() && !paystackKey.startsWith("pk_test_XXX") && !paystackKey.startsWith("sk_test_XXX");

    if (usePaystack) {
        // Paystack flow: store data in session, initialize transaction, redirect
        sess.setAttribute("paystack_company_id", companyId);
        sess.setAttribute("paystack_license_expiry", licenseExpiry);
        sess.setAttribute("paystack_fee_amount", feeAmount);

        String reference = "NIC-LIC-" + java.util.UUID.randomUUID().toString().substring(0, 12).toUpperCase();
        String callbackUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                + request.getContextPath() + "/paystack/callback?trx_type=license_renewal";

        String authUrl = PaystackService.initializeTransaction(currentUser.getEmail(), feeAmount.doubleValue(), reference, callbackUrl);

        if (authUrl != null) {
            response.sendRedirect(authUrl);
            return;
        } else {
            System.err.println("WARNING: Paystack initialization failed for license renewal. Falling back to direct processing.");
        }
    }

    // Direct processing fallback (or if Paystack not configured)
    PolicyDAO policyDAO = new PolicyDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    
    // Ensure system policy for license fees exists
    String checkSql = "SELECT id FROM policies WHERE id = 'NIC-LICENSE-FEE'";
    try (java.sql.Connection conn = com.insurance.util.DBConnection.getConnection();
         java.sql.PreparedStatement pstmt = conn.prepareStatement(checkSql);
         java.sql.ResultSet rs = pstmt.executeQuery()) {
        if (!rs.next()) {
            String insertSql = "INSERT INTO policies (id, policy_name, description, premium_amount, coverage_duration, policy_type, insurance_company_id, status, created_at, updated_at) " +
                             "VALUES ('NIC-LICENSE-FEE', 'NIC License Renewal Fee', 'System Regulatory Policy', 0, 'N/A', 'REGULATORY', 'NIC-SYSTEM', 'active', datetime('now'), datetime('now'))";
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(insertSql);
            }
        }
    } catch (java.sql.SQLException e) {
        System.err.println("Failed to ensure system policy: " + e.getMessage());
    }
    
    // Fetch bank details for logging
    String sourceBank = "Unknown Bank";
    String destBank = "NIC Central Account";
    try (java.sql.Connection conn = com.insurance.util.DBConnection.getConnection();
         java.sql.PreparedStatement pstmtSource = conn.prepareStatement("SELECT bank_name, account_number FROM insurance_companies WHERE id = ?");
         java.sql.PreparedStatement pstmtDest = conn.prepareStatement("SELECT setting_value FROM system_settings WHERE setting_key = 'nic_settlement_number'")) {
        
        pstmtSource.setString(1, companyId);
        try (java.sql.ResultSet rs = pstmtSource.executeQuery()) {
            if (rs.next()) {
                String bName = rs.getString("bank_name");
                String aNum = rs.getString("account_number");
                if (bName != null && !bName.isEmpty()) sourceBank = bName + " (" + aNum + ")";
            }
        }
        
        try (java.sql.ResultSet rs = pstmtDest.executeQuery()) {
            if (rs.next()) destBank = "NIC Regulatory (" + rs.getString("setting_value") + ")";
        }
    } catch (Exception e) {}
    
    String transDetails = "Regulatory Fee | Source: " + sourceBank + " | Target: " + destBank;
    transactionDAO.recordTransaction(currentUser.getId(), "NIC-LICENSE-FEE", feeAmount, transDetails, "System Debit");
    
    // Update License
    if (companyDAO.renewLicense(companyId, licenseExpiry)) {
        com.insurance.util.ComplianceManager.checkAllCompaniesCompliance(roleId); 
        
        if ("ROLE_SUPERADMIN".equals(roleId)) {
            response.sendRedirect("superadmin_companies.jsp?success=renewed");
        } else {
            response.sendRedirect("Companyadmin.jsp?success=renewed");
        }
    } else {
        if ("ROLE_SUPERADMIN".equals(roleId)) {
            response.sendRedirect("superadmin_companies.jsp?error=renewal_failed");
        } else {
            response.sendRedirect("Companyadmin.jsp?error=renewal_failed");
        }
    }
%>
