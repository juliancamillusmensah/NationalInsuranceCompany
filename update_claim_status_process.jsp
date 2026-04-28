<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String claimIdStr = request.getParameter("claimId");
    String status = request.getParameter("status");

    if (claimIdStr != null && status != null) {
        try {
            String claimId = claimIdStr;
            ClaimDAO claimDAO = new ClaimDAO();
            boolean success = claimDAO.updateClaimStatus(claimId, status);
            
            if (success) {
                // Add a notification for the user who filed the claim
                // We could fetch the claim to get the userId, but for now we just redirect
                response.sendRedirect("companyadmin_claims.jsp?success=true");
            } else {
                response.sendRedirect("companyadmin_claims.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("companyadmin_claims.jsp?error=exception");
        }
    } else {
        response.sendRedirect("companyadmin_claims.jsp");
    }
%>
