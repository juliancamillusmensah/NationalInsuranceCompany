<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    Account currentUser = (Account) sess.getAttribute("user");
    PolicyDAO policyDAO = new PolicyDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    
    List<Policy> allPolicies = policyDAO.getAllPolicies();
    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Policies - NIC Ghana Portal</title>
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
                <a href="superadmin_policies.jsp" class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">verified_user</span>
                    <span class="text-sm">Policies</span>
                </a>
                <a href="superadmin_reports.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">insights</span>
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
        <main class="flex-1 flex flex-col min-h-screen">
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

            <div class="flex-1 p-8 space-y-8">
                <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex flex-col font-display">
                    <div class="p-6 flex items-center justify-between gap-6 border-b border-slate-100">
                        <div>
                            <h3 class="text-lg font-bold text-slate-900">Global Policy Catalog</h3>
                            <p class="text-sm text-slate-500 mt-1 font-medium">Monitoring all active insurance products across nested partners.</p>
                        </div>
                    </div>

                    <!-- Local Search -->
                    <div class="px-6 py-4 bg-slate-50/30 border-b border-slate-100">
                        <div class="relative max-w-lg">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                            <input type="text" id="localSearchInput" placeholder="Filter policies by name or type..." class="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-t border-slate-100">
                                    <th class="px-8 py-5">Policy Name</th>
                                    <th class="px-8 py-5">Category</th>
                                    <th class="px-8 py-5">Premium</th>
                                    <th class="px-8 py-5">Status</th>
                                </tr>
                            </thead>
                            <tbody id="policyTableBody" class="divide-y divide-slate-100">
                                <% if (allPolicies != null) { 
                                    for (Policy p : allPolicies) { 
                                %>
                                <tr class="hover:bg-slate-50/50 transition-colors group search-row">
                                    <td class="px-8 py-6">
                                        <div class="flex items-center gap-4">
                                            <div class="h-12 w-16 rounded-lg overflow-hidden border border-slate-100 bg-slate-50 group-hover:scale-105 transition-transform">
                                                <img src="<%= p.getImageUrl() != null ? p.getImageUrl() : "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=2070" %>" class="h-full w-full object-cover">
                                            </div>
                                            <div>
                                                <span class="text-sm font-bold text-slate-900 block search-target"><%= p.getPolicyName() %></span>
                                                <span class="text-[10px] text-slate-400 font-medium">ID: #POL-<%= p.getId() %></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <span class="px-2.5 py-0.5 rounded-full bg-primary/5 text-primary text-[10px] font-bold uppercase tracking-wider border border-primary/10 search-target">
                                            <%= p.getPolicyType() %>
                                        </span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <span class="text-sm font-black text-slate-900">GH₵<%= p.getPremiumAmount() %></span>
                                        <span class="text-[10px] text-slate-400 font-medium block italic">per <%= p.getCoverageDuration() %></span>
                                    </td>
                                    <td class="px-8 py-6">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-emerald-50 text-emerald-600 rounded-full text-[10px] font-black uppercase tracking-tighter border border-emerald-100">
                                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                                            <%= p.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // UI Toggles
        document.getElementById('sidebarToggle')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });

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

        // Global Search
        document.getElementById('headerSearchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                window.location.href = 'search_results.jsp?q=' + encodeURIComponent(this.value);
            }
        });

        // Local Search
        document.getElementById('localSearchInput')?.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.search-row').forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(term) ? '' : 'none';
            });
        });
    </script>
</body>
</html>
