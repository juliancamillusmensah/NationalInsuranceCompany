<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess.getAttribute("roleId") != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || (!"ROLE_ADMIN".equals(roleId) && !"ROLE_AUDITOR".equals(roleId))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    // For admin, we want to see all transactions. Since getTransactionsByUserId requires an ID, 
    // we should ideally add a getAllTransactions() to TransactionDAO.
    // For now, let's assume this page will be built out further when the DAO supports it.
    NotificationDAO notificationDAO = new NotificationDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
    List<Notification> topNotifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    
    TransactionDAO transactionDAO = new TransactionDAO();
    List<Transaction> allTransactions = (companyId != null) ? transactionDAO.getTransactionsByCompanyId(companyId) : transactionDAO.getAllTransactions();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Transactions</title>
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
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-size: 24px; vertical-align: middle; }
    </style>
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col xl:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50 min-w-0 overflow-x-hidden">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-12">
                <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-8">
                    <div>
                        <h2 class="text-3xl xl:text-4xl font-black text-slate-950">Transaction History</h2>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em] mt-2">Global Financial Ledger</p>
                    </div>
                    <a href="export_transactions.jsp" class="bg-primary text-white px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-primary/90 transition-all flex items-center justify-center gap-3 shadow-2xl shadow-primary/20 w-full md:w-auto">
                        <span class="material-symbols-outlined text-xl">download</span>
                        Export Record
                    </a>
                </div>

                <div class="space-y-6">
                    <!-- Mobile View: Cards (Visible on screens < 1280px) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 xl:hidden">
                        <% if (allTransactions != null && !allTransactions.isEmpty()) {
                            for (Transaction t : allTransactions) { 
                                String statusColor = "successful".equalsIgnoreCase(t.getPaymentStatus()) ? "bg-emerald-50 text-emerald-600" : 
                                                    "pending".equalsIgnoreCase(t.getPaymentStatus()) ? "bg-amber-50 text-amber-600" : "bg-red-50 text-red-600";
                                String userName = t.getUserName() != null ? t.getUserName() : "Unknown Subscriber";
                                String initial = userName.length() > 0 ? userName.substring(0, 1) : "?";
                                String policyName = t.getPolicyName() != null ? t.getPolicyName() : "Unknown Policy";
                        %>
                        <div class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-sm space-y-4">
                            <div class="flex items-center justify-between">
                                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">#<%= t.getId() %></span>
                                <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest <%= statusColor %>">
                                    <%= t.getPaymentStatus() %>
                                </span>
                            </div>

                            <div class="flex items-center gap-3 py-4 border-y border-slate-50">
                                <div class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-xs font-bold text-slate-500 uppercase shrink-0">
                                    <%= initial %>
                                </div>
                                <div class="min-w-0">
                                    <p class="text-sm font-black text-slate-950 truncate"><%= userName %></p>
                                    <p class="text-[10px] text-slate-500 truncate"><%= t.getUserEmail() != null ? t.getUserEmail() : "No email linked" %></p>
                                </div>
                            </div>

                            <div class="space-y-3">
                                <div class="flex justify-between items-center">
                                    <div class="flex flex-col">
                                        <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Policy</span>
                                        <p class="text-xs font-bold text-slate-900"><%= policyName %></p>
                                    </div>
                                    <div class="text-right">
                                        <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Amount</span>
                                        <p class="text-lg font-black text-slate-950">GH₵<%= t.getAmount() %></p>
                                    </div>
                                </div>
                                <div class="flex justify-between items-center pt-3 border-t border-slate-50">
                                    <span class="text-[9px] font-black text-primary uppercase tracking-tighter"><%= t.getTransactionType() %></span>
                                    <span class="text-[10px] text-slate-400 font-bold"><%= t.getTransactionDate() %></span>
                                </div>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="bg-white p-12 rounded-[2.5rem] border border-slate-100 text-center">
                            <span class="material-symbols-outlined text-slate-200 text-4xl">account_balance_wallet</span>
                            <p class="text-[10px] text-slate-400 font-bold mt-4">No Transactions Detected</p>
                        </div>
                        <% } %>
                    </div>

                    <!-- Desktop View: Table (Visible on screens >= 1280px) -->
                    <div class="hidden xl:block bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-slate-50/50 border-b border-slate-100">
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Transaction ID</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Subscriber</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Policy & Type</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Amount</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Status</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Date</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <% if (allTransactions != null && !allTransactions.isEmpty()) {
                                        for (Transaction t : allTransactions) { 
                                            String statusColor = "successful".equalsIgnoreCase(t.getPaymentStatus()) ? "bg-emerald-50 text-emerald-600" : 
                                                                "pending".equalsIgnoreCase(t.getPaymentStatus()) ? "bg-amber-50 text-amber-600" : "bg-red-50 text-red-600";
                                            String userName = t.getUserName() != null ? t.getUserName() : "Unknown Subscriber";
                                            String initial = userName.length() > 0 ? userName.substring(0, 1) : "?";
                                            String policyName = t.getPolicyName() != null ? t.getPolicyName() : "Unknown Policy";
                                    %>
                                    <tr class="hover:bg-slate-50/50 transition-colors group">
                                        <td class="px-8 py-6">
                                            <span class="text-xs font-bold text-slate-400">#<%= t.getId() %></span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <div class="flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-[10px] font-bold text-slate-500 uppercase">
                                                    <%= initial %>
                                                </div>
                                                <div>
                                                    <p class="text-sm font-bold text-slate-900"><%= userName %></p>
                                                    <p class="text-[10px] text-slate-500 font-medium"><%= t.getUserEmail() != null ? t.getUserEmail() : "No email linked" %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <div>
                                                <p class="text-sm font-bold text-slate-900"><%= policyName %></p>
                                                <p class="text-[10px] text-primary font-bold uppercase tracking-tighter"><%= t.getTransactionType() %></p>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="text-sm font-black text-slate-900">GH₵<%= t.getAmount() %></span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest <%= statusColor %>">
                                                <%= t.getPaymentStatus() %>
                                            </span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="text-xs font-bold text-slate-500"><%= t.getTransactionDate() %></span>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="6" class="px-8 py-20 text-center">
                                            <div class="flex flex-col items-center max-w-md mx-auto">
                                                <div class="w-16 h-16 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 mb-6">
                                                    <span class="material-symbols-outlined text-3xl">account_balance_wallet</span>
                                                </div>
                                                <h3 class="text-xl font-bold text-slate-900 mb-2">No Transactions Detected</h3>
                                                <p class="text-slate-500 text-sm">When subscribers begin making payments, they will appear here in the global ledger.</p>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
