<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. Security Check
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access.");
        return;
    }

    // 2. Set Response Headers for CSV Download
    String fileName = "Insurance_Network_Companies_" + new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".csv";
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

    // 3. Fetch Data
    CompanyDAO companyDAO = new CompanyDAO();
    List<Company> companies = companyDAO.getAllCompanies();

    // 4. Generate CSV Content
    out.println("Company ID,Name,Email,Phone,Status,Address");
    
    if (companies != null) {
        for (Company c : companies) {
            StringBuilder row = new StringBuilder();
            row.append(c.getId()).append(",");
            row.append("\"").append(c.getName() != null ? c.getName().replace("\"", "\"\"") : "N/A").append("\",");
            row.append("\"").append(c.getEmail() != null ? c.getEmail().replace("\"", "\"\"") : "N/A").append("\",");
            row.append("\"").append(c.getPhoneNumber() != null ? c.getPhoneNumber().replace("\"", "\"\"") : "N/A").append("\",");
            row.append(c.getStatus()).append(",");
            row.append("\"").append(c.getAddress() != null ? c.getAddress().replace("\"", "\"\"") : "N/A").append("\"");
            out.println(row.toString());
        }
    }
    out.flush();
%>
