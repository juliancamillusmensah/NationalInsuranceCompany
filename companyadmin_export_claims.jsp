<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }

    String companyId = (String) sess.getAttribute("companyId");
    ClaimDAO claimDAO = new ClaimDAO();
    List<Claim> claims = claimDAO.getClaimsByCompanyId(companyId);

    String filename = "NIC_Claims_Report_" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".csv";
    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

    // CSV Header
    out.println("Claim ID,Policy,Customer,Email,Amount,Incident Date,Status,Reported At,Acknowledged At,Docs Submitted,DV Issued,Settled At,Adjuster,Rejection Reason");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    for (Claim c : claims) {
        StringBuilder sb = new StringBuilder();
        sb.append(c.getId()).append(",");
        sb.append("\"").append(c.getPolicyName()).append("\",");
        sb.append("\"").append(c.getUserName()).append("\",");
        sb.append(c.getUserEmail()).append(",");
        sb.append(c.getClaimAmount()).append(",");
        sb.append(c.getIncidentDate()).append(",");
        sb.append(c.getStatus()).append(",");
        sb.append(c.getCreatedAt() != null ? sdf.format(c.getCreatedAt()) : "").append(",");
        sb.append(c.getAcknowledgedAt() != null ? sdf.format(c.getAcknowledgedAt()) : "").append(",");
        sb.append(c.getDocsSubmittedAt() != null ? sdf.format(c.getDocsSubmittedAt()) : "").append(",");
        sb.append(c.getDischargeVoucherAt() != null ? sdf.format(c.getDischargeVoucherAt()) : "").append(",");
        sb.append(c.getSettledAt() != null ? sdf.format(c.getSettledAt()) : "").append(",");
        sb.append("\"").append(c.getAssignedAdjuster() != null ? c.getAssignedAdjuster() : "").append("\",");
        sb.append("\"").append(c.getRejectionReason() != null ? c.getRejectionReason() : "").append("\"");
        out.println(sb.toString());
    }
%>
