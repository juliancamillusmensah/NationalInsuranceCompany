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
    
    // Quick Infrastructure Stats
    Map<String, Integer> counts = new HashMap<>();
    String[] tables = {"Account", "policies", "transactions", "claims", "insurance_companies", "system_logs"};
    try (Connection conn = DBConnection.getConnection()) {
        for (String table : tables) {
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + table)) {
                if (rs.next()) counts.put(table, rs.getInt(1));
            }
        }
    } catch (SQLException e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>System Status - Master Config</title>
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
                <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_logs.jsp">
                    <span class="material-symbols-outlined text-xl">history_edu</span> Activity Logs
                </a>
                <div class="pt-6">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">Infrastructure</p>
                    <a class="flex items-center gap-3 px-3 py-2 text-primary bg-primary/10 rounded-xl font-bold transition-all" href="system_status.jsp">
                        <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">database</span> Database Status
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
                Infrastructure Health
            </header>

            <div class="flex-1 p-4 lg:p-10">
                <div class="mb-10">
                    <h1 class="text-3xl font-black text-slate-900 tracking-tight">System Status</h1>
                    <p class="text-slate-500 mt-1 font-medium">Real-time monitoring of database tables and platform resources.</p>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 lg:gap-8">
                    <% for (String table : tables) { %>
                    <div class="bg-white p-5 lg:p-8 rounded-3xl border border-slate-100 shadow-sm">
                        <div class="flex items-center justify-between mb-6">
                            <div class="bg-slate-50 p-3 rounded-2xl text-slate-400">
                                <span class="material-symbols-outlined">table_chart</span>
                            </div>
                            <span class="text-[10px] font-black text-emerald-500 uppercase tracking-widest bg-emerald-50 px-3 py-1 rounded-full">Active</span>
                        </div>
                        <h3 class="text-lg font-black text-slate-900 mb-1"><%= table %></h3>
                        <p class="text-4xl font-black text-primary"><%= counts.getOrDefault(table, 0) %></p>
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-4">Total Row Count</p>
                    </div>
                    <% } %>
                </div>

                <div class="mt-8 lg:mt-12 bg-slate-900 rounded-3xl p-6 lg:p-10 text-white relative overflow-hidden">
                    <div class="relative z-10">
                        <h2 class="text-xl lg:text-2xl font-black mb-2">Database Engine: SQLite 3</h2>
                        <p class="text-slate-400 font-medium max-w-lg mb-6 lg:mb-8 text-sm">Direct file-based persistence at <code class="bg-white/10 px-2 py-1 rounded text-white font-mono text-xs">WEB-INF/database/NIC_insurance.db</code>. Optimal for current platform scale.</p>
                        <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4 sm:gap-6">
                            <div class="flex flex-col">
                                <span class="text-xs font-black text-slate-500 uppercase tracking-widest mb-1">Last Backup</span>
                                <span class="text-sm font-bold">Automated (Daily 02:00)</span>
                            </div>
                            <div class="w-px h-10 bg-white/10 hidden sm:block"></div>
                            <div class="flex flex-col">
                                <span class="text-xs font-black text-slate-500 uppercase tracking-widest mb-1">Encryption</span>
                                <span class="text-sm font-bold">SHA-256 (Passwords)</span>
                            </div>
                        </div>
                    </div>
                    <span class="material-symbols-outlined absolute right-[-20px] bottom-[-20px] text-[200px] text-white/5 pointer-events-none">storage</span>
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
