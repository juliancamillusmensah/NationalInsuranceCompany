<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String name = request.getParameter("policyName");
    String description = request.getParameter("description");
    String premiumStr = request.getParameter("premium");
    String duration = request.getParameter("duration");
    String type = request.getParameter("policyType");
    String imageUrl = request.getParameter("imageUrl");

    if (name != null && description != null && premiumStr != null) {
        try {
            Policy p = new Policy();
            p.setPolicyName(name);
            p.setDescription(description);
            p.setPremiumAmount(new BigDecimal(premiumStr));
            p.setCoverageDuration(duration != null ? duration : "12 Months");
            p.setPolicyType(type != null ? type : "General");
            p.setImageUrl(imageUrl);
            
            // Get Company ID for the current admin
            SystemDAO systemDAO = new SystemDAO();
            Account currentUser = (Account) sess.getAttribute("user");
            String companyId = systemDAO.getCompanyIdByUserId(currentUser.getId());
            p.setInsuranceCompanyId(companyId);
            
            PolicyDAO policyDAO = new PolicyDAO();
            boolean success = policyDAO.addPolicy(p);
            
            if (success) {
                // Log activity
                // Reuse previously declared systemDAO if needed, or just redirect
                response.sendRedirect("companyadmin_policies.jsp?status=added");
            } else {
                response.sendRedirect("companyadmin_policies.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("companyadmin_policies.jsp?error=invalid_data");
        }
    } else {
        response.sendRedirect("companyadmin_policies.jsp");
    }
%>
