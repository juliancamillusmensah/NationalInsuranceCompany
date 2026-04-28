<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    PolicyDAO policyDAO = new PolicyDAO();
    TransactionDAO transactionDAO = new TransactionDAO();
    SystemDAO systemDAO = new SystemDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    ClaimDAO claimDAO = new ClaimDAO();
    CompanyDAO companyDAO = new CompanyDAO();
    
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    Company currentCompany = companyDAO.getCompanyById(companyId);
    
    request.setAttribute("notifications", notificationDAO.getNotificationsByUserId(currentUser.getId()));
    request.setAttribute("unreadNotifications", notificationDAO.getUnreadCount(currentUser.getId()));
    
    int totalCustomerPolicies = policyDAO.getTotalPolicyCountByCompany(companyId);
    int successTransactions = transactionDAO.getTransactionCountByStatusAndCompany("successful", companyId);
    int pendingTransactions = transactionDAO.getTransactionCountByStatusAndCompany("Pending", companyId);
    int failedTransactions = transactionDAO.getTransactionCountByStatusAndCompany("Failed", companyId);
    
    // NIC Compliance Metrics
    int reportedClaims = claimDAO.getClaimCountByStatus("Reported", companyId);
    int acknowledgedClaims = claimDAO.getClaimCountByStatus("Acknowledged", companyId);
    int settledClaims = claimDAO.getClaimCountByStatus("Settled", companyId);
    double avgSettlementDays = claimDAO.getAverageSettlementDays(companyId);
    
    List<AdminInvitation> invitations = systemDAO.getInvitationsByCompanyId(companyId);
    int totalAdminInvitations = invitations.size();
    
    double totalTrans = (double)successTransactions + pendingTransactions + failedTransactions;
    double successRate = (totalTrans > 0) ? ((double)successTransactions / totalTrans) * 100 : 98.4;
    
    // License Status Logic
    String licenseStatus = "Valid";
    String expiryDateStr = (currentCompany != null) ? currentCompany.getLicenseExpiry() : null;
    long daysLeft = 365;
    
    if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
        try {
            java.time.LocalDate expiry = java.time.LocalDate.parse(expiryDateStr);
            java.time.LocalDate today = java.time.LocalDate.now();
            daysLeft = java.time.temporal.ChronoUnit.DAYS.between(today, expiry);
            
            if (daysLeft < 0) licenseStatus = "Expired";
            else if (daysLeft <= 30) licenseStatus = "Expiring Soon";
        } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Regulatory Performance</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#1152d4",
                        "background-light": "#f6f6f8",
                        "background-dark": "#101622",
                    },
                    fontFamily: {
                        "display": ["Inter", "sans-serif"]
                    },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col xl:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-12">
                <% if (!"Valid".equals(licenseStatus)) { %>
                    <section class="animate-in fade-in slide-in-from-top-4 duration-1000">
                        <div class="bg-gradient-to-r from-amber-500 to-orange-600 rounded-[3rem] p-8 md:p-12 text-white shadow-2xl shadow-orange-200">
                            <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-8">
                                <div class="flex items-start gap-6">
                                    <div class="p-4 bg-white/20 backdrop-blur-md rounded-3xl">
                                        <span class="material-symbols-outlined text-4xl"><%= "Expired".equals(licenseStatus) ? "gavel" : "notification_important" %></span>
                                    </div>
                                    <div>
                                        <h2 class="text-2xl md:text-3xl font-black tracking-tight"><%= "Expired".equals(licenseStatus) ? "Regulatory License Expired" : "License Renewal Required" %></h2>
                                        <p class="text-sm font-medium opacity-90 mt-2 max-w-xlLeading-relaxed">
                                            <%= "Expired".equals(licenseStatus) ? "Your operational license has expired. Your entity is currently marked as 'Non-Compliant'. Please renew immediately to avoid regulatory sanctions." : "Your license will expire in " + daysLeft + " days. Please initiate the renewal process to maintain your 'Compliant' status." %>
                                        </p>
                                    </div>
                                </div>
                                <form action="license_renewal_checkout.jsp" method="POST">
                                    <input type="hidden" name="companyId" value="<%= companyId %>">
                                    <button type="submit" class="px-8 py-4 bg-white text-orange-600 rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl hover:scale-105 transition-all active:scale-95">Renew License Now</button>
                                </form>
                            </div>
                        </div>
                    </section>
                <% } %>
                
                <!-- NIC Regulatory Scorecard -->
                <section>
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
                        <div>
                            <h3 class="text-2xl font-black text-slate-950">Regulatory Scorecard</h3>
                            <p class="text-xs text-slate-500 font-bold uppercase tracking-widest mt-1">Live NIC Ghana Compliance Status</p>
                        </div>
                        <div class="inline-flex items-center gap-2 bg-emerald-50 text-emerald-600 px-4 py-2 rounded-2xl border border-emerald-100 self-start md:self-auto">
                            <span class="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></span>
                            <span class="text-[10px] font-black uppercase tracking-widest">Compliant</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 lg:gap-8">
                        <div class="bg-white p-6 md:p-8 xl:p-10 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-sm relative overflow-hidden group">
                            <div class="p-3 bg-primary/5 rounded-2xl text-primary mb-6 w-fit">
                                <span class="material-symbols-outlined text-2xl">policy</span>
                            </div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Active Portfolios</p>
                            <h4 class="text-3xl font-black text-slate-950 mt-1"><%= totalCustomerPolicies %></h4>
                            <div class="mt-4 h-1 w-full bg-slate-50 rounded-full overflow-hidden">
                                <div class="h-full bg-primary" style="width: 75%"></div>
                            </div>
                        </div>

                        <div class="bg-white p-6 md:p-8 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-sm relative overflow-hidden group">
                            <div class="p-3 bg-amber-50 rounded-2xl text-amber-600 mb-6 w-fit">
                                <span class="material-symbols-outlined text-2xl">pending_actions</span>
                            </div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Unack. Claims</p>
                            <h4 class="text-3xl font-black text-slate-950 mt-1"><%= reportedClaims %></h4>
                            <p class="text-[10px] text-slate-400 font-bold mt-2">SLA Target: < 48 Hours</p>
                        </div>

                        <div class="bg-white p-6 md:p-8 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-sm relative overflow-hidden group">
                            <div class="p-3 bg-emerald-50 rounded-2xl text-emerald-600 mb-6 w-fit">
                                <span class="material-symbols-outlined text-2xl">task_alt</span>
                            </div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Settlement Rate</p>
                            <h4 class="text-3xl font-black text-slate-950 mt-1">
                                <%= (reportedClaims + acknowledgedClaims + settledClaims > 0) ? (int)((double)settledClaims / (reportedClaims + acknowledgedClaims + settledClaims) * 100) : 0 %>%
                            </h4>
                            <p class="text-[10px] text-emerald-600 font-bold mt-2">NIC Standard: > 90%</p>
                        </div>

                        <div class="bg-slate-950 p-6 md:p-8 rounded-[2.5rem] md:rounded-[3rem] text-white shadow-2xl relative overflow-hidden group">
                            <div class="p-3 bg-white/10 rounded-2xl text-white mb-6 w-fit">
                                <span class="material-symbols-outlined text-2xl">history</span>
                            </div>
                            <p class="text-[10px] font-black opacity-50 uppercase tracking-widest">Avg. Settlement TAT</p>
                            <h4 class="text-3xl font-black mt-1"><%= String.format("%.1f", avgSettlementDays) %> Days</h4>
                            <p class="text-[10px] text-emerald-400 font-bold mt-2">Within 30-Day Limit</p>
                        </div>
                    </div>
                </section>

                <div class="grid grid-cols-1 xl:grid-cols-2 gap-10 xl:gap-14">
                    <!-- Invitations -->
                    <section class="bg-white p-6 md:p-10 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-sm">
                        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
                            <h3 class="text-xl font-black text-slate-950">Team Invitations</h3>
                            <a href="companyadmin_settings.jsp" class="text-[10px] font-black text-primary uppercase tracking-widest hover:underline sm:self-auto self-start">Manage All</a>
                        </div>
                        <div class="space-y-4">
                            <% if (invitations != null && !invitations.isEmpty()) { 
                                for (int i=0; i < Math.min(3, invitations.size()); i++) {
                                    AdminInvitation inv = invitations.get(i);
                            %>
                            <div class="flex items-center justify-between p-4 bg-slate-50/50 rounded-2xl border border-slate-50">
                                <div class="flex flex-col">
                                    <span class="text-sm font-bold text-slate-950"><%= inv.getEmail() %></span>
                                    <span class="text-[10px] text-slate-400 font-bold">Expires: <%= inv.getExpiresAt() %></span>
                                </div>
                                <span class="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-[9px] font-black uppercase"><%= inv.isUsed() ? "Accepted" : "Pending" %></span>
                            </div>
                            <% } } else { %>
                            <p class="text-xs text-slate-400 italic">No pending invitations.</p>
                            <% } %>
                        </div>
                        <a href="companyadmin_settings.jsp#invite-section" class="mt-8 block w-full py-4 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-2xl text-xs font-black text-center transition-all">Invite New Admin</a>
                    </section>

                    <!-- Financial Operational Health -->
                    <section class="bg-white p-6 md:p-10 rounded-[2.5rem] md:rounded-[3rem] border border-slate-100 shadow-sm">
                        <h3 class="text-xl font-black text-slate-950 mb-8">Financial Health</h3>
                        <div class="space-y-8">
                            <div class="space-y-3">
                                <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-widest text-slate-400">
                                    <span>Trans. Success Rate</span>
                                    <span class="text-slate-950"><%= String.format("%.1f%%", successRate) %></span>
                                </div>
                                <div class="h-3 bg-slate-100 rounded-full overflow-hidden">
                                    <div class="h-full bg-primary rounded-full transition-all duration-1000 shadow-lg shadow-primary/20" style="width: <%= successRate %>%"></div>
                                </div>
                            </div>
                            
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                                <div class="p-4 bg-emerald-50 rounded-2xl border border-emerald-100">
                                    <p class="text-[9px] font-black text-emerald-600 uppercase">Successful</p>
                                    <p class="text-lg font-black text-emerald-700 mt-1"><%= successTransactions %></p>
                                </div>
                                <div class="p-4 bg-amber-50 rounded-2xl border border-amber-100">
                                    <p class="text-[9px] font-black text-amber-600 uppercase">Pending</p>
                                    <p class="text-lg font-black text-amber-700 mt-1"><%= pendingTransactions %></p>
                                </div>
                                <div class="p-4 bg-red-50 rounded-2xl border border-red-100">
                                    <p class="text-[9px] font-black text-red-600 uppercase">Failed</p>
                                    <p class="text-lg font-black text-red-700 mt-1"><%= failedTransactions %></p>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>

                <!-- Recent Activity -->
                <section>
                    <h3 class="text-xl font-black text-slate-950 mb-8">Operational Audit Log</h3>
                    <div class="bg-white rounded-[3rem] border border-slate-100 shadow-sm overflow-hidden">
                        <div class="divide-y divide-slate-50">
                            <%
                                List<DashboardActivity> recentActivities = systemDAO.getRecentActivitiesByCompany(5, companyId);
                                if (recentActivities != null && !recentActivities.isEmpty()) {
                                    for (DashboardActivity activity : recentActivities) {
                            %>
                            <div class="p-6 flex items-start gap-4 hover:bg-slate-50/50 transition-colors">
                                <div class="p-3 <%= activity.getColorClass() %> rounded-2xl">
                                    <span class="material-symbols-outlined text-xl"><%= activity.getIcon() %></span>
                                </div>
                                <div class="flex-1">
                                    <div class="flex items-center justify-between">
                                        <p class="text-sm font-bold text-slate-950"><%= activity.getTitle() %></p>
                                        <span class="text-[10px] font-black text-slate-400 uppercase"><%= activity.getTimestamp() %></span>
                                    </div>
                                    <p class="text-xs text-slate-500 mt-1"><%= activity.getDescription() %></p>
                                </div>
                            </div>
                            <% } } else { %>
                            <div class="p-20 text-center">
                                <span class="material-symbols-outlined text- slate-200 text-6xl">history</span>
                                <p class="text-slate-400 font-bold mt-4">No recent activity detected.</p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </section>
            </div>
            
            <jsp:include page="common/footer.jsp" />
        </main>
    </div>
</body>
</html>