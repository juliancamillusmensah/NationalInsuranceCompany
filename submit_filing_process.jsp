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
    
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    int year = Integer.parseInt(request.getParameter("year"));
    
    FinancialDAO financialDAO = new FinancialDAO();
    
    // Process Non-Life
    MarketFinancials nl = new MarketFinancials(companyId, "NONLIFE", year);
    nl.setCommissionIncome(new BigDecimal(request.getParameter("nonlife_commission")));
    nl.setAdminExp(new BigDecimal(request.getParameter("nonlife_admin")));
    nl.setOperationalResults(new BigDecimal(request.getParameter("nonlife_operational")));
    nl.setInvestmentIncome(new BigDecimal(request.getParameter("nonlife_investment")));
    nl.setProfitLossAfterTax(new BigDecimal(request.getParameter("nonlife_profit")));
    financialDAO.updateFinancials(nl);
    
    // Process Life
    MarketFinancials l = new MarketFinancials(companyId, "LIFE", year);
    l.setCommissionIncome(new BigDecimal(request.getParameter("life_commission")));
    l.setAdminExp(new BigDecimal(request.getParameter("life_admin")));
    l.setOperationalResults(new BigDecimal(request.getParameter("life_operational")));
    l.setInvestmentIncome(new BigDecimal(request.getParameter("life_investment")));
    l.setProfitLossAfterTax(new BigDecimal(request.getParameter("life_profit")));
    financialDAO.updateFinancials(l);
    
    // Process Broker
    MarketFinancials b = new MarketFinancials(companyId, "BROKER", year);
    b.setCommissionIncome(new BigDecimal(request.getParameter("broker_commission")));
    b.setAdminExp(new BigDecimal(request.getParameter("broker_admin")));
    b.setOperationalResults(new BigDecimal(request.getParameter("broker_operational")));
    b.setInvestmentIncome(new BigDecimal(request.getParameter("broker_investment")));
    b.setProfitLossAfterTax(new BigDecimal(request.getParameter("broker_profit")));
    financialDAO.updateFinancials(b);
    
    response.sendRedirect("companyadmin_filing.jsp?success=true");
%>
