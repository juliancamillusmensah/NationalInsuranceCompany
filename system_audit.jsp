<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<% 
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SYSTEM_CREATOR".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    Account currentUser = (Account) sess.getAttribute("user");
    SystemDAO systemDAO = new SystemDAO();
    
    // Fetch security-related logs
    List<SystemLog> securityLogs = new ArrayList<>();
    List<SystemLog> allLogs = systemDAO.getGlobalActivityLogs(100);
    for (SystemLog log : allLogs) {
        if ("security".equalsIgnoreCase(log.getType()) || "access".equalsIgnoreCase(log.getType()) || "error".equalsIgnoreCase(log.getType())) {
            securityLogs.add(log);
        }
    }

    // Fetch account stats
    int totalAccounts = 0;
    int activeAccounts = 0;
    int deactivatedAccounts = 0;
    int failedLogins = 0;
    try (Connection conn = DBConnection.getConnection()) {
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Account")) {
            if (rs.next()) totalAccounts = rs.getInt(1);
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Account WHERE status = 'active'")) {
            if (rs.next()) activeAccounts = rs.getInt(1);
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Account WHERE status = 'deactivated'")) {
            if (rs.next()) deactivatedAccounts = rs.getInt(1);
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM system_logs WHERE type = 'error'")) {
            if (rs.next()) failedLogins = rs.getInt(1);
        }
    } catch (SQLException e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Security Audit - Master Config</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#1152d4",
                        "background-light": "#f6f6f8",
                    },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-size: 24px; vertical-align: middle; }
    </style>
</head>
<body class="bg-background-light text-slate-900 font-display min-h-screen">
    <!-- Sidebar Backdrop -->
    <div id="sidebarBackdrop" onclick="toggleSidebar()" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-40 hidden lg:hidden transition-opacity duration-300 opacity-0"></div>

    <div class="flex flex-col lg:flex-row min-h-screen">
        <!-- Mobile Header -->
        <div class="lg:hidden bg-white border-b border-slate-200 p-4 flex items-center justify-between sticky top-0 z-50">
            <div class="flex items-center gap-3">
                <div class="bg-primary p-2 rounded-lg text-white">
                    <span class="material-symbols-outlined">settings_suggest</span>
                </div>
                <span class="text-lg font-bold tracking-tight text-slate-900">Master Config</span>
            </div>
            <button onclick="toggleSidebar()" class="p-2 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">
                <span class="material-symbols-outlined">menu</span>
            </button>
        </div>

        <!-- Sidebar -->
        <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-slate-200 flex flex-col shrink-0 transform -translate-x-full lg:translate-x-0 lg:static transition-transform duration-300 ease-in-out shadow-2xl lg:shadow-none">
            <div class="p-6 border-b border-slate-100 flex items-center justify-between lg:justify-start gap-3">
                <div class="flex items-center gap-3">
                    <div class="bg-primary p-2 rounded-lg text-white">
                        <span class="material-symbols-outlined">settings_suggest</span>
                    </div>
                    <span class="text-lg font-bold tracking-tight text-slate-900">Master Config</span>
                </div>
                <button onclick="toggleSidebar()" class="lg:hidden p-2 text-slate-400 hover:bg-slate-50 rounded-xl transition-colors">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <nav class="flex-1 overflow-y-auto p-4 space-y-1">
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">Core Management</p>
                <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="Systemcreator.jsp">
                    <span class="material-symbols-outlined text-xl">settings</span> System Settings
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_roles.jsp">
                    <span class="material-symbols-outlined text-xl">verified_user</span> Roles & Permissions
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_logs.jsp">
                    <span class="material-symbols-outlined text-xl">history_edu</span> Activity Logs
                </a>
                <div class="pt-6">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">Infrastructure</p>
                    <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_status.jsp">
                        <span class="material-symbols-outlined text-xl">database</span> Database Status
                    </a>
                    <a class="flex items-center gap-3 px-3 py-2 text-primary bg-primary/10 rounded-xl font-bold transition-all" href="system_audit.jsp">
                        <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">security</span> Security Audit
                    </a>
                </div>
            </nav>
            <div class="p-4 border-t border-slate-100">
                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl font-semibold transition-all">
                    <span class="material-symbols-outlined text-xl">logout</span> Sign Out
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-h-screen min-w-0 overflow-hidden">
            <header class="h-auto lg:h-16 bg-white border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between px-6 lg:px-8 py-4 lg:py-0 shrink-0 gap-4">
                <h2 class="text-sm font-black text-slate-400 uppercase tracking-widest">Security & Compliance</h2>
                <div class="flex items-center gap-3">
                    <div class="flex items-center gap-2 bg-emerald-50 text-emerald-600 px-3 py-1.5 rounded-full">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="text-[10px] font-black uppercase tracking-widest">All Systems Nominal</span>
                    </div>
                </div>
            </header>

            <div class="flex-1 p-4 lg:p-10 overflow-x-hidden">
                <div class="mb-8 lg:mb-10">
                    <h1 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tight">Security Audit</h1>
                    <p class="text-slate-500 mt-1 font-medium">Monitor account security, access patterns, and threat indicators across the platform.</p>
                </div>

                <!-- Security Stats -->
                <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 lg:gap-6 mb-8 lg:mb-10">
                    <div class="bg-white p-5 lg:p-6 rounded-3xl border border-slate-100 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-primary/5 text-primary p-3 rounded-2xl">
                                <span class="material-symbols-outlined">group</span>
                            </div>
                            <span class="text-[10px] font-black text-emerald-500 uppercase tracking-widest bg-emerald-50 px-2 py-1 rounded-full">Healthy</span>
                        </div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest">Total Accounts</p>
                        <p class="text-3xl font-black text-slate-900 mt-1"><%= totalAccounts %></p>
                    </div>
                    <div class="bg-white p-5 lg:p-6 rounded-3xl border border-slate-100 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-emerald-50 text-emerald-600 p-3 rounded-2xl">
                                <span class="material-symbols-outlined">check_circle</span>
                            </div>
                        </div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest">Active Accounts</p>
                        <p class="text-3xl font-black text-emerald-600 mt-1"><%= activeAccounts %></p>
                    </div>
                    <div class="bg-white p-5 lg:p-6 rounded-3xl border border-slate-100 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-amber-50 text-amber-600 p-3 rounded-2xl">
                                <span class="material-symbols-outlined">block</span>
                            </div>
                            <% if (deactivatedAccounts > 0) { %>
                            <span class="text-[10px] font-black text-amber-500 uppercase tracking-widest bg-amber-50 px-2 py-1 rounded-full">Attention</span>
                            <% } %>
                        </div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest">Deactivated</p>
                        <p class="text-3xl font-black text-amber-600 mt-1"><%= deactivatedAccounts %></p>
                    </div>
                    <div class="bg-white p-5 lg:p-6 rounded-3xl border border-slate-100 shadow-sm">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-red-50 text-red-500 p-3 rounded-2xl">
                                <span class="material-symbols-outlined">warning</span>
                            </div>
                            <% if (failedLogins > 0) { %>
                            <span class="text-[10px] font-black text-red-500 uppercase tracking-widest bg-red-50 px-2 py-1 rounded-full">Review</span>
                            <% } %>
                        </div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest">Error Events</p>
                        <p class="text-3xl font-black text-red-500 mt-1"><%= failedLogins %></p>
                    </div>
                </div>

                <!-- Security Posture Banner -->
                <div class="bg-slate-900 rounded-3xl p-6 lg:p-8 text-white relative overflow-hidden mb-8 lg:mb-10">
                    <div class="relative z-10">
                        <div class="flex flex-col sm:flex-row sm:items-center gap-4 mb-4">
                            <div class="bg-emerald-500/20 p-3 rounded-2xl">
                                <span class="material-symbols-outlined text-emerald-400 text-3xl" style="font-variation-settings: 'FILL' 1">shield</span>
                            </div>
                            <div>
                                <h2 class="text-xl lg:text-2xl font-black">Platform Security Posture</h2>
                                <p class="text-slate-400 text-sm font-medium">SHA-256 password hashing · Role-based access control · Session-based authentication</p>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-6">
                            <div class="bg-white/5 border border-white/10 rounded-2xl p-4">
                                <span class="text-[10px] font-black text-slate-500 uppercase tracking-widest">Authentication</span>
                                <p class="text-sm font-bold mt-1 text-emerald-400">Session-Based (HttpSession)</p>
                            </div>
                            <div class="bg-white/5 border border-white/10 rounded-2xl p-4">
                                <span class="text-[10px] font-black text-slate-500 uppercase tracking-widest">Encryption</span>
                                <p class="text-sm font-bold mt-1 text-emerald-400">SHA-256 + Salt</p>
                            </div>
                            <div class="bg-white/5 border border-white/10 rounded-2xl p-4">
                                <span class="text-[10px] font-black text-slate-500 uppercase tracking-widest">Access Model</span>
                                <p class="text-sm font-bold mt-1 text-emerald-400">RBAC (6 Roles)</p>
                            </div>
                        </div>
                    </div>
                    <span class="material-symbols-outlined absolute right-[-20px] bottom-[-20px] text-[200px] text-white/5 pointer-events-none">security</span>
                </div>

                <!-- Security Events Table -->
                <div class="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
                    <div class="p-5 lg:p-6 border-b border-slate-50 bg-slate-50/30 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <h2 class="font-black text-slate-900 flex items-center gap-3">
                            <span class="material-symbols-outlined text-slate-400">shield</span>
                            Security Events
                        </h2>
                        <span class="text-xs font-bold text-slate-400"><%= securityLogs.size() %> events found</span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-[600px] w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-b border-slate-50">
                                    <th class="px-4 lg:px-6 py-4 lg:py-5">Timestamp</th>
                                    <th class="px-4 lg:px-6 py-4 lg:py-5">Type</th>
                                    <th class="px-4 lg:px-6 py-4 lg:py-5">Event</th>
                                    <th class="px-4 lg:px-6 py-4 lg:py-5 hidden md:table-cell">Impact</th>
                                    <th class="px-4 lg:px-6 py-4 lg:py-5 hidden lg:table-cell">Details</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50 font-medium text-xs">
                                <% if (securityLogs.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="px-6 py-16 text-center">
                                        <div class="flex flex-col items-center gap-3">
                                            <div class="bg-emerald-50 p-4 rounded-2xl text-emerald-500">
                                                <span class="material-symbols-outlined text-4xl" style="font-variation-settings: 'FILL' 1">verified_user</span>
                                            </div>
                                            <p class="text-sm font-black text-slate-900">All Clear</p>
                                            <p class="text-slate-400 font-medium">No security events have been recorded. The platform is operating normally.</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { 
                                    for (SystemLog log : securityLogs) { 
                                        String typeColor = "bg-slate-100 text-slate-600";
                                        String typeIcon = "info";
                                        if ("security".equalsIgnoreCase(log.getType())) { typeColor = "bg-amber-50 text-amber-600"; typeIcon = "shield"; }
                                        else if ("access".equalsIgnoreCase(log.getType())) { typeColor = "bg-blue-50 text-blue-600"; typeIcon = "login"; }
                                        else if ("error".equalsIgnoreCase(log.getType())) { typeColor = "bg-red-50 text-red-600"; typeIcon = "error"; }
                                        
                                        String impactColor = "text-slate-400";
                                        if ("high".equalsIgnoreCase(log.getImpact())) impactColor = "text-red-500";
                                        if ("medium".equalsIgnoreCase(log.getImpact())) impactColor = "text-amber-500";
                                %>
                                <tr class="hover:bg-slate-50/30 transition-colors">
                                    <td class="px-4 lg:px-6 py-3 lg:py-4 text-slate-400 whitespace-nowrap"><%= log.getTimestamp() %></td>
                                    <td class="px-4 lg:px-6 py-3 lg:py-4">
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg <%= typeColor %> uppercase font-black text-[9px] tracking-widest">
                                            <span class="material-symbols-outlined text-xs"><%= typeIcon %></span>
                                            <%= log.getType() %>
                                        </span>
                                    </td>
                                    <td class="px-4 lg:px-6 py-3 lg:py-4 font-bold text-slate-900"><%= log.getActivity() %></td>
                                    <td class="px-4 lg:px-6 py-3 lg:py-4 hidden md:table-cell">
                                        <span class="font-black uppercase tracking-widest <%= impactColor %>"><%= log.getImpact() %></span>
                                    </td>
                                    <td class="px-4 lg:px-6 py-3 lg:py-4 text-slate-500 font-mono hidden lg:table-cell"><%= log.getDetails() %></td>
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
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const backdrop = document.getElementById('sidebarBackdrop');
            const isHidden = sidebar.classList.contains('-translate-x-full');
            
            if (isHidden) {
                sidebar.classList.remove('-translate-x-full');
                backdrop.classList.remove('hidden');
                setTimeout(() => backdrop.classList.add('opacity-100'), 10);
            } else {
                sidebar.classList.add('-translate-x-full');
                backdrop.classList.remove('opacity-100');
                setTimeout(() => backdrop.classList.add('hidden'), 300);
            }
        }
    </script>
</body>
</html>
