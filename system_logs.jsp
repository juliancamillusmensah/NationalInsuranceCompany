<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.*" %>
<% 
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SYSTEM_CREATOR".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    SystemDAO systemDAO = new SystemDAO();
    List<SystemLog> logs = systemDAO.getGlobalActivityLogs(50);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Global Activity Logs - Master Config</title>
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
                <a class="flex items-center gap-3 px-3 py-2 text-primary bg-primary/10 rounded-xl font-bold transition-all" href="system_logs.jsp">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">history_edu</span> Activity Logs
                </a>
                <div class="pt-6">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">Infrastructure</p>
                    <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_status.jsp">
                        <span class="material-symbols-outlined text-xl">database</span> Database Status
                    </a>
                    <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_audit.jsp">
                        <span class="material-symbols-outlined text-xl">security</span> Security Audit
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-h-screen min-w-0 overflow-hidden">
            <header class="h-auto lg:h-16 bg-white border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between px-6 lg:px-8 py-4 lg:py-0 shrink-0 gap-4 font-black text-slate-400 uppercase tracking-widest text-sm">
                Global Audit Trail
            </header>

            <div class="flex-1 p-4 lg:p-10">
                <div class="mb-10">
                    <h1 class="text-3xl font-black text-slate-900 tracking-tight">System Activity Logs</h1>
                    <p class="text-slate-500 mt-1 font-medium">Platform-wide events and administrative actions tracking.</p>
                </div>

                <div class="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-b border-slate-50">
                                    <th class="px-3 lg:px-8 py-4 lg:py-6">Timestamp</th>
                                    <th class="px-3 lg:px-8 py-4 lg:py-6 hidden sm:table-cell">User ID</th>
                                    <th class="px-3 lg:px-8 py-4 lg:py-6">Type</th>
                                    <th class="px-3 lg:px-8 py-4 lg:py-6">Activity</th>
                                    <th class="px-3 lg:px-8 py-4 lg:py-6 hidden md:table-cell">Impact</th>
                                    <th class="px-3 lg:px-8 py-4 lg:py-6 hidden lg:table-cell">Details</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50 font-medium text-xs">
                                <% for (SystemLog log : logs) { 
                                    String typeColor = "bg-slate-100 text-slate-600";
                                    if ("config".equalsIgnoreCase(log.getType())) typeColor = "bg-blue-50 text-blue-600";
                                    if ("access".equalsIgnoreCase(log.getType())) typeColor = "bg-emerald-50 text-emerald-600";
                                    if ("security".equalsIgnoreCase(log.getType())) typeColor = "bg-amber-50 text-amber-600";
                                    if ("error".equalsIgnoreCase(log.getType())) typeColor = "bg-red-50 text-red-600";
                                %>
                                <tr class="hover:bg-slate-50/30 transition-colors">
                                    <td class="px-3 lg:px-8 py-3 lg:py-5 text-slate-400 whitespace-nowrap"><%= log.getTimestamp() %></td>
                                    <td class="px-3 lg:px-8 py-3 lg:py-5 font-black text-slate-900 hidden sm:table-cell"><%= log.getUserId() %></td>
                                    <td class="px-3 lg:px-8 py-3 lg:py-5">
                                        <span class="px-2 py-1 rounded-md <%= typeColor %> uppercase font-black text-[9px] tracking-widest">
                                            <%= log.getType() %>
                                        </span>
                                    </td>
                                    <td class="px-3 lg:px-8 py-3 lg:py-5 font-bold"><%= log.getActivity() %></td>
                                    <td class="px-3 lg:px-8 py-3 lg:py-5 hidden md:table-cell">
                                        <% String impactColor = "text-slate-400";
                                           if ("high".equalsIgnoreCase(log.getImpact())) impactColor = "text-red-500";
                                           if ("medium".equalsIgnoreCase(log.getImpact())) impactColor = "text-amber-500";
                                        %>
                                        <span class="font-black uppercase tracking-widest <%= impactColor %>"><%= log.getImpact() %></span>
                                    </td>
                                    <td class="px-3 lg:px-8 py-3 lg:py-5 text-slate-500 font-mono hidden lg:table-cell"><%= log.getDetails() %></td>
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
