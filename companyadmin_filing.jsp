<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    int year = Calendar.getInstance().get(Calendar.YEAR);
    
    CompanyDAO companyDAO = new CompanyDAO();
    Company currentCompany = companyDAO.getCompanyById(companyId);
    String compType = currentCompany != null && currentCompany.getCompanyType() != null ? currentCompany.getCompanyType().toLowerCase() : "non-life";
    
    // Sector identification
    boolean showLife = compType.contains("life") && !compType.contains("non-life");
    boolean showNonLife = compType.contains("non-life") || compType.contains("general") || compType.contains("life & non-life");
    if (compType.contains("life & non-life")) showLife = true;
    boolean showBroker = compType.contains("broker");
    
    int visibleSectors = (showLife ? 1 : 0) + (showNonLife ? 1 : 0) + (showBroker ? 1 : 0);
    String gridCols = visibleSectors == 3 ? "lg:grid-cols-3" : (visibleSectors == 2 ? "lg:grid-cols-2" : "lg:grid-cols-1");

    FinancialDAO financialDAO = new FinancialDAO();
    MarketFinancials lifeFinancials = financialDAO.getFinancials(companyId, "LIFE", year);
    MarketFinancials nonLifeFinancials = financialDAO.getFinancials(companyId, "NONLIFE", year);
    MarketFinancials brokerFinancials = financialDAO.getFinancials(companyId, "BROKER", year);
    
    if (lifeFinancials == null) lifeFinancials = new MarketFinancials(companyId, "LIFE", year);
    if (nonLifeFinancials == null) nonLifeFinancials = new MarketFinancials(companyId, "NONLIFE", year);
    if (brokerFinancials == null) brokerFinancials = new MarketFinancials(companyId, "BROKER", year);
    
    NotificationDAO notificationDAO = new NotificationDAO();
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Market Data Filing | NIC Ghana</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f6f6f8" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass-card { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.3); }
    </style>
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col xl:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-12">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <h2 class="text-3xl font-black text-slate-950">Market Analysis Filing</h2>
                        <p class="text-xs text-slate-500 font-bold uppercase tracking-widest mt-2">Annual Financial Reporting for <%= year %></p>
                    </div>
                </div>

                <form action="submit_filing_process.jsp" method="POST" class="space-y-8 max-w-5xl">
                    <input type="hidden" name="year" value="<%= year %>">
                    
                    <div class="grid grid-cols-1 <%= gridCols %> gap-8 mb-12">
                        <% if (showNonLife) { %>
                        <!-- Non-Life Sector Form -->
                        <div class="glass-card p-8 rounded-[2.5rem] shadow-xl shadow-slate-200/50">
                            <div class="flex items-center gap-4 mb-8">
                                <div class="p-3 bg-primary/10 text-primary rounded-2xl">
                                    <span class="material-symbols-outlined">analytics</span>
                                </div>
                                <h3 class="text-xl font-bold text-slate-900">Non-Life Sector</h3>
                            </div>
                            
                            <div class="space-y-5">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Commission Income</label>
                                    <input type="number" step="0.01" name="nonlife_commission" value="<%= nonLifeFinancials.getCommissionIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">General & Admin Exp</label>
                                    <input type="number" step="0.01" name="nonlife_admin" value="<%= nonLifeFinancials.getAdminExp() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Operational Results</label>
                                    <input type="number" step="0.01" name="nonlife_operational" value="<%= nonLifeFinancials.getOperationalResults() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Total Investments Inc</label>
                                    <input type="number" step="0.01" name="nonlife_investment" value="<%= nonLifeFinancials.getInvestmentIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Profit/Loss After Tax</label>
                                    <input type="number" step="0.01" name="nonlife_profit" value="<%= nonLifeFinancials.getProfitLossAfterTax() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if (showLife) { %>
                        <!-- Life Sector Form -->
                        <div class="glass-card p-8 rounded-[2.5rem] shadow-xl shadow-slate-200/50">
                            <div class="flex items-center gap-4 mb-8">
                                <div class="p-3 bg-emerald-50 text-emerald-600 rounded-2xl">
                                    <span class="material-symbols-outlined">favorite</span>
                                </div>
                                <h3 class="text-xl font-bold text-slate-900">Life Sector</h3>
                            </div>
                            
                            <div class="space-y-5">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Commission Income</label>
                                    <input type="number" step="0.01" name="life_commission" value="<%= lifeFinancials.getCommissionIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">General & Admin Exp</label>
                                    <input type="number" step="0.01" name="life_admin" value="<%= lifeFinancials.getAdminExp() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Operational Results</label>
                                    <input type="number" step="0.01" name="life_operational" value="<%= lifeFinancials.getOperationalResults() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Total Investments Inc</label>
                                    <input type="number" step="0.01" name="life_investment" value="<%= lifeFinancials.getInvestmentIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Profit/Loss After Tax</label>
                                    <input type="number" step="0.01" name="life_profit" value="<%= lifeFinancials.getProfitLossAfterTax() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if (showBroker) { %>
                        <!-- Broker Sector Form -->
                        <div class="glass-card p-8 rounded-[2.5rem] shadow-xl shadow-slate-200/50">
                            <div class="flex items-center gap-4 mb-8">
                                <div class="p-3 bg-amber-50 text-amber-600 rounded-2xl">
                                    <span class="material-symbols-outlined">identity_platform</span>
                                </div>
                                <h3 class="text-xl font-bold text-slate-900">Broker Sector</h3>
                            </div>
                            
                            <div class="space-y-5">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Commission Income</label>
                                    <input type="number" step="0.01" name="broker_commission" value="<%= brokerFinancials.getCommissionIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">General & Admin Exp</label>
                                    <input type="number" step="0.01" name="broker_admin" value="<%= brokerFinancials.getAdminExp() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Operational Results</label>
                                    <input type="number" step="0.01" name="broker_operational" value="<%= brokerFinancials.getOperationalResults() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Total Investments Inc</label>
                                    <input type="number" step="0.01" name="broker_investment" value="<%= brokerFinancials.getInvestmentIncome() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Profit/Loss After Tax</label>
                                    <input type="number" step="0.01" name="broker_profit" value="<%= brokerFinancials.getProfitLossAfterTax() %>" class="w-full bg-slate-50 border-slate-100 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <div class="flex justify-end">
                        <button type="submit" class="px-10 py-4 bg-primary text-white rounded-2xl text-xs font-black uppercase tracking-widest shadow-2xl shadow-primary/30 hover:scale-[1.02] transition-transform">
                            Submit Annual Filing
                        </button>
                    </div>
                </form>
            </div>
            <jsp:include page="common/footer.jsp" />
        </main>
    </div>
</body>
</html>
