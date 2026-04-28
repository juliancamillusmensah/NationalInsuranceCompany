<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.insurance.dao.*" %>
        <%@ page import="com.insurance.model.*" %>
            <%@ page import="java.util.*" %>
                <%@ page import="com.insurance.util.ComplianceManager" %>
                <% 
                    HttpSession sess = request.getSession(false);
                    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
                        response.sendRedirect("allloginpage.jsp");
                        return;
                    }
                    
                    Account currentUser = (Account) sess.getAttribute("user");
                    
                    // Phase 6: Automated Regulatory Check
                    ComplianceManager.checkAllCompaniesCompliance(currentUser.getId());
                    CompanyDAO companyDAO = new CompanyDAO(); 
                    PolicyDAO policyDAO = new PolicyDAO(); 
                    NotificationDAO notificationDAO = new NotificationDAO();
                    AccountDAO accountDAO = new AccountDAO();
                    
                    List<Company> companies = companyDAO.getAllCompanies();
                    int pendingKYCCount = accountDAO.getPendingKYCCount();
                    int totalCompanies = companies.size();
                    int activePartners = 0;
                    int lifeCount = 0;
                    int nonLifeCount = 0;
                    int brokerCount = 0;
                    for(Company c : companies) {
                        if("Active".equalsIgnoreCase(c.getStatus())) activePartners++;
                        if("Life".equalsIgnoreCase(c.getCompanyType())) lifeCount++;
                        else if("Non-Life".equalsIgnoreCase(c.getCompanyType())) nonLifeCount++;
                        else if("Broker".equalsIgnoreCase(c.getCompanyType())) brokerCount++;
                    }
                    int networkPolicies = policyDAO.getTotalPolicyCount();
                    
                    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
                    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="utf-8" />
                        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                        <title>NIC Ghana - Regulatory Supervision Portal</title>
                        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
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
                                            "primary": "#059669", /* Emerald-600 */
                                            "primary-dark": "#047857",
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
                                font-size: 24px;
                                vertical-align: middle;
                            }
                        </style>
                    </head>

                    <body class="bg-background-light text-slate-800 antialiased min-h-screen">
                        <div class="flex flex-col lg:flex-row min-h-screen">
                            <!-- Mobile Header -->
                            <div class="lg:hidden bg-white border-b border-slate-200 p-4 flex items-center justify-between sticky top-0 z-50">
                                <div class="flex items-center gap-3">
                                    <div class="bg-primary p-2 rounded-xl text-white">
                                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">security</span>
                                    </div>
                                    <span class="text-xl font-black tracking-tight text-slate-900">NIC Ghana</span>
                                </div>
                                <button onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')" class="p-2 text-slate-500 hover:bg-slate-50 rounded-xl">
                                    <span class="material-symbols-outlined">menu</span>
                                </button>
                            </div>

                            <!-- Sidebar -->
                            <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-slate-200 flex flex-col shrink-0 transform -translate-x-full lg:translate-x-0 lg:static transition-transform duration-300 ease-in-out">
                                <div class="p-6 flex items-center justify-between lg:justify-start gap-3 border-b border-slate-50 lg:border-none">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-primary p-2 rounded-xl text-white shadow-lg shadow-primary/20">
                                            <span class="material-symbols-outlined"
                                                style="font-variation-settings: 'FILL' 1">security</span>
                                        </div>
                                        <span
                                            class="text-xl font-black tracking-tight text-slate-900 leading-none">NIC Ghana</span>
                                    </div>
                                    <button onclick="document.getElementById('sidebar').classList.add('-translate-x-full')" class="lg:hidden p-2 text-slate-400">
                                        <span class="material-symbols-outlined">close</span>
                                    </button>
                                </div>
 
                                <nav class="flex-1 px-4 mt-4 space-y-1">
                                    <a href="Superadmin.jsp"
                                        class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                                        <span
                                            class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">dashboard</span>
                                        <span class="text-sm">Dashboard</span>
                                    </a>
                                    <a href="superadmin_companies.jsp"
                                        class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                                        <span class="material-symbols-outlined text-xl">corporate_fare</span>
                                        <span class="text-sm">Regulated Entities</span>
                                    </a>
                                    <a href="superadmin_policies.jsp"
                                        class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                                        <span
                                            class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">verified_user</span>
                                        <span class="text-sm">Policies</span>
                                    </a>
                                    <a href="superadmin_reports.jsp"
                                        class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                                        <span
                                            class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">insights</span>
                                        <span class="text-sm">Reports</span>
                                    </a>
                                    <a href="superadmin_publications.jsp"
                                        class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                                        <span
                                            class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">library_books</span>
                                        <span class="text-sm">Publications</span>
                                    </a>
                                </nav>
 
                                <div class="p-6 mt-auto border-t border-slate-50">
                                    <a href="${pageContext.request.contextPath}/logout.jsp"
                                        class="flex items-center gap-3 px-3 py-2 w-full text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold">
                                        <span class="material-symbols-outlined text-xl">logout</span>
                                        <span class="text-sm">Sign Out</span>
                                    </a>
                                </div>
                            </aside>

                            <!-- Main Content -->
                            <main class="flex-1 flex flex-col min-h-screen">
                                <!-- Header -->
                                <header
                                    class="h-auto lg:h-16 bg-white border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between px-6 lg:px-8 py-4 lg:py-0 shrink-0 gap-4">
                                    <h2 class="text-lg font-bold text-slate-900 uppercase tracking-tight">Regulatory Supervision Portal</h2>

                                    <div class="flex items-center justify-between lg:justify-end gap-6 w-full lg:w-auto">
                                        <div class="relative w-full lg:w-72">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                                            <input type="text" id="headerSearchInput" placeholder="Search resources..."
                                                class="w-full bg-slate-50 border-none rounded-xl pl-10 pr-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
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
                                                    <div class="p-3 bg-slate-50/50 text-center">
                                                        <a href="#" class="text-[10px] font-bold text-primary hover:underline">View All Alerts</a>
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
                                                        <a href="account_settings.jsp" class="flex items-center gap-3 px-3 py-2 text-slate-600 hover:bg-slate-50 rounded-xl text-xs font-semibold transition-colors">
                                                            <span class="material-symbols-outlined text-lg">manage_accounts</span> Account Settings
                                                        </a>
                                                        <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl text-xs font-semibold transition-colors mt-1">
                                                            <span class="material-symbols-outlined text-lg">logout</span> Sign Out
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </header>

                                <!-- Scrollable Body -->
                                <div class="flex-1 p-6 lg:p-8 space-y-8">
                                    <% if ("1".equals(request.getParameter("success"))) { %>
                                        <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-xl flex items-center gap-3 text-emerald-600 font-bold text-sm">
                                            <span class="material-symbols-outlined">check_circle</span>
                                            Partner organization added successfully!
                                        </div>
                                    <% } %>
                                    <% if (request.getParameter("error") != null) { %>
                                        <div class="p-4 bg-red-50 border border-red-100 rounded-xl flex items-center gap-3 text-red-600 font-bold text-sm">
                                            <span class="material-symbols-outlined">error</span>
                                            Action failed. Please check the logs.
                                        </div>
                                    <% } %>
                                    
                                    <!-- Metrics -->
                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                                        <div
                                            class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm transition-all hover:shadow-md">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="p-3 bg-emerald-50 text-emerald-600 rounded-xl">
                                                    <span class="material-symbols-outlined">corporate_fare</span>
                                                </div>
                                            </div>
                                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">
                                                Regulated Entities</p>
                                            <h3 class="text-3xl font-black text-slate-900 mt-1">
                                                <%= totalCompanies %>
                                            </h3>
                                            <div class="mt-4 flex items-center gap-2">
                                                <div class="flex -space-x-2">
                                                    <div class="w-6 h-6 rounded-full bg-blue-100 border-2 border-white flex items-center justify-center text-[8px] font-black" title="Life"><%= lifeCount %>L</div>
                                                    <div class="w-6 h-6 rounded-full bg-emerald-100 border-2 border-white flex items-center justify-center text-[8px] font-black" title="Non-Life"><%= nonLifeCount %>N</div>
                                                    <div class="w-6 h-6 rounded-full bg-amber-100 border-2 border-white flex items-center justify-center text-[8px] font-black" title="Brokers"><%= brokerCount %>B</div>
                                                </div>
                                                <span class="text-[9px] font-bold text-slate-400 uppercase">Market Mix</span>
                                            </div>
                                        </div>
                                        <div
                                            class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm transition-all hover:shadow-md">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="p-3 bg-emerald-50 text-emerald-600 rounded-xl">
                                                    <span class="material-symbols-outlined"
                                                        style="font-variation-settings: 'FILL' 1">verified</span>
                                                </div>
                                                <span
                                                    class="text-emerald-500 text-[10px] font-black px-2 py-0.5 bg-emerald-50 rounded-lg">LIVE</span>
                                            </div>
                                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">
                                                Licensed Firms</p>
                                            <h3 class="text-3xl font-black text-slate-900 mt-1">
                                                <%= activePartners %>
                                            </h3>
                                            <p class="text-[10px] text-emerald-600 font-bold mt-2">Active Supervision</p>
                                        </div>
                                        <div
                                            class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm transition-all hover:shadow-md">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="p-3 bg-indigo-50 text-indigo-600 rounded-xl">
                                                    <span class="material-symbols-outlined">policy</span>
                                                </div>
                                                <span
                                                    class="text-emerald-500 text-xs font-bold flex items-center gap-0.5">+8.2%
                                                    <span
                                                        class="material-symbols-outlined text-xs">trending_up</span></span>
                                            </div>
                                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">
                                                Network Policies</p>
                                            <h3 class="text-3xl font-black text-slate-900 mt-1">
                                                <%= String.format("%,d", networkPolicies) %>
                                            </h3>
                                        </div>
                                        <a href="superadmin_kyc.jsp"
                                            class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm transition-all hover:shadow-md group">
                                            <div class="flex justify-between items-start mb-4">
                                                <div class="p-3 bg-amber-50 text-amber-600 rounded-xl group-hover:scale-110 transition-transform">
                                                    <span class="material-symbols-outlined">how_to_reg</span>
                                                </div>
                                                <% if (pendingKYCCount > 0) { %>
                                                    <span class="text-amber-600 text-[10px] font-black px-2 py-0.5 bg-amber-50 rounded-lg animate-pulse">ACTION REQ</span>
                                                <% } %>
                                            </div>
                                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">
                                                Pending KYC</p>
                                            <h3 class="text-3xl font-black text-slate-900 mt-1"><%= pendingKYCCount %></h3>
                                            <p class="text-[10px] text-slate-400 font-bold mt-2 hover:text-primary transition-colors flex items-center gap-1">
                                                Verification Queue <span class="material-symbols-outlined text-xs">arrow_forward</span>
                                            </p>
                                        </a>
                                    </div>

                                    <!-- Compliance Alerts Section -->
                                    <% 
                                        List<Company> atRisk = new ArrayList<>();
                                        for(Company c : companies) {
                                            if("At Risk".equalsIgnoreCase(c.getComplianceStatus()) || "Non-Compliant".equalsIgnoreCase(c.getComplianceStatus())) {
                                                atRisk.add(c);
                                            }
                                        }
                                        if(!atRisk.isEmpty()) {
                                    %>
                                    <div class="bg-rose-50/50 border border-rose-100 rounded-2xl p-6">
                                        <div class="flex items-center gap-3 mb-6">
                                            <div class="bg-rose-600 text-white p-2 rounded-lg">
                                                <span class="material-symbols-outlined text-sm">emergency_home</span>
                                            </div>
                                            <div>
                                                <h3 class="text-sm font-black text-slate-900 uppercase tracking-tight">Compliance Heatmap</h3>
                                                <p class="text-[10px] text-rose-600 font-bold uppercase tracking-widest">Immediate Regulatory Attention Required</p>
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                            <% for(Company c : atRisk) { 
                                                boolean isNonCompliant = "Non-Compliant".equalsIgnoreCase(c.getComplianceStatus());
                                                String cardBg = isNonCompliant ? "bg-white border-rose-200" : "bg-white border-amber-200";
                                                String iconColor = isNonCompliant ? "text-rose-600" : "text-amber-600";
                                                String statusText = isNonCompliant ? "EXPIRED" : "EXPIRING SOON";
                                            %>
                                            <div class="<%= cardBg %> border p-4 rounded-xl shadow-sm flex items-center justify-between">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-8 h-8 rounded-lg bg-slate-50 flex items-center justify-center font-bold text-slate-400 border border-slate-100">
                                                        <%= c.getName().substring(0,1) %>
                                                    </div>
                                                    <div>
                                                        <p class="text-xs font-bold text-slate-900"><%= c.getName() %></p>
                                                        <p class="text-[9px] font-black <%= iconColor %> uppercase tracking-widest"><%= statusText %>: <%= c.getLicenseExpiry() %></p>
                                                    </div>
                                                </div>
                                                <a href="superadmin_companies.jsp" class="p-2 bg-slate-50 rounded-lg text-slate-400 hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined text-sm">arrow_forward</span>
                                                </a>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <% } %>

                                    <!-- Companies List Section -->
                                    <div
                                        class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex flex-col">
                                        <div
                                            class="p-6 flex flex-col sm:flex-row sm:items-center justify-between gap-6">
                                            <div>
                                                <h3 class="text-lg font-bold text-slate-900">Insurance Companies</h3>
                                                <p class="text-sm text-slate-500 mt-1 font-medium">Manage and oversee
                                                    all partner organizations in the network.</p>
                                            </div>
                                            <div class="flex items-center gap-3">
                                                <button onclick="window.location.href='export_companies.jsp'"
                                                    class="px-5 py-2 text-sm font-bold text-slate-600 bg-white border border-slate-200 rounded-xl hover:bg-slate-50 flex items-center gap-2 transition-all active:scale-95">
                                                    <span class="material-symbols-outlined text-lg">download</span>
                                                    Export
                                                </button>
                                                <button onclick="document.getElementById('addCompanyModal').classList.remove('hidden')"
                                                    class="px-5 py-2 text-sm font-bold text-white bg-primary rounded-xl hover:bg-primary/90 flex items-center gap-2 shadow-lg shadow-primary/10 transition-all active:scale-95">
                                                    <span class="material-symbols-outlined text-lg">add</span> Add
                                                    Company
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Add Company Modal -->
                                            <div id="addCompanyModal" class="fixed inset-0 z-[100] hidden">
                                                <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity"
                                                    onclick="document.getElementById('addCompanyModal').classList.add('hidden')">
                                                </div>
                                                <div class="flex items-center justify-center min-h-screen p-4">
                                                    <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl p-6 sm:p-8 border border-white/20 max-h-[95vh] overflow-y-auto">
                                                        <div class="flex items-center justify-between mb-6">
                                                            <div class="flex items-center gap-3">
                                                                <div class="bg-primary/10 p-2.5 rounded-xl text-primary">
                                                                    <span class="material-symbols-outlined">corporate_fare</span>
                                                                </div>
                                                                <h3 class="text-xl font-bold text-slate-900">Add New Partner</h3>
                                                            </div>
                                                            <button onclick="document.getElementById('addCompanyModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                                                                <span class="material-symbols-outlined">close</span>
                                                            </button>
                                                        </div>
                                                        <form action="add_company_process.jsp" method="POST" class="space-y-6">
                                                            <input type="hidden" name="redirect" value="Superadmin.jsp">
                                                            <div class="space-y-4">
                                                                <div>
                                                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Company Name</label>
                                                                    <input type="text" name="name" required placeholder="e.g. Global Safe Insurance" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                </div>
                                                                <div class="grid grid-cols-2 gap-4">
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Official Email</label>
                                                                        <input type="email" name="email" required placeholder="contact@company.com" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                    </div>
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Phone Number</label>
                                                                        <input type="text" name="phone" placeholder="+233..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                    </div>
                                                                </div>
                                                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Entity Category</label>
                                                                        <select name="companyType" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                            <option value="Life">Life Insurance</option>
                                                                            <option value="Non-Life" selected>Non-Life Insurance</option>
                                                                            <option value="Reinsurer">Reinsurer</option>
                                                                            <option value="Broker">Broker</option>
                                                                            <option value="Loss Adjuster">Loss Adjuster</option>
                                                                            <option value="Agent">Agent</option>
                                                                        </select>
                                                                    </div>
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Number</label>
                                                                        <input type="text" name="licenseNumber" placeholder="NIC-..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                    </div>
                                                                </div>
                                                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Regulatory Status</label>
                                                                        <select name="complianceStatus" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                            <option value="Compliant">Compliant</option>
                                                                            <option value="At Risk">At Risk</option>
                                                                            <option value="Non-Compliant">Non-Compliant</option>
                                                                        </select>
                                                                    </div>
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">TIN (Tax ID)</label>
                                                                        <input type="text" name="tin" placeholder="P00..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                    </div>
                                                                </div>
                                                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Portal Account</label>
                                                                        <select name="status" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                            <option value="Active">Active</option>
                                                                            <option value="Pending">Pending</option>
                                                                            <option value="Inactive">Inactive</option>
                                                                        </select>
                                                                    </div>
                                                                    <div>
                                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Expiry</label>
                                                                        <input type="date" name="licenseExpiry" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                                    </div>
                                                                </div>
                                                                <div>
                                                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Headquarters Address</label>
                                                                    <textarea name="address" rows="3" placeholder="Full legal address..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20"></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="flex items-center gap-3 pt-4">
                                                                <button type="button" onclick="document.getElementById('addCompanyModal').classList.add('hidden')" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                                                <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-primary rounded-xl shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all active:scale-95">Establish Partnership</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                        <!-- Filters Header -->
                                        <div
                                            class="px-6 py-4 border-t border-slate-100 bg-slate-50/30 flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                                            <div class="relative flex-1 max-w-lg">
                                                <span
                                                    class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                                                <input type="text" id="companySearch" placeholder="Search companies..."
                                                    class="w-full pl-10 pr-4 py-2 border-slate-200 rounded-xl text-sm focus:ring-primary focus:border-primary bg-white">
                                            </div>
                                        </div>

                                        <!-- Table -->
                                        <div class="overflow-x-auto">
                                            <table class="w-full text-left">
                                                <thead>
                                                    <tr
                                                        class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-t border-slate-100">
                                                        <th class="px-8 py-5">Regulated Entity</th>
                                                        <th class="px-8 py-5">Contact Details</th>
                                                        <th class="px-8 py-5">Category</th>
                                                        <th class="px-8 py-5 text-right">Regulatory Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="divide-y divide-slate-100" id="companyTableBody">
                                                    <% for (Company c : companies) { boolean isActive="Active"
                                                        .equalsIgnoreCase(c.getStatus()); String statusBg=isActive
                                                        ? "bg-emerald-50 text-emerald-600"
                                                        : "bg-slate-50 text-slate-400" ; String dotColor=isActive
                                                        ? "bg-emerald-500" : "bg-slate-400" ; String
                                                        borderColor=isActive ? "border-emerald-100" : "border-slate-100"
                                                        ; %>
                                                        <tr class="hover:bg-slate-50/50 transition-colors group">
                                                            <td class="px-8 py-6">
                                                                <div class="flex items-center gap-4">
                                                                    <div
                                                                        class="h-10 w-10 rounded-xl bg-primary/5 flex items-center justify-center text-primary font-black border border-primary/10 group-hover:scale-110 transition-transform">
                                                                        <%= c.getName().substring(0, 1) %>
                                                                    </div>
                                                                    <span class="text-sm font-bold text-slate-900 search-target">
                                                                        <%= c.getName() %>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="px-8 py-6">
                                                                <div class="flex flex-col">
                                                                    <span
                                                                        class="text-xs font-bold text-primary hover:underline cursor-pointer">
                                                                        <%= c.getEmail() %>
                                                                    </span>
                                                                    <span
                                                                        class="text-xs font-medium text-slate-400 mt-1">
                                                                        <%= c.getPhoneNumber() %>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="px-8 py-6">
                                                                <span
                                                                    class="inline-flex items-center gap-1.5 px-3 py-1 bg-slate-50 text-slate-600 rounded-full text-[10px] font-black uppercase tracking-tighter border border-slate-100 mb-1">
                                                                    <%= c.getCompanyType() %>
                                                                </span>
                                                            </td>
                                                            <td class="px-8 py-6 text-right">
                                                                <% 
                                                                    String compStatus = c.getComplianceStatus();
                                                                    String compBg = "bg-emerald-50 text-emerald-600 border-emerald-100";
                                                                    String compDot = "bg-emerald-500";
                                                                    if("At Risk".equalsIgnoreCase(compStatus)) {
                                                                        compBg = "bg-amber-50 text-amber-600 border-amber-100";
                                                                        compDot = "bg-amber-500";
                                                                    } else if("Non-Compliant".equalsIgnoreCase(compStatus)) {
                                                                        compBg = "bg-rose-50 text-rose-600 border-rose-100";
                                                                        compDot = "bg-rose-500";
                                                                    }
                                                                %>
                                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 <%= compBg %> rounded-full text-[10px] font-black uppercase tracking-tighter border">
                                                                    <span class="w-1.5 h-1.5 rounded-full <%= compDot %>"></span>
                                                                    <%= compStatus %>
                                                                </span>
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
                            // Dropdown Toggles
                            function setupDropdown(btnId, dropdownId) {
                                const btn = document.getElementById(btnId);
                                const dropdown = document.getElementById(dropdownId);
                                if (!btn || !dropdown) return;

                                btn.addEventListener('click', (e) => {
                                    e.stopPropagation();
                                    const isHidden = dropdown.classList.contains('hidden');
                                    // Close all dropdowns
                                    document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
                                    if (isHidden) dropdown.classList.remove('hidden');
                                });
                            }

                            setupDropdown('notificationBtn', 'notificationDropdown');
                            setupDropdown('profileBtn', 'profileDropdown');

                            window.addEventListener('click', () => {
                                document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
                            });

                            // Global Search
                            document.getElementById('headerSearchInput').addEventListener('keypress', function(e) {
                                if (e.key === 'Enter') {
                                    window.location.href = 'search_results.jsp?q=' + encodeURIComponent(this.value);
                                }
                            });

                            // Local Company Search
                            document.getElementById('companySearch').addEventListener('input', function(e) {
                                const term = e.target.value.toLowerCase();
                                const rows = document.querySelectorAll('#companyTableBody tr');
                                
                                rows.forEach(row => {
                                    const target = row.querySelector('.search-target');
                                    if (target) {
                                        const text = target.textContent.toLowerCase();
                                        row.style.display = text.includes(term) ? '' : 'none';
                                    }
                                });
                            });
                        </script>
                    </body>

                    </html>