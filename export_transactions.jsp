<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. Security Check
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null && sess.getAttribute("roleId") != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || (!"ROLE_ADMIN".equals(roleId) && !"ROLE_AUDITOR".equals(roleId) && !"ROLE_SUPERADMIN".equals(roleId))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access to financial reports.");
        return;
    }

    // 2. Set Response Headers for CSV Download
    String fileName = "Transactions_Report_" + new SimpleDateFormat("yyyyMMdd_HHmm").format(new java.util.Date()) + ".csv";
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

    // 3. Fetch Data
    TransactionDAO transactionDAO = new TransactionDAO();
    List<Transaction> allTransactions = transactionDAO.getAllTransactions();

    // 4. Generate CSV Content
    out.println("Transaction ID,Subscriber,Email,Policy,Type,Amount,Status,Date");
    
    if (allTransactions != null) {
        for (Transaction t : allTransactions) {
            StringBuilder row = new StringBuilder();
            row.append(t.getId()).append(",");
            row.append("\"").append(t.getUserName() != null ? t.getUserName().replace("\"", "\"\"") : "Unknown").append("\",");
            row.append("\"").append(t.getUserEmail() != null ? t.getUserEmail().replace("\"", "\"\"") : "N/A").append("\",");
            row.append("\"").append(t.getPolicyName() != null ? t.getPolicyName().replace("\"", "\"\"") : "Unknown").append("\",");
            row.append(t.getTransactionType()).append(",");
            row.append(t.getAmount()).append(",");
            row.append(t.getPaymentStatus()).append(",");
            row.append(t.getTransactionDate());
            out.println(row.toString());
        }
    }
    out.flush();
%>
