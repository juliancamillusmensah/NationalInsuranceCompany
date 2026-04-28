<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Random" %>
<%
    CompanyDAO companyDAO = new CompanyDAO();
    FinancialDAO financialDAO = new FinancialDAO();
    List<Company> companies = companyDAO.getAllCompanies();
    int year = Calendar.getInstance().get(Calendar.YEAR);
    Random rand = new Random();
    
    out.println("<h2>Populating Sample Financial Data for " + year + "</h2>");
    out.println("<ul>");
    
    for (Company c : companies) {
        // Generate for LIFE sector
        MarketFinancials life = new MarketFinancials(c.getId(), "LIFE", year);
        life.setCommissionIncome(new BigDecimal(5000 + rand.nextInt(15000)));
        life.setAdminExp(new BigDecimal(2000 + rand.nextInt(8000)));
        life.setOperationalResults(new BigDecimal(50000 + rand.nextInt(200000)));
        life.setInvestmentIncome(new BigDecimal(1000 + rand.nextInt(5000)));
        life.setProfitLossAfterTax(new BigDecimal(10000 + rand.nextInt(50000)));
        financialDAO.updateFinancials(life);
        out.println("<li>Populated LIFE for " + c.getName() + "</li>");
        
        // Generate for NONLIFE sector
        MarketFinancials nonlife = new MarketFinancials(c.getId(), "NONLIFE", year);
        nonlife.setCommissionIncome(new BigDecimal(8000 + rand.nextInt(20000)));
        nonlife.setAdminExp(new BigDecimal(3000 + rand.nextInt(12000)));
        nonlife.setOperationalResults(new BigDecimal(70000 + rand.nextInt(300000)));
        nonlife.setInvestmentIncome(new BigDecimal(2000 + rand.nextInt(10000)));
        nonlife.setProfitLossAfterTax(new BigDecimal(15000 + rand.nextInt(75000)));
        financialDAO.updateFinancials(nonlife);
        out.println("<li>Populated NONLIFE for " + c.getName() + "</li>");

        // Generate for BROKER sector if applicable or sample
        MarketFinancials broker = new MarketFinancials(c.getId(), "BROKER", year);
        broker.setCommissionIncome(new BigDecimal(3000 + rand.nextInt(10000)));
        broker.setAdminExp(new BigDecimal(1000 + rand.nextInt(5000)));
        broker.setOperationalResults(new BigDecimal(20000 + rand.nextInt(100000)));
        broker.setInvestmentIncome(new BigDecimal(500 + rand.nextInt(2000)));
        broker.setProfitLossAfterTax(new BigDecimal(5000 + rand.nextInt(25000)));
        financialDAO.updateFinancials(broker);
        out.println("<li>Populated BROKER for " + c.getName() + "</li>");
    }
    
    out.println("</ul>");
    out.println("<p><strong>Done!</strong></p>");
%>
