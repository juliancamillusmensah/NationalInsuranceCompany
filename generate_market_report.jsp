<%@ page contentType="text/csv;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Ensure the user is authenticated
    if (session == null || session.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(session.getAttribute("roleId"))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access to market data reports.");
        return;
    }

    String type = request.getParameter("type");
    String prettyTitle = "Brokers_Market_Data";
    
    if ("life".equalsIgnoreCase(type)) {
        prettyTitle = "Life_Sector_Market_Data";
    } else if ("nonlife".equalsIgnoreCase(type)) {
        prettyTitle = "Non_Life_Sector_Market_Data";
    }

    // Format output filename
    String stamp = new SimpleDateFormat("yyyyMMdd_HHmm").format(new java.util.Date());
    String filename = "NIC_" + prettyTitle + "_" + stamp + ".csv";
    
    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

    // Fetch Database Entities
    PolicyDAO policyDAO = new PolicyDAO();
    FinancialDAO financialDAO = new FinancialDAO();
    CompanyDAO companyDAO = new CompanyDAO();
    List<Policy> allPolicies = policyDAO.getAllPolicies();
    List<Company> allCompanies = companyDAO.getAllCompanies();
    
    java.util.Map<String, String> companyTypeMap = new java.util.HashMap<>();
    if (allCompanies != null) {
        for (Company c : allCompanies) {
            companyTypeMap.put(c.getId(), c.getCompanyType());
        }
    }
    
    int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
    List<MarketFinancials> financials = financialDAO.getFinancialsByYear(currentYear);
    java.util.Map<String, MarketFinancials> finMap = new java.util.HashMap<>();
    if (financials != null) {
        for (MarketFinancials f : financials) {
            finMap.put(f.getCompanyId() + "_" + f.getSector(), f);
        }
    }

    // CSV Headers
    out.println("Regulated Insurance Entity,Registration Type,Sector,Commission Income,General & Admin Exp,Operational Results,Total Investments,Profit After Tax");

    if (allCompanies != null) {
        for (Company c : allCompanies) {
            String compType = c.getCompanyType() != null ? c.getCompanyType() : "General Insurance";
            String safeCompType = compType.toLowerCase();
            
            // Sector identification
            boolean isLife = safeCompType.contains("life") && !safeCompType.contains("non");
            boolean isNonLife = safeCompType.contains("non-life") || safeCompType.contains("general") || safeCompType.contains("life & non-life");
            if (safeCompType.contains("life & non-life")) isLife = true;
            boolean isBroker = safeCompType.contains("broker");

            String targetSectorKey = "";
            if ("brokers".equalsIgnoreCase(type) && isBroker) targetSectorKey = "BROKER";
            else if ("life".equalsIgnoreCase(type) && isLife) targetSectorKey = "LIFE";
            else if ("nonlife".equalsIgnoreCase(type) && isNonLife) targetSectorKey = "NONLIFE";

            if (!targetSectorKey.isEmpty()) {
                StringBuilder row = new StringBuilder();
                row.append("\"").append(c.getName() != null ? c.getName().replace("\"", "\"\"") : "Unknown").append("\",");
                row.append("\"").append(compType.replace("\"", "\"\"")).append("\",");
                row.append("\"").append(targetSectorKey).append("\",");
                
                MarketFinancials mf = finMap.get(c.getId() + "_" + targetSectorKey);
                if (mf != null) {
                    row.append(mf.getCommissionIncome()).append(",");
                    row.append(mf.getAdminExp()).append(",");
                    row.append(mf.getOperationalResults()).append(",");
                    row.append(mf.getInvestmentIncome()).append(",");
                    row.append(mf.getProfitLossAfterTax());
                } else {
                    row.append("Awaiting Upload,Awaiting Upload,-,-,N/A");
                }
                out.println(row.toString());
            }
        }
    }
    out.flush();
%>
