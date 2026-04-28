<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.insurance.dao.*" %>
        <%@ page import="com.insurance.model.*" %>
            <%@ page import="java.util.*" %>
                <% 
                    HttpSession sess = request.getSession(false);
                    if (sess == null || sess.getAttribute("user") == null) {
                        response.sendRedirect("allloginpage.jsp");
                        return;
                    }
                    String userId = (String) sess.getAttribute("userId");
                    AccountDAO accountDAO = new AccountDAO();
                    PolicyDAO policyDAO = new PolicyDAO();
                    TransactionDAO transactionDAO = new TransactionDAO();
                    ClaimDAO claimDAO = new ClaimDAO();
                    Account user = (Account) sess.getAttribute("user");
                    List<Policy> myPolicies = policyDAO.getCustomerPolicies(userId);
                    List<Transaction> transactions = transactionDAO.getTransactionsByUserId(userId);
                    List<Claim> myClaims = claimDAO.getClaimsByUserId(userId);

                    NotificationDAO noteDAO = new NotificationDAO();
                    List<Notification> notifications = noteDAO.getNotificationsByUserId(userId);
                    int unreadCount = noteDAO.getUnreadCount(userId);

                    if (myPolicies == null) {
                        myPolicies = new ArrayList<>();
                    }
                %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>Customer Portal - NIC Insurance</title>
                            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                rel="stylesheet" />
                            <link
                                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                                rel="stylesheet" />
                            <script id="tailwind-config">
                                tailwind.config = {
                                    darkMode: "class",
                                    theme: {
                                        extend: {
                                            colors: {
                                                "primary": "#1152d4",
                                                "background-light": "#f8fafc",
                                            },
                                            fontFamily: {
                                                "display": ["Inter", "sans-serif"]
                                            },
                                        },
                                    },
                                }
                            </script>
                            <style>
                                body {
                                    font-family: 'Inter', sans-serif;
                                }

                                .material-symbols-outlined {
                                    font-size: 20px;
                                    vertical-align: middle;
                                }
                            </style>
                        </head>

                        <body class="bg-background-light text-slate-900 antialiased min-h-screen">
                            <!-- Main Header -->
                            <header
                                class="bg-white border-b border-slate-100 h-auto lg:h-20 flex flex-col lg:flex-row lg:items-center px-6 lg:px-10 py-4 lg:py-0 sticky top-0 z-50 shadow-sm gap-4">
                                <div class="flex items-center justify-between w-full lg:w-auto">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-primary p-2 rounded-lg text-white">
                                            <span class="material-symbols-outlined">shield</span>
                                        </div>
                                        <span
                                            class="text-xl font-black tracking-tight text-slate-900 border-r border-slate-200 lg:pr-4">Customer
                                            Portal</span>
                                    </div>
                                    <button onclick="document.getElementById('mobile-nav').classList.toggle('hidden')" class="md:hidden p-2 text-slate-500">
                                        <span class="material-symbols-outlined">menu</span>
                                    </button>
                                </div>

                                <nav id="mobile-nav" class="hidden md:flex flex-col md:flex-row items-start md:items-center gap-4 md:gap-8 w-full lg:w-auto">
                                    <a href="Customerportal.jsp" class="text-sm font-bold text-primary">My Coverage</a>
                                    <a href="customer_explore_policies.jsp"
                                        class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Explore
                                        Policies</a>
                                    <a href="customer_support.jsp"
                                        class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Support</a>
                                </nav>

                                <div class="ml-auto flex items-center justify-between lg:justify-end gap-6 w-full lg:w-auto">
                                    <form action="customer_explore_policies.jsp" method="get" class="relative w-full lg:w-72">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                        <input type="text" name="q" placeholder="Search policies..."
                                            class="w-full bg-slate-50 border-none rounded-xl pl-10 pr-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                                    </form>
                                    <div class="flex items-center gap-6">
                                        <!-- Notification Dropdown -->
                                        <div class="relative group">
                                            <button
                                                onclick="document.getElementById('notif-dropdown').classList.toggle('hidden')"
                                                class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                                                <span class="material-symbols-outlined">notifications</span>
                                                <% if (unreadCount > 0) { %>
                                                    <span
                                                        class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                                                <% } %>
                                            </button>
                                            
                                            <!-- Dropdown Menu -->
                                            <div id="notif-dropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-2xl shadow-xl border border-slate-100 transition-all duration-300 z-[60] py-4">
                                                <div class="flex items-center justify-between px-6 mb-4">
                                                    <h3 class="text-sm font-black text-slate-900">Notifications</h3>
                                                    <% if (unreadCount > 0) { %>
                                                        <span class="text-[10px] font-bold bg-primary/10 text-primary px-2 py-0.5 rounded-full"><%= unreadCount %> New</span>
                                                    <% } %>
                                                </div>
                                                
                                                <div class="max-h-64 overflow-y-auto px-2 space-y-1">
                                                    <% if (notifications.isEmpty()) { %>
                                                        <div class="py-10 text-center">
                                                            <span class="material-symbols-outlined text-slate-200 text-4xl mb-2">notifications_off</span>
                                                            <p class="text-xs font-medium text-slate-400">All caught up!</p>
                                                        </div>
                                                    <% } else { %>
                                                        <% for (Notification note : notifications) { %>
                                                        <% 
                                                            String noteReadClass = note.isRead() ? "opacity-60" : "bg-primary/5 hover:bg-primary/10";
                                                            String noteColorClass = "Success".equals(note.getType()) ? "bg-emerald-100 text-emerald-600" : "bg-blue-100 text-blue-600";
                                                            String noteIcon = "Success".equals(note.getType()) ? "check_circle" : "info";
                                                        %>
                                                            <a href="mark_notification_read.jsp?id=<%= note.getId() %>" class="block p-3 rounded-xl transition-colors <%= noteReadClass %>">
                                                                <div class="flex gap-3">
                                                                    <div class="h-8 w-8 rounded-lg flex items-center justify-center shrink-0 <%= noteColorClass %>">
                                                                        <span class="material-symbols-outlined text-sm"><%= noteIcon %></span>
                                                                    </div>
                                                                    <div>
                                                                        <p class="text-xs font-black text-slate-900"><%= note.getTitle() %></p>
                                                                        <p class="text-[10px] text-slate-500 line-clamp-2 mt-0.5"><%= note.getMessage() %></p>
                                                                        <p class="text-[9px] font-bold text-slate-400 mt-1 uppercase"><%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(note.getCreatedAt()) %></p>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                                
                                                <% if (!notifications.isEmpty()) { %>
                                                <div class="px-6 mt-4 pt-4 border-t border-slate-50">
                                                    <a href="clear_notifications_process.jsp" class="block w-full text-center py-2 text-[10px] font-black text-slate-400 uppercase tracking-widest hover:text-primary transition-colors">Clear All</a>
                                                </div>
                                                <% } %>
                                            </div>
                                        </div>
                                        <a href="account_settings.jsp"
                                            class="h-10 w-10 rounded-full overflow-hidden border-2 border-slate-100 shadow-sm cursor-pointer hover:border-primary transition-all">
                                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= user.getFullName() %>" alt="Avatar"
                                                class="h-full w-full object-cover">
                                        </a>
                                        <a href="${pageContext.request.contextPath}/logout.jsp" class="p-2 text-slate-400 hover:text-red-500 transition-colors" title="Sign Out">
                                            <span class="material-symbols-outlined text-2xl">logout</span>
                                        </a>
                                    </div>
                                </div>
                            </header>

                            <main class="max-w-7xl mx-auto p-6 lg:p-10 space-y-10 lg:space-y-12">
                                <% String successMsg = request.getParameter("success");
                                   if ("enroll".equals(successMsg)) { %>
                                    <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-6 py-4 rounded-2xl flex items-center gap-3">
                                        <span class="material-symbols-outlined text-emerald-600">check_circle</span>
                                        <div>
                                            <p class="font-bold">Successfully Enrolled</p>
                                            <p class="text-sm">Your new policy is now active and added to your coverage portfolio. The corresponding transaction has been recorded.</p>
                                        </div>
                                    </div>
                                <% } else if ("renew".equals(successMsg)) { %>
                                    <div class="bg-primary/10 border border-primary/20 text-primary-dark px-6 py-4 rounded-2xl flex items-center gap-3" style="color: #1152d4;">
                                        <span class="material-symbols-outlined text-primary">autorenew</span>
                                        <div>
                                            <p class="font-bold">Policy Renewed Successfully</p>
                                            <p class="text-sm">Your policy coverage has been extended for another year. The corresponding transaction has been recorded.</p>
                                        </div>
                                    </div>
                                <% } else if ("claim".equals(successMsg)) { %>
                                    <div class="bg-blue-50 border border-blue-200 text-blue-800 px-6 py-4 rounded-2xl flex items-center gap-3">
                                        <span class="material-symbols-outlined text-blue-600">info</span>
                                        <div>
                                            <p class="font-bold">Claim Submitted Successfully</p>
                                            <p class="text-sm">Your claim has been received and is currently under review by our agents.</p>
                                        </div>
                                    </div>
                                <% } %>

                                <!-- Welcome Section -->
                                <div>
                                    <% String firstName=(user !=null) ? user.getFullName().split(" ")[0] : " Alex"; %>
                                        <h1 class="text-3xl lg:text-4xl font-black text-slate-950 tracking-tight">Welcome back, <%= firstName %></h1>
                                        <p class="text-slate-500 mt-2 font-medium text-sm lg:text-base">Manage your active protection and
                                            explore tailored insurance plans.</p>
                                </div>

                                <!-- Navigation Tabs -->
                                <div class="flex items-center justify-between border-b border-slate-100 pb-1">
                                    <div class="flex gap-10">
                                        <button id="tab-policies" onclick="switchTab('policies')"
                                            class="text-sm font-bold text-primary border-b-2 border-primary pb-3 -mb-1 transition-all duration-300">My
                                            Policies</button>
                                        <button id="tab-claims" onclick="switchTab('claims')"
                                            class="text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-all duration-300">My
                                            Claims</button>
                                        <button id="tab-transactions" onclick="switchTab('transactions')"
                                            class="text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-all duration-300">Transaction
                                            History</button>
                                    </div>
                                    <a href="customer_new_claim.jsp"
                                        class="flex items-center gap-2 text-primary text-sm font-black italic hover:translate-x-1 transition-transform">
                                        <span class="material-symbols-outlined text-xs">add_circle</span> New Claim
                                    </a>
                                </div>

                                <!-- Policies Grid -->
                                <div id="section-policies" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 transition-all duration-500">
                                    <% if (myPolicies.isEmpty()) { %>
                                        <!-- Demo Placeholder -->
                                        <div
                                            class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-xl shadow-slate-200/50 flex flex-col space-y-6">
                                            <div class="flex items-center justify-between mb-2">
                                                <div class="p-4 bg-emerald-50 rounded-2xl text-emerald-600">
                                                    <span class="material-symbols-outlined">directions_car</span>
                                                </div>
                                                <span
                                                    class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-[10px] font-black uppercase tracking-tighter">Active</span>
                                            </div>
                                            <div>
                                                <h4 class="text-xl font-black text-slate-900">Auto Shield Pro</h4>
                                                <p class="text-xs text-slate-400 mt-1 font-bold">Premium auto insurance
                                                    with roadside assistance</p>
                                            </div>
                                            <div class="space-y-4 pt-4">
                                                <div class="flex justify-between text-sm">
                                                    <span class="text-slate-400 font-bold">Premium</span>
                                                    <span class="font-black text-slate-900">GH₵89.00/mo</span>
                                                </div>
                                                <div class="flex justify-between text-sm">
                                                    <span class="text-slate-400 font-bold">Renewal Date</span>
                                                    <span class="font-black text-slate-900">Oct 12, 2024</span>
                                                </div>
                                            </div>
                                            <button
                                                class="w-full py-4 bg-slate-50 text-slate-900 rounded-2xl text-sm font-black hover:bg-slate-100 transition-all">Manage
                                                Policy</button>
                                        </div>
                                        <% } else { %>
                                            <% for (Policy p : myPolicies) { 
                                                String ps = p.getPolicyStatus() != null ? p.getPolicyStatus() : "active";
                                                boolean isActive = "active".equalsIgnoreCase(ps);
                                                boolean isCancelled = "cancelled".equalsIgnoreCase(ps);
                                                String statusColor = isCancelled ? "bg-red-100 text-red-600" : (isActive ? "bg-emerald-100 text-emerald-700" : "bg-slate-100 text-slate-500");
                                                String iconColor = isCancelled ? "bg-red-50 text-red-500" : (isActive ? "bg-emerald-50 text-emerald-600" : "bg-slate-50 text-slate-900");
                                                String name = p.getPolicyName().toLowerCase();
                                                String icon = name.contains("auto") ? "directions_car" : (name.contains("home") ? "home" : "shield");
                                            %>
                                                <div
                                                    class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-xl shadow-slate-200/50 flex flex-col space-y-6">
                                                    <div class="flex items-center justify-between mb-2">
                                                        <div class="p-4 <%= iconColor %> rounded-2xl">
                                                            <span class="material-symbols-outlined">
                                                                <%= icon %>
                                                            </span>
                                                        </div>
                                                        <span
                                                            class="px-3 py-1 <%= statusColor %> rounded-full text-[10px] font-black uppercase tracking-tighter">
                                                            <%= ps %>
                                                        </span>
                                                    </div>
                                                    <div>
                                                        <h4 class="text-xl font-black text-slate-900">
                                                            <%= p.getPolicyName() %>
                                                        </h4>
                                                        <p class="text-xs text-slate-400 mt-1 font-bold">Insurance
                                                            coverage details and benefits</p>
                                                    </div>
                                                    <div class="space-y-3 pt-4">
                                                        <div class="flex justify-between text-sm">
                                                            <span class="text-slate-400 font-bold">Insured Item</span>
                                                            <span class="font-black text-slate-900 text-right max-w-[150px] truncate" title="<%= p.getInsuredItem() != null ? p.getInsuredItem().replace("\"", "&quot;") : "" %>"><%= p.getInsuredItem() != null ? p.getInsuredItem() : "Not Specified" %></span>
                                                        </div>
                                                        <div class="flex justify-between text-sm">
                                                            <span class="text-slate-400 font-bold">Premium</span>
                                                            <span class="font-black text-slate-900">GH₵<%= p.getPremiumAmount() %>/mo</span>
                                                        </div>
                                                        <div class="flex justify-between text-sm">
                                                            <span class="text-slate-400 font-bold">Renewal Date</span>
                                                            <span class="font-black text-slate-900 text-right">
                                                                <%= p.getEndDate() %>
                                                            </span>
                                                        </div>
                                                        <div class="border-t border-slate-100 pt-3 flex justify-between items-center text-sm">
                                                            <span class="text-slate-400 font-bold text-xs uppercase tracking-widest">Docs</span>
                                                            <% if (p.getDocumentPath() != null && !p.getDocumentPath().trim().isEmpty()) { %>
                                                                <a href="${pageContext.request.contextPath}/<%= p.getDocumentPath() %>" target="_blank" class="inline-flex items-center gap-1 bg-primary/10 text-primary px-3 py-1 rounded-full text-xs font-black hover:bg-primary/20 transition-colors">
                                                                    <span class="material-symbols-outlined text-[14px]">file_download</span> View PDF
                                                                </a>
                                                            <% } else { %>
                                                                <span class="text-xs font-bold text-slate-400 italic">None attached</span>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    <% if ("expired".equalsIgnoreCase(p.getPolicyStatus())) { %>
                                                        <form action="renew_process.jsp" method="post">
                                                            <input type="hidden" name="customerPolicyId" value="<%= p.getCustomerPolicyId() %>">
                                                            <input type="hidden" name="policyId" value="<%= p.getId() %>">
                                                            <input type="hidden" name="premiumAmount" value="<%= p.getPremiumAmount() %>">
                                                            <button type="submit"
                                                                class="w-full py-4 bg-primary text-white rounded-2xl text-sm font-black hover:bg-primary/90 shadow-lg shadow-primary/20 transition-all">Renew
                                                                Now</button>
                                                        </form>
                                                    <% } else if ("cancelled".equalsIgnoreCase(p.getPolicyStatus())) { %>
                                                        <button disabled
                                                            class="w-full py-4 bg-red-50 text-red-400 rounded-2xl text-sm font-black cursor-not-allowed">Cancelled</button>
                                                    <% } else { %>
                                                        <button onclick="openManageModal('<%= p.getPolicyName().replace("'", "\\'") %>', '<%= p.getDescription() != null ? p.getDescription().replace("'", "\\'") : "Complete insurance coverage" %>', '<%= p.getPremiumAmount() %>', '<%= p.getStartDate() %>', '<%= p.getEndDate() %>', '<%= p.getPolicyStatus() %>', '<%= p.getCoverageDuration() != null ? p.getCoverageDuration() : "12 Months" %>', '<%= p.getCustomerPolicyId() %>')"
                                                            class="w-full py-4 bg-slate-50 text-slate-900 rounded-2xl text-sm font-black hover:bg-slate-100 transition-all">Manage
                                                            Policy</button>
                                                    <% } %>
                                                </div>
                                                <% } %>
                                                    <% } %>
                                </div>

                                <!-- My Claims Section -->
                                <div id="section-claims" class="hidden space-y-6 transition-all duration-500">
                                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                                        <div class="overflow-x-auto">
                                            <table class="w-full text-left min-w-[600px]">
                                            <thead>
                                                <tr class="bg-slate-50 border-b border-slate-100">
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Type/ID</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Policy</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Amount</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Incident Date</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-slate-50">
                                                <% if (myClaims.isEmpty()) { %>
                                                    <tr>
                                                        <td colspan="5" class="py-20 text-center">
                                                            <div class="flex flex-col items-center">
                                                                <span class="material-symbols-outlined text-slate-200 text-6xl mb-4">description</span>
                                                                <p class="text-slate-400 font-bold">No claims filed yet.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                <% } else { %>
                                                    <% for (Claim c : myClaims) { 
                                                        String stColor = "bg-slate-100 text-slate-600";
                                                        if("Approved".equalsIgnoreCase(c.getStatus())) stColor = "bg-emerald-100 text-emerald-700";
                                                        else if("Rejected".equalsIgnoreCase(c.getStatus())) stColor = "bg-red-100 text-red-700";
                                                        else if("Pending".equalsIgnoreCase(c.getStatus())) stColor = "bg-blue-100 text-blue-700";
                                                    %>
                                                        <tr class="hover:bg-slate-50 transition-colors">
                                                            <td class="px-8 py-6">
                                                                <p class="text-sm font-black text-slate-900">General Claim</p>
                                                                <p class="text-[10px] text-slate-400 font-bold mt-0.5">#<%= c.getId() %></p>
                                                            </td>
                                                            <td class="px-8 py-6 text-sm font-bold text-slate-600">
                                                                <%= c.getPolicyName() %>
                                                            </td>
                                                            <td class="px-8 py-6">
                                                                <p class="text-sm font-black text-slate-900">GH₵<%= c.getClaimAmount() %></p>
                                                            </td>
                                                            <td class="px-8 py-6 text-sm font-bold text-slate-500">
                                                                <%= c.getIncidentDate() %>
                                                            </td>
                                                            <td class="px-8 py-6 text-right">
                                                                <span class="px-3 py-1 <%= stColor %> rounded-full text-[10px] font-black uppercase tracking-tighter"><%= c.getStatus() %></span>
                                                            </td>
                                                        </tr>
                                                    <% } %>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                                <!-- Transaction History Section -->
                                <div id="section-transactions" class="hidden space-y-6 transition-all duration-500">
                                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                                        <div class="overflow-x-auto">
                                            <table class="w-full text-left min-w-[600px]">
                                            <thead>
                                                <tr class="bg-slate-50 border-b border-slate-100">
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Policy</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Type</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Amount</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Date</th>
                                                    <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Status</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-slate-50">
                                                <% if (transactions.isEmpty()) { %>
                                                    <tr>
                                                        <td colspan="5" class="py-20 text-center">
                                                            <div class="flex flex-col items-center">
                                                                <span class="material-symbols-outlined text-slate-200 text-6xl mb-4">ledger</span>
                                                                <p class="text-slate-400 font-bold">No transactions found yet.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                <% } else { %>
                                                    <% for (Transaction t : transactions) { %>
                                                        <tr class="hover:bg-slate-50 transition-colors">
                                                            <td class="px-8 py-6">
                                                                <p class="text-sm font-black text-slate-900"><%= t.getPolicyName() %></p>
                                                                <p class="text-[10px] text-slate-400 font-bold mt-0.5">ID: #<%= t.getId() %></p>
                                                            </td>
                                                            <td class="px-8 py-6">
                                                                <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[10px] font-black uppercase tracking-tighter"><%= t.getTransactionType() %></span>
                                                            </td>
                                                            <td class="px-8 py-6">
                                                                <p class="text-sm font-black text-slate-900">GH₵<%= t.getAmount() %></p>
                                                                <p class="text-[10px] text-slate-400 font-bold mt-0.5">via <%= t.getPaymentMethod() %></p>
                                                            </td>
                                                            <td class="px-8 py-6 text-sm font-bold text-slate-500">
                                                                <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(t.getTransactionDate()) %>
                                                            </td>
                                                            <td class="px-8 py-6 text-right">
                                                                <% if ("cancelled".equalsIgnoreCase(t.getPolicyStatus())) { %>
                                                                    <span class="px-3 py-1 bg-slate-100 text-slate-500 rounded-full text-[10px] font-black uppercase tracking-tighter">Cancelled</span>
                                                                <% } else { %>
                                                                    <span class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-[10px] font-black uppercase tracking-tighter">Completed</span>
                                                                <% } %>
                                                            </td>
                                                        </tr>
                                                    <% } %>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                                <!-- Recommended Section -->
                                <div>
                                    <div class="flex items-center justify-between mb-8">
                                        <h2 class="text-2xl font-black text-slate-950">Recommended for You</h2>
                                        <div class="flex items-center gap-2" id="rec-dots">
                                            <button class="rec-dot w-2 h-2 rounded-full bg-primary transition-all" data-index="0"></button>
                                            <button class="rec-dot w-2 h-2 rounded-full bg-slate-200 transition-all" data-index="1"></button>
                                            <button class="rec-dot w-2 h-2 rounded-full bg-slate-200 transition-all" data-index="2"></button>
                                            <button class="rec-dot w-2 h-2 rounded-full bg-slate-200 transition-all" data-index="3"></button>
                                        </div>
                                    </div>

                                    <!-- Carousel Wrapper -->
                                    <div class="relative overflow-hidden" id="rec-carousel">

                                        <!-- Slide 0 -->
                                        <div class="rec-slide grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 transition-opacity duration-700" data-slide="0">
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1488646015982-5c24939fac3c?q=80&w=800" alt="Travel" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-primary uppercase tracking-widest">Travel</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Global Wanderer</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Full international medical &amp; luggage coverage.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵29<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=80&w=800" alt="Health" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-emerald-600 uppercase tracking-widest">Health</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Vitality Plus</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Complete health &amp; wellness coverage for your family.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵45<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">24 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800" alt="Auto" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-blue-600 uppercase tracking-widest">Auto</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Road Shield</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Comprehensive vehicle protection on every road.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵38<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800" alt="Home" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-amber-600 uppercase tracking-widest">Home</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">HomeGuard Elite</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Protect your home and belongings nationwide.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵52<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Slide 1 -->
                                        <div class="rec-slide hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 transition-opacity duration-700 opacity-0" data-slide="1">
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=800" alt="Life" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-rose-600 uppercase tracking-widest">Life</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Legacy Protect</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Secure your family's financial future today.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵22<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">36 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1530521954074-e64f6810b32d?q=80&w=800" alt="Travel" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-primary uppercase tracking-widest">Travel</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Adventure Shield</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">For explorers — covers extreme sports &amp; evacuation.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵35<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1606836591695-4d58a73eba1e?q=80&w=800" alt="General" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-slate-600 uppercase tracking-widest">General</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">All-In-One Cover</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Flexible multi-category protection under one plan.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵60<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">24 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=80&w=800" alt="Health" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-emerald-600 uppercase tracking-widest">Health</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Senior Care Pro</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Specialized coverage for those 55 and above.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵40<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Slide 2 -->
                                        <div class="rec-slide hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 transition-opacity duration-700 opacity-0" data-slide="2">
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800" alt="Auto" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-blue-600 uppercase tracking-widest">Auto</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">FleetGuard Business</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Commercial fleet coverage built for growing businesses.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵75<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">24 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800" alt="Home" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-amber-600 uppercase tracking-widest">Home</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">RentSafe Cover</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Ideal for landlords — protect your rental properties.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵48<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=800" alt="Life" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-rose-600 uppercase tracking-widest">Life</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Term Life Saver</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Affordable term-based life coverage with fixed premiums.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵18<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">60 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1488646015982-5c24939fac3c?q=80&w=800" alt="Travel" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-primary uppercase tracking-widest">Travel</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Business Traveller</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Premium business travel protection with lounge access.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵55<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Slide 3 -->
                                        <div class="rec-slide hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 transition-opacity duration-700 opacity-0" data-slide="3">
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1606836591695-4d58a73eba1e?q=80&w=800" alt="General" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-slate-600 uppercase tracking-widest">General</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Startup Protect</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">All-round business insurance for small-medium enterprises.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵80<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">24 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=80&w=800" alt="Health" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-emerald-600 uppercase tracking-widest">Health</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Dental &amp; Vision Plan</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Specialist dental &amp; optical care included.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵25<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800" alt="Auto" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-blue-600 uppercase tracking-widest">Auto</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Third Party Plus</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Budget-friendly third-party auto liability cover.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵15<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                            <div class="group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative">
                                                    <img src="https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800" alt="Home" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-[9px] font-black text-amber-600 uppercase tracking-widest">Home</div>
                                                </div>
                                                <div class="p-6">
                                                    <h5 class="text-lg font-black text-slate-900">Contents Shield</h5>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-1">Covers household contents, electronics &amp; valuables.</p>
                                                    <div class="mt-4 flex items-center justify-between">
                                                        <span class="text-primary font-black text-xl">GH₵20<span class="text-xs text-slate-400">/mo</span></span>
                                                        <span class="text-[10px] font-black text-slate-400">12 Months</span>
                                                    </div>
                                                    <a href="customer_explore_policies.jsp" class="block w-full mt-6 py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary hover:text-white transition-all">View Details</a>
                                                </div>
                                            </div>
                                        </div>

                                    </div><!-- end carousel -->

                                    <script>
                                        (function() {
                                            const slides = document.querySelectorAll('.rec-slide');
                                            const dots = document.querySelectorAll('.rec-dot');
                                            let current = 0;
                                            const INTERVAL = 15000;

                                            function goTo(index) {
                                                slides[current].classList.add('opacity-0');
                                                setTimeout(() => {
                                                    slides[current].classList.add('hidden');
                                                    slides[current].classList.remove('opacity-0');
                                                    dots[current].classList.remove('bg-primary', 'w-4');
                                                    dots[current].classList.add('bg-slate-200');
                                                    current = index;
                                                    slides[current].classList.remove('hidden');
                                                    // Force reflow for fade-in
                                                    slides[current].getBoundingClientRect();
                                                    slides[current].classList.remove('opacity-0');
                                                    dots[current].classList.add('bg-primary', 'w-4');
                                                    dots[current].classList.remove('bg-slate-200');
                                                }, 400);
                                            }

                                            // Wire up dots
                                            dots.forEach((dot, i) => {
                                                dot.addEventListener('click', () => { clearInterval(timer); goTo(i); timer = setInterval(next, INTERVAL); });
                                            });

                                            function next() { goTo((current + 1) % slides.length); }
                                            var timer = setInterval(next, INTERVAL);
                                        })();
                                    </script>
                                </div>

                            </main>
                                <script>
                                    function switchTab(tab) {
                                        const policyBtn = document.getElementById('tab-policies');
                                        const claimsBtn = document.getElementById('tab-claims');
                                        const transBtn = document.getElementById('tab-transactions');
                                        
                                        const policySection = document.getElementById('section-policies');
                                        const claimsSection = document.getElementById('section-claims');
                                        const transSection = document.getElementById('section-transactions');

                                        // Reset classes
                                        [policyBtn, claimsBtn, transBtn].forEach(btn => {
                                            btn.className = "text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-all duration-300";
                                        });
                                        [policySection, claimsSection, transSection].forEach(sec => {
                                            sec.classList.add('hidden');
                                        });

                                        if (tab === 'policies') {
                                            policyBtn.className = "text-sm font-bold text-primary border-b-2 border-primary pb-3 -mb-1 transition-all duration-300";
                                            policySection.classList.remove('hidden');
                                        } else if (tab === 'claims') {
                                            claimsBtn.className = "text-sm font-bold text-primary border-b-2 border-primary pb-3 -mb-1 transition-all duration-300";
                                            claimsSection.classList.remove('hidden');
                                        } else {
                                            transBtn.className = "text-sm font-bold text-primary border-b-2 border-primary pb-3 -mb-1 transition-all duration-300";
                                            transSection.classList.remove('hidden');
                                        }
                                    }

                                    // Close dropdown when clicking outside
                                    window.onclick = function(event) {
                                        if (!event.target.closest('.group')) {
                                            const dropdown = document.getElementById('notif-dropdown');
                                            if (dropdown && !dropdown.classList.contains('hidden')) {
                                                dropdown.classList.add('hidden');
                                            }
                                        }
                                    }
                                </script>

                                <!-- Manage Policy Modal -->
                                <div id="manageModal" class="hidden fixed inset-0 z-[100] flex items-center justify-center p-4">
                                    <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm" onclick="closeManageModal()"></div>
                                    <div class="bg-white rounded-3xl md:rounded-[2.5rem] w-full max-w-lg relative shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
                                        <div class="p-6 md:p-8 border-b border-slate-50 flex items-center justify-between bg-slate-50/50 shrink-0">
                                            <div>
                                                <h3 class="text-lg md:text-xl font-black text-slate-950">Policy Details</h3>
                                                <p class="text-[10px] md:text-xs text-slate-500 font-bold mt-1">Review and manage your coverage</p>
                                            </div>
                                            <button onclick="closeManageModal()" class="p-2 hover:bg-white rounded-xl transition-colors text-slate-400 hover:text-slate-600">
                                                <span class="material-symbols-outlined">close</span>
                                            </button>
                                        </div>

                                        <div class="overflow-y-auto p-6 md:p-8 space-y-6 flex-1">
                                            <!-- Policy Name Banner -->
                                            <div class="bg-primary/5 rounded-2xl p-6 border border-primary/10">
                                                <p class="text-[10px] font-black uppercase tracking-widest text-primary mb-1">Active Plan</p>
                                                <h4 id="mgPolicyName" class="text-xl font-black text-slate-950">...</h4>
                                                <p id="mgDescription" class="text-xs text-slate-500 mt-1">...</p>
                                            </div>

                                            <!-- Details Grid -->
                                            <div class="grid grid-cols-2 gap-4">
                                                <div class="bg-slate-50 rounded-2xl p-4 text-center">
                                                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Premium</p>
                                                    <p id="mgPremium" class="text-lg font-black text-slate-950">...</p>
                                                </div>
                                                <div class="bg-slate-50 rounded-2xl p-4 text-center">
                                                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Duration</p>
                                                    <p id="mgDuration" class="text-lg font-black text-slate-950">...</p>
                                                </div>
                                                <div class="bg-slate-50 rounded-2xl p-4 text-center">
                                                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Start Date</p>
                                                    <p id="mgStartDate" class="text-sm font-black text-slate-950">...</p>
                                                </div>
                                                <div class="bg-slate-50 rounded-2xl p-4 text-center">
                                                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">End Date</p>
                                                    <p id="mgEndDate" class="text-sm font-black text-slate-950">...</p>
                                                </div>
                                            </div>

                                            <!-- Status Badge -->
                                            <div class="flex items-center justify-between bg-emerald-50 rounded-2xl p-4 border border-emerald-100">
                                                <div class="flex items-center gap-3">
                                                    <div class="h-10 w-10 bg-emerald-100 rounded-xl flex items-center justify-center">
                                                        <span class="material-symbols-outlined text-emerald-600">verified</span>
                                                    </div>
                                                    <div>
                                                        <p class="text-sm font-black text-emerald-700">Coverage Active</p>
                                                        <p class="text-[10px] text-emerald-500 font-bold">Your policy is in good standing</p>
                                                    </div>
                                                </div>
                                                <span id="mgStatus" class="px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full text-[10px] font-black uppercase tracking-tighter">active</span>
                                            </div>

                                            <!-- Action Buttons -->
                                            <div class="space-y-3 pt-2">
                                                <button onclick="closeManageModal()" class="w-full py-4 bg-primary text-white rounded-2xl text-sm font-black shadow-lg shadow-primary/20 hover:scale-[1.02] active:scale-95 transition-all flex items-center justify-center gap-2">
                                                    <span class="material-symbols-outlined text-lg">check_circle</span>
                                                    <span>Done</span>
                                                </button>
                                                <div id="cancelSection">
                                                    <button id="cancelBtn" onclick="showCancelConfirm()" class="w-full py-4 bg-red-50 text-red-500 rounded-2xl text-sm font-black hover:bg-red-100 transition-all flex items-center justify-center gap-2">
                                                        <span class="material-symbols-outlined text-lg">cancel</span>
                                                        <span>Cancel This Policy</span>
                                                    </button>
                                                </div>
                                                <!-- Cancel Confirmation (hidden by default) -->
                                                <div id="cancelConfirm" class="hidden bg-red-50 rounded-2xl p-5 border border-red-100 space-y-3">
                                                    <p class="text-sm font-black text-red-700">Are you sure?</p>
                                                    <p class="text-xs text-red-500">This action cannot be undone. Your coverage will end immediately.</p>
                                                    <div class="flex gap-3 pt-1">
                                                        <button onclick="hideCancelConfirm()" class="flex-1 py-3 bg-white text-slate-600 rounded-xl text-xs font-black border border-slate-200 hover:bg-slate-50 transition-all">Keep Policy</button>
                                                        <form id="cancelForm" action="cancel_policy_process.jsp" method="post" class="flex-1">
                                                            <input type="hidden" id="mgCpId" name="cpId">
                                                            <button type="submit" class="w-full py-3 bg-red-500 text-white rounded-xl text-xs font-black hover:bg-red-600 transition-all">Yes, Cancel</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    function openManageModal(name, desc, premium, startDate, endDate, status, duration, cpId) {
                                        document.getElementById('mgPolicyName').innerText = name;
                                        document.getElementById('mgDescription').innerText = desc;
                                        document.getElementById('mgPremium').innerText = 'GH₵' + premium + '/mo';
                                        document.getElementById('mgStartDate').innerText = startDate;
                                        document.getElementById('mgEndDate').innerText = endDate;
                                        document.getElementById('mgStatus').innerText = status;
                                        document.getElementById('mgDuration').innerText = duration;
                                        document.getElementById('mgCpId').value = cpId;

                                        // Reset cancel confirmation
                                        document.getElementById('cancelConfirm').classList.add('hidden');
                                        document.getElementById('cancelBtn').classList.remove('hidden');

                                        document.getElementById('manageModal').classList.remove('hidden');
                                        document.body.style.overflow = 'hidden';
                                    }

                                    function closeManageModal() {
                                        document.getElementById('manageModal').classList.add('hidden');
                                        document.body.style.overflow = 'auto';
                                    }

                                    function showCancelConfirm() {
                                        document.getElementById('cancelBtn').classList.add('hidden');
                                        document.getElementById('cancelConfirm').classList.remove('hidden');
                                    }

                                    function hideCancelConfirm() {
                                        document.getElementById('cancelConfirm').classList.add('hidden');
                                        document.getElementById('cancelBtn').classList.remove('hidden');
                                    }
                                </script>
                            </body>

                        </html>