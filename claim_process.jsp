<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String userId = (String) sess.getAttribute(\"userId\");
    try {
        String policyId = request.getParameter("policyId");
        BigDecimal claimAmount = new BigDecimal(request.getParameter("claimAmount"));
        String description = request.getParameter("description");
        String incidentDate = request.getParameter("incidentDate");

        Claim claim = new Claim();
        claim.setUserId(userId);
        claim.setPolicyId(policyId);
        claim.setClaimAmount(claimAmount);
        claim.setDescription(description);
        claim.setIncidentDate(incidentDate);

        ClaimDAO claimDAO = new ClaimDAO();
        boolean success = claimDAO.addClaim(claim);

        if (success) {
            // Trigger Notification
            NotificationDAO noteDAO = new NotificationDAO();
            Notification note = new Notification();
            note.setUserId(userId);
            note.setTitle("Claim Submitted");
            note.setMessage("Your claim for policy ID #" + policyId + " has been received and is under review.");
            note.setType("info");
            noteDAO.addNotification(note);
            
            response.sendRedirect("Customerportal.jsp?success=claim");
        } else {
            response.sendRedirect("customer_new_claim.jsp?error=db");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("customer_new_claim.jsp?error=invalid");
    }
%>
