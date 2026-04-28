<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    Account currentUser = (Account) sess.getAttribute("user");
    NotificationDAO notificationDAO = new NotificationDAO();
    CompanyDAO companyDAO = new CompanyDAO();
    FinancialDAO financialDAO = new FinancialDAO();
    PolicyDAO policyDAO = new PolicyDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    
    List<Company> allCompanies = companyDAO.getAllCompanies();
    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
    List<MarketFinancials> financials = financialDAO.getFinancialsByYear(currentYear);
    
    java.util.Map<String, MarketFinancials> finMap = new java.util.HashMap<>();
    if (financials != null) {
        for (MarketFinancials f : financials) {
            finMap.put(f.getCompanyId() + "_" + f.getSector(), f);
        }
    }
    
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
    
    java.util.Map<String, String> companyTypeMap = new java.util.HashMap<>();
    int totalCompanies = (allCompanies != null) ? allCompanies.size() : 0;
    int compliantCount = 0;
    
    if (allCompanies != null) {
        for (Company c : allCompanies) {
            companyTypeMap.put(c.getId(), c.getCompanyType());
            if ("Compliant".equalsIgnoreCase(c.getComplianceStatus())) {
                compliantCount++;
            }
        }
    }
    
    // Market Financial Metrics
    BigDecimal totalMarketProfit = BigDecimal.ZERO;
    java.util.Set<String> filedCompanyIds = new java.util.HashSet<>();
    List<MarketFinancials> recentFilings = new java.util.ArrayList<>();
    
    if (financials != null) {
        // Sort financials by updated_at for recent filings view
        financials.sort((f1, f2) -> {
            if (f1.getUpdatedAt() == null || f2.getUpdatedAt() == null) return 0;
            return f2.getUpdatedAt().compareTo(f1.getUpdatedAt());
        });
        
        for (MarketFinancials f : financials) {
            if (f.getProfitLossAfterTax() != null) {
                totalMarketProfit = totalMarketProfit.add(f.getProfitLossAfterTax());
            }
            filedCompanyIds.add(f.getCompanyId());
            if (recentFilings.size() < 10) recentFilings.add(f);
        }
    }
    
    int filedCount = filedCompanyIds.size();
    int participationPercent = (totalCompanies > 0) ? (filedCount * 100 / totalCompanies) : 0;
    int compliancePercent = (totalCompanies > 0) ? (compliantCount * 100 / totalCompanies) : 0;
    int pendingFilings = totalCompanies - filedCount;
    
    // Regulatory Revenue (License Fees) - In-lined to avoid DAO loading issues
    BigDecimal regulatoryRevenue = BigDecimal.ZERO;
    try (java.sql.Connection conn = com.insurance.util.DBConnection.getConnection();
         java.sql.Statement stmt = conn.createStatement();
         java.sql.ResultSet rs = stmt.executeQuery("SELECT SUM(amount) FROM transactions WHERE policy_id = 'NIC-LICENSE-FEE' AND payment_status = 'successful'")) {
        if (rs.next()) {
            BigDecimal res = rs.getBigDecimal(1);
            if (res != null) regulatoryRevenue = res;
        }
    } catch (Exception e) {
        System.err.println("Error calculating regulatory revenue: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Super Admin - Reports | AdminNet</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f6f7f9" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-background-light text-slate-800 antialiased min-h-screen">
    <div class="flex flex-col lg:flex-row min-h-screen">
        <!-- Sidebar -->
        <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-slate-200 flex flex-col shrink-0 transform -translate-x-full lg:translate-x-0 lg:static transition-transform duration-300 ease-in-out">
            <div class="p-6 flex items-center justify-between lg:justify-start gap-3">
                <div class="flex items-center gap-3">
                    <div class="bg-primary p-2 rounded-xl text-white shadow-lg shadow-primary/20">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">security</span>
                    </div>
                    <span class="text-xl font-black tracking-tight text-slate-900 leading-none">NIC Ghana</span>
                </div>
            </div>

            <nav class="flex-1 px-4 mt-4 space-y-1">
                <a href="Superadmin.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">dashboard</span>
                    <span class="text-sm">Dashboard</span>
                </a>
                <a href="superadmin_companies.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl">corporate_fare</span>
                    <span class="text-sm">Regulated Entities</span>
                </a>
                <a href="superadmin_policies.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">verified_user</span>
                    <span class="text-sm">Policies</span>
                </a>
                <a href="superadmin_reports.jsp" class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">insights</span>
                    <span class="text-sm">Reports</span>
                </a>
                <a href="superadmin_publications.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">library_books</span>
                    <span class="text-sm">Publications</span>
                </a>
            </nav>

            <div class="p-6 mt-auto">
                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 w-full text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold">
                    <span class="material-symbols-outlined text-xl">logout</span>
                    <span class="text-sm">Sign Out</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-h-screen min-w-0 w-full overflow-hidden">
            <!-- Header -->
            <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shrink-0">
                <div class="flex items-center gap-4 flex-1">
                    <button id="sidebarToggle" class="lg:hidden p-2 text-slate-400">
                        <span class="material-symbols-outlined">menu</span>
                    </button>
                    <div class="relative flex-1 max-w-xl">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                        <input type="text" id="headerSearchInput" placeholder="Search resources..." class="w-full pl-10 pr-4 py-2 bg-slate-50 border-none rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
                    </div>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Notification Dropdown -->
                    <div class="relative">
                        <button id="notificationBtn" class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                            <span class="material-symbols-outlined">notifications</span>
                            <% if (unreadNotifications > 0) { %>
                                <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                            <% } %>
                        </button>
                        
                        <div id="notificationDropdown" class="hidden absolute right-0 mt-3 w-80 bg-white rounded-2xl shadow-2xl border border-slate-100 z-[110] overflow-hidden">
                            <div class="p-4 border-b border-slate-50 flex items-center justify-between">
                                <h3 class="font-bold text-slate-900">Notifications</h3>
                                <span class="text-[10px] bg-primary/10 text-primary px-2 py-0.5 rounded-full font-bold"><%= unreadNotifications %> New</span>
                            </div>
                            <div class="max-h-96 overflow-y-auto">
                                <% if (notifications != null && !notifications.isEmpty()) { 
                                    for (Notification n : notifications) { %>
                                    <div class="p-4 hover:bg-slate-50 border-b border-slate-50 cursor-pointer transition-colors">
                                        <h4 class="text-xs font-bold text-slate-900"><%= n.getTitle() %></h4>
                                        <p class="text-[10px] text-slate-500 mt-1"><%= n.getMessage() %></p>
                                        <span class="text-[9px] text-slate-400 mt-2 block"><%= n.getCreatedAt() %></span>
                                    </div>
                                <% } } else { %>
                                    <div class="p-8 text-center">
                                        <span class="material-symbols-outlined text-slate-200 text-4xl">notifications_off</span>
                                        <p class="text-xs text-slate-400 mt-2">No new notifications</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Dropdown -->
                    <div class="relative">
                        <div id="profileBtn" class="flex items-center gap-3 pl-4 border-l border-slate-200 cursor-pointer group">
                            <div class="flex flex-col text-right hidden sm:flex">
                                <span class="text-sm font-bold text-slate-900 group-hover:text-primary transition-colors leading-none"><%= currentUser.getFullName() %></span>
                                <span class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider mt-1">Super Admin</span>
                            </div>
                            <div class="h-10 w-10 rounded-full bg-slate-200 overflow-hidden shadow-sm border-2 border-transparent group-hover:border-primary transition-all">
                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= currentUser.getFullName() %>" class="h-full w-full object-cover">
                            </div>
                        </div>

                        <div id="profileDropdown" class="hidden absolute right-0 mt-3 w-56 bg-white rounded-2xl shadow-2xl border border-slate-100 z-[110] overflow-hidden">
                            <div class="p-4 border-b border-slate-50 bg-slate-50/30">
                                <p class="text-xs font-bold text-slate-900"><%= currentUser.getFullName() %></p>
                                <p class="text-[10px] text-slate-400 mt-0.5"><%= currentUser.getEmail() %></p>
                            </div>
                            <div class="p-2">
                                <a href="Superadmin.jsp" class="flex items-center gap-3 px-3 py-2 text-slate-600 hover:bg-slate-50 rounded-xl text-xs font-semibold transition-colors">
                                    <span class="material-symbols-outlined text-lg">manage_accounts</span> Account Settings
                                </a>
                                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl text-xs font-semibold transition-colors mt-1">
                                    <span class="material-symbols-outlined text-lg">logout</span> Sign Out
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <div class="flex-1 p-4 sm:p-8 space-y-8 min-w-0 w-full overflow-x-hidden">
                <!-- Summary Metrics -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Market-wide Profitability</p>
                        <h3 class="text-3xl font-black text-slate-900 mt-2">GH₵<%= totalMarketProfit %></h3>
                        <div class="mt-4 flex items-center gap-2 text-emerald-500 text-xs font-bold">
                            <span class="material-symbols-outlined text-sm">payments</span>
                            <span>Aggregate Net Profit</span>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm border-l-4 border-l-primary">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Compliance Health</p>
                        <h3 class="text-3xl font-black text-slate-900 mt-2"><%= compliancePercent %>%</h3>
                        <div class="mt-4 flex items-center gap-2 text-primary text-xs font-bold">
                            <span class="material-symbols-outlined text-sm">verified</span>
                            <span><%= compliantCount %> / <%= totalCompanies %> Entities</span>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Market Participation</p>
                        <h3 class="text-3xl font-black text-slate-900 mt-2"><%= participationPercent %>%</h3>
                        <div class="mt-4 flex items-center gap-2 text-blue-500 text-xs font-bold">
                            <span class="material-symbols-outlined text-sm">fact_check</span>
                            <span><%= filedCount %> Entities Filed</span>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm border-l-4 border-l-amber-500">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Regulatory Revenue</p>
                        <h3 class="text-3xl font-black text-slate-900 mt-2">GH₵<%= regulatoryRevenue %></h3>
                        <div class="mt-4 flex items-center gap-2 text-amber-500 text-xs font-bold">
                            <span class="material-symbols-outlined text-sm">account_balance</span>
                            <span>Total License Fees Collected</span>
                        </div>
                    </div>
                </div>
                </div>

                <!-- Market Analytics Hub -->
                <div class="mt-8 mb-8 min-w-0">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-4 gap-4">
                        <div>
                            <h2 class="text-xl font-black text-slate-900 tracking-tight">Market Analytics Hub</h2>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mt-1">Aggregated Sector Financials</p>
                        </div>
                        <button id="generateReportBtn" type="button" onclick="downloadSecureReport('generate_market_report.jsp?type=brokers', 'NIC_Brokers_Market_Data.csv')" class="shrink-0 max-w-max px-5 py-2.5 text-xs font-bold text-white bg-primary rounded-xl shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all flex items-center gap-2 cursor-pointer">
                            <span class="material-symbols-outlined text-base">settings_b_roll</span> Generate Report
                        </button>
                    </div>
                    
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mb-8 max-w-full">
                        <!-- Tabs -->
                        <div class="flex border-b border-slate-100 bg-slate-50/50 overflow-x-auto custom-scrollbar hide-scrollbar">
                            <button id="tab-brokers" onclick="switchSector('brokers')" class="sector-tab shrink-0 px-6 py-4 text-[10px] font-black uppercase tracking-widest text-primary border-b-2 border-primary whitespace-nowrap transition-colors">Insurance Brokers</button>
                            <button id="tab-life" onclick="switchSector('life')" class="sector-tab shrink-0 px-6 py-4 text-[10px] font-black uppercase tracking-widest text-slate-400 border-b-2 border-transparent hover:text-slate-600 transition-colors whitespace-nowrap">Life Sector</button>
                            <button id="tab-nonlife" onclick="switchSector('nonlife')" class="sector-tab shrink-0 px-6 py-4 text-[10px] font-black uppercase tracking-widest text-slate-400 border-b-2 border-transparent hover:text-slate-600 transition-colors whitespace-nowrap">Non-Life Sector</button>
                        </div>
                        
                        <!-- Table Data -->
                        <div class="overflow-x-auto w-full custom-scrollbar">
                            <table class="w-full text-left min-w-max">
                                <thead>
                                    <tr class="bg-indigo-50/50 text-slate-500 text-[10px] font-black uppercase tracking-widest border-b border-slate-200">
                                        <th class="px-6 py-4 whitespace-nowrap">Regulated Insurance Entity</th>
                                        <th class="px-6 py-4 text-right whitespace-nowrap">Commission Income</th>
                                        <th class="px-6 py-4 text-right whitespace-nowrap">General & Admin Exp</th>
                                        <th class="px-6 py-4 text-right whitespace-nowrap">Operational Results</th>
                                        <th class="px-6 py-4 text-right whitespace-nowrap">Total Investments Inc</th>
                                        <th class="px-6 py-4 text-right whitespace-nowrap text-primary">Profit/Loss After Tax</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    <tr class="bg-slate-50/80">
                                        <td colspan="6" class="px-6 py-2.5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Registered Entities (Live Platform Data)</td>
                                    </tr>
                                    <% 
                                    boolean hasCompanies = false;
                                    if (allCompanies != null && !allCompanies.isEmpty()) { 
                                        hasCompanies = true;
                                        for (Company c : allCompanies) { 
                                            String compType = c.getCompanyType() != null ? c.getCompanyType() : "General Insurance";
                                            String safeCompType = compType.toLowerCase();
                                            
                                            // Determine which sectors this company belongs to
                                            boolean isLife = safeCompType.contains("life") && !safeCompType.contains("non");
                                            boolean isNonLife = safeCompType.contains("non-life") || safeCompType.contains("general") || safeCompType.contains("life & non-life");
                                            if (safeCompType.contains("life & non-life")) isLife = true;
                                            boolean isBroker = safeCompType.contains("broker");
                                            
                                            String[] activeSectors = isLife && isNonLife ? new String[]{"LIFE", "NONLIFE"} : 
                                                                    (isLife ? new String[]{"LIFE"} : 
                                                                    (isNonLife ? new String[]{"NONLIFE"} : 
                                                                    (isBroker ? new String[]{"BROKER"} : new String[]{"NONLIFE"})));

                                            for (String sectorKey : activeSectors) {
                                                MarketFinancials mf = finMap.get(c.getId() + "_" + sectorKey);
                                                String displaySector = sectorKey.toLowerCase();
                                    %>
                                    <tr class="hover:bg-primary/5 transition-colors group cursor-pointer sector-row" data-sector="<%= displaySector %>">
                                        <td class="px-6 py-4">
                                            <div class="text-sm font-bold text-slate-900 group-hover:text-primary transition-colors"><%= c.getName() %></div>
                                            <div class="text-[10px] font-black uppercase tracking-widest text-slate-400 mt-1 flex items-center gap-2">
                                                <span class="px-2 py-0.5 rounded bg-slate-100 text-[9px] font-bold text-slate-500 border border-slate-200"><%= compType %></span>
                                                <span class="flex items-center gap-1">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                                                    <%= sectorKey %> Registry
                                                </span>
                                            </div>
                                        </td>
                                        <% if (mf != null) { %>
                                        <td class="px-6 py-4 text-xs font-bold text-slate-900 text-right">GH₵<%= mf.getCommissionIncome() %></td>
                                        <td class="px-6 py-4 text-xs font-bold text-slate-900 text-right">GH₵<%= mf.getAdminExp() %></td>
                                        <td class="px-6 py-4 text-xs font-bold text-slate-900 text-right">GH₵<%= mf.getOperationalResults() %></td>
                                        <td class="px-6 py-4 text-xs font-bold text-slate-900 text-right">GH₵<%= mf.getInvestmentIncome() %></td>
                                        <td class="px-6 py-4 text-xs font-black text-primary text-right">GH₵<%= mf.getProfitLossAfterTax() %></td>
                                        <% } else { %>
                                        <td class="px-6 py-4 text-xs font-semibold text-slate-400 text-right hover:bg-slate-50/50 italic">Awaiting Upload</td>
                                        <td class="px-6 py-4 text-xs font-semibold text-slate-400 text-right hover:bg-slate-50/50 italic">Awaiting Upload</td>
                                        <td class="px-6 py-4 text-xs font-bold text-slate-300 text-right hover:bg-slate-50/50">—</td>
                                        <td class="px-6 py-4 text-xs font-semibold text-slate-300 text-right hover:bg-slate-50/50">—</td>
                                        <td class="px-6 py-4 text-xs font-black text-slate-300 text-right hover:bg-slate-50/50">N/A</td>
                                        <% } %>
                                    </tr>
                                    <%      } 
                                        } 
                                    } 
                                    if (!hasCompanies) { %>
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center">
                                            <span class="material-symbols-outlined text-4xl text-slate-200">inventory_2</span>
                                            <p class="text-sm font-semibold text-slate-400 mt-2">No active policies found.</p>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <div class="px-6 py-3 border-t border-slate-100 bg-slate-50/50 flex justify-between items-center">
                            <span class="text-[10px] font-bold text-slate-500 bg-white px-2 py-1 rounded-md border border-slate-200 shadow-sm flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[14px] text-primary">sync</span> Live Sync Active
                            </span>
                            <span class="text-[10px] font-bold text-slate-400">Financials update upon endpoint filing</span>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden mt-8">
                    <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                        <h3 class="text-lg font-bold text-slate-900">Recent Regulatory Filings</h3>
                        <button onclick="downloadSecureReport('generate_market_report.jsp?type=brokers', 'NIC_Market_Analysis_Master.csv')" class="px-4 py-2 text-xs font-bold text-slate-600 bg-slate-50 border border-slate-200 rounded-lg hover:bg-slate-100 flex items-center gap-2 cursor-pointer">
                            <span class="material-symbols-outlined text-sm">download</span> Full Market Export
                        </button>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-t border-slate-100">
                                    <th class="px-8 py-5">Filing Date</th>
                                    <th class="px-8 py-5">Regulated Entity</th>
                                    <th class="px-8 py-5">Sector</th>
                                    <th class="px-8 py-5">Revenue (Comm.)</th>
                                    <th class="px-8 py-5">Profit/Loss</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <% if (recentFilings != null && !recentFilings.isEmpty()) { 
                                    for (MarketFinancials f : recentFilings) { 
                                        Company filingCompany = companyDAO.getCompanyById(f.getCompanyId());
                                        String filingCompName = filingCompany != null ? filingCompany.getName() : "Unknown Entity";
                                        
                                        String sectorColor = "text-blue-600 bg-blue-50";
                                        if ("LIFE".equalsIgnoreCase(f.getSector())) sectorColor = "text-emerald-600 bg-emerald-50";
                                        else if ("BROKER".equalsIgnoreCase(f.getSector())) sectorColor = "text-amber-600 bg-amber-50";
                                %>
                                <tr class="hover:bg-slate-50/50 transition-colors group">
                                    <td class="px-8 py-6 text-xs text-slate-500"><%= f.getUpdatedAt() %></td>
                                    <td class="px-8 py-6">
                                        <span class="text-sm font-bold text-slate-900"><%= filingCompName %></span>
                                    </td>
                                    <td class="px-8 py-6 text-xs">
                                        <span class="px-2.5 py-0.5 rounded-full <%= sectorColor %> text-[9px] font-bold uppercase tracking-wider">
                                            <%= f.getSector() %>
                                        </span>
                                    </td>
                                    <td class="px-8 py-6 font-black text-slate-900">GH₵<%= f.getCommissionIncome() %></td>
                                    <td class="px-8 py-6">
                                        <% BigDecimal profit = f.getProfitLossAfterTax(); %>
                                        <span class="text-xs font-bold <%= (profit != null && profit.compareTo(BigDecimal.ZERO) >= 0) ? "text-emerald-500" : "text-rose-500" %>">
                                            GH₵<%= profit %>
                                        </span>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="5" class="px-8 py-10 text-center">
                                        <div class="flex flex-col items-center">
                                            <span class="material-symbols-outlined text-slate-200 text-5xl">inventory_2</span>
                                            <p class="text-sm text-slate-400 mt-2 font-medium">No recent regulatory filings detected.</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Sidebar toggle
        document.getElementById('sidebarToggle')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });

        // Dropdown Toggles
        function setupDropdown(btnId, dropdownId) {
            const btn = document.getElementById(btnId);
            const dropdown = document.getElementById(dropdownId);
            if (!btn || !dropdown) return;

            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const isHidden = dropdown.classList.contains('hidden');
                document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
                if (isHidden) dropdown.classList.remove('hidden');
            });
        }

        setupDropdown('notificationBtn', 'notificationDropdown');
        setupDropdown('profileBtn', 'profileDropdown');

        window.addEventListener('click', () => {
            document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
        });

        // Activity Filter
        document.getElementById('headerSearchInput')?.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.search-row').forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(term) ? '' : 'none';
            });
        });

        // Anti-IDM Secure Download Handler
        async function downloadSecureReport(url, filename) {
            // Show loading state gracefully if you want, but for now just fetch
            try {
                const response = await fetch(url, { method: 'GET' });
                if (!response.ok) throw new Error('Network response was not ok');
                
                const blob = await response.blob();
                const blobUrl = window.URL.createObjectURL(blob);
                
                // Create native invisible anchor to force the browser download manager
                const tempLink = document.createElement('a');
                tempLink.style.display = 'none';
                tempLink.href = blobUrl;
                tempLink.setAttribute('download', filename);
                document.body.appendChild(tempLink);
                tempLink.click();
                
                // Cleanup
                window.URL.revokeObjectURL(blobUrl);
                document.body.removeChild(tempLink);
            } catch (error) {
                console.error("Download failed:", error);
                alert("Failed to download securely. Please try again.");
            }
        }

        // Sector Tab Switcher
        function switchSector(sector) {
            // Update Tab Styling
            const tabs = document.querySelectorAll('.sector-tab');
            tabs.forEach(tab => {
                tab.classList.remove('text-primary', 'border-primary');
                tab.classList.add('text-slate-400', 'border-transparent');
            });
            const activeTab = document.getElementById('tab-' + sector);
            if (activeTab) {
                activeTab.classList.remove('text-slate-400', 'border-transparent');
                activeTab.classList.add('text-primary', 'border-primary');
            }

            // Update Report Button target
            const reportBtn = document.getElementById('generateReportBtn');
            if (sector === 'brokers') {
                reportBtn.setAttribute('onclick', "downloadSecureReport('generate_market_report.jsp?type=brokers', 'NIC_Brokers_Market_Data.csv')");
            } else if (sector === 'life') {
                reportBtn.setAttribute('onclick', "downloadSecureReport('generate_market_report.jsp?type=life', 'NIC_Life_Sector_Market_Data.csv')");
            } else if (sector === 'nonlife') {
                reportBtn.setAttribute('onclick', "downloadSecureReport('generate_market_report.jsp?type=nonlife', 'NIC_Non_Life_Sector_Market_Data.csv')");
            }

            // Filter Table Rows
            const rows = document.querySelectorAll('.sector-row');
            let visibleCount = 0;
            rows.forEach(row => {
                const rowSector = row.dataset.sector || "";
                let isMatch = false;
                
                if (sector === 'brokers') {
                    isMatch = rowSector.includes('broker');
                } else if (sector === 'life') {
                    isMatch = rowSector.includes('life') && !rowSector.includes('non');
                } else if (sector === 'nonlife') {
                    isMatch = rowSector.includes('non') || rowSector.includes('auto') || 
                              rowSector.includes('general') || rowSector.includes('health') || 
                              rowSector.includes('home') || rowSector.includes('travel');
                }

                if (isMatch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Initialize Default Tab
        document.addEventListener('DOMContentLoaded', () => switchSector('brokers'));
    </script>
</body>
</html>
</html>
