<%@ page contentType="text/csv;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %><%@ page import="com.insurance.dao.*" %><%@ page import="com.insurance.model.*" %><%@ page import="java.util.List" %><%
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || (!"ROLE_ADMIN".equals(roleId) && !"ROLE_SUPPORT".equals(roleId) && !"ROLE_SUPERADMIN".equals(roleId))) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }
    
    response.setHeader("Content-Disposition", "attachment; filename=\"nic_regulatory_claims_report.csv\"");
    
    ClaimDAO claimDAO = new ClaimDAO();
    String companyId = (String) sess.getAttribute("companyId");
    
    List<Claim> allClaims = (companyId != null) ? claimDAO.getClaimsByCompanyId(companyId) : claimDAO.getAllClaims();
    String filter = request.getParameter("filter");

    out.println("Claim ID,Policy Name,Policyholder,Email,Incident Date,Status,Acknowledged At,Settled At,Reported At");

    if (allClaims != null) {
        for (Claim c : allClaims) {
            if (filter != null && !filter.trim().isEmpty() && !"all".equalsIgnoreCase(filter) && !c.getStatus().equalsIgnoreCase(filter)) {
                continue;
            }
            
            String id = c.getId() != null ? c.getId() : "";
            String policyName = c.getPolicyName() != null ? "\"" + c.getPolicyName().replace("\"", "\"\"") + "\"" : "";
            String userName = c.getUserName() != null ? "\"" + c.getUserName().replace("\"", "\"\"") + "\"" : "";
            String email = c.getUserEmail() != null ? c.getUserEmail() : "";
            String date = c.getIncidentDate() != null ? c.getIncidentDate() : "";
            String status = c.getStatus() != null ? c.getStatus() : "";
            String ackAt = c.getAcknowledgedAt() != null ? c.getAcknowledgedAt().toString() : "";
            String settledAt = c.getSettledAt() != null ? c.getSettledAt().toString() : "";
            String createdAt = c.getCreatedAt() != null ? c.getCreatedAt().toString() : "";
            
            out.println(String.join(",", id, policyName, userName, email, date, status, ackAt, settledAt, createdAt));
        }
    }
%>
