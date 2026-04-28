<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
    <%@ page import="com.insurance.dao.*" %>
        <%@ page import="com.insurance.model.*" %>
            <%@ page import="java.util.*" %>
                <% 
                    HttpSession sess = request.getSession(false);
                    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SYSTEM_CREATOR".equals(sess.getAttribute("roleId"))) {
                        response.sendRedirect("allloginpage.jsp");
                        return;
                    }
                    
                    // Defaults for robustness
                    List<SystemSetting> allSettings = new ArrayList<>();
                    List<SystemLog> globalLogs = new ArrayList<>();
                    List<Role> roles = new ArrayList<>();
                    List<Permission> perms = new ArrayList<>();
                    Map<String, List<String>> rolePermsMap = new HashMap<>();
                    int activeSettings = 0;
                    String criticalError = null;
                    
                    try {
                        SystemDAO systemDAO = new SystemDAO();
                        activeSettings = systemDAO.getSettingsCount();
                        allSettings = systemDAO.getAllSystemSettings();
                        globalLogs = systemDAO.getGlobalActivityLogs(10);
                        roles = systemDAO.getAllRoles();
                        perms = systemDAO.getAllPermissions();
                        rolePermsMap = systemDAO.getRolePermissionsMap();
                    } catch (Exception e) {
                        criticalError = e.getMessage();
                        e.printStackTrace();
                    }
                    
                    Account currentUser = (Account) sess.getAttribute("user");
                %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="utf-8" />
                        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                        <title>System Creator - Master Config</title>
                        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap"
                            rel="stylesheet" />
                        <link
                            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                            rel="stylesheet" />
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
                            body {
                                font-family: 'Inter', sans-serif;
                            }

                            .material-symbols-outlined {
                                font-size: 24px;
                                vertical-align: middle;
                            }
                        </style>
                    </head>

                    <body class="bg-background-light text-slate-900 font-display min-h-screen">
                        <% if (criticalError != null) { %>
                        <div class="fixed top-2 left-1/2 -translate-x-1/2 z-[100] w-full max-w-2xl">
                            <div class="bg-red-600 text-white p-4 rounded-b-2xl shadow-2xl flex items-center gap-4 animate-bounce">
                                <span class="material-symbols-outlined">warning</span>
                                <div>
                                    <p class="font-black text-xs uppercase tracking-widest">Master Config Error</p>
                                    <p class="text-sm opacity-90 font-medium"><%= criticalError %></p>
                                </div>
                            </div>
                        </div>
                        <% } %>
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
                                    <p
                                        class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">
                                        Core Management</p>
                                    <a class="flex items-center gap-3 px-3 py-2 text-primary bg-primary/10 rounded-xl font-bold transition-all"
                                        href="Systemcreator.jsp">
                                        <span class="material-symbols-outlined text-xl"
                                            style="font-variation-settings: 'FILL' 1">settings</span>
                                        System Settings
                                    </a>
                                    <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                        href="system_roles.jsp">
                                        <span class="material-symbols-outlined text-xl">verified_user</span>
                                        Roles & Permissions
                                    </a>
                                    <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                        href="system_logs.jsp">
                                        <span class="material-symbols-outlined text-xl">history_edu</span>
                                        Activity Logs
                                    </a>

                                    <div class="pt-6">
                                        <p
                                            class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-3 mb-2">
                                            Infrastructure</p>
                                        <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                            href="system_status.jsp">
                                            <span class="material-symbols-outlined text-xl">database</span>
                                            Database Status
                                        </a>
                                        <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                            href="system_audit.jsp">
                                            <span class="material-symbols-outlined text-xl">security</span>
                                            Security Audit
                                        </a>
                                        <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                            href="email_settings.jsp">
                                            <span class="material-symbols-outlined text-xl">mail</span>
                                            Email Settings
                                        </a>
                                        <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                            href="paystack_settings.jsp">
                                            <span class="material-symbols-outlined text-xl">credit_card</span>
                                            Paystack Settings
                                        </a>
                                        <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all"
                                            href="sms_settings.jsp">
                                            <span class="material-symbols-outlined text-xl">sms</span>
                                            SMS Settings
                                        </a>
                                    </div>
                                </nav>
                                <div class="p-4 border-t border-slate-100">
                                    <div
                                        class="flex items-center gap-3 px-2 bg-slate-50 p-3 rounded-2xl border border-slate-100">
                                        <div
                                            class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary font-black text-xs shadow-sm">
                                            AD</div>
                                        <div class="flex items-center justify-between w-full min-w-0">
                                            <div class="flex flex-col min-w-0">
                                                <span class="text-sm font-bold text-slate-900 truncate">Admin User</span>
                                                <span
                                                    class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider leading-none">Super
                                                    Admin</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/logout.jsp" class="h-10 w-10 flex items-center justify-center rounded-xl bg-slate-800 text-slate-400 hover:text-red-500 hover:bg-red-500/10 transition-all duration-300" title="Sign Out">
                                                <span class="material-symbols-outlined text-xl">logout</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </aside>

                            <!-- Main Content -->
                            <main class="flex-1 flex flex-col min-h-screen min-w-0 overflow-hidden">
                                <!-- Header -->
                                <header
                                    class="h-auto lg:h-16 bg-white border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between px-6 lg:px-8 py-4 lg:py-0 shrink-0 gap-4">
                                    <div class="flex items-center flex-1 max-w-xl w-full">
                                        <div class="relative w-full">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                            <input type="text" id="headerSearch" placeholder="Search keys, roles, or logs..."
                                                oninput="filterAll(this.value)"
                                                class="w-full bg-slate-50 border-none rounded-xl pl-10 pr-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between lg:justify-end gap-4 w-full lg:w-auto">
                                        <div class="flex items-center gap-4">
                                            <div class="relative">
                                                <button onclick="toggleNotifications()" class="p-2 text-slate-400 hover:bg-slate-50 rounded-full relative">
                                                    <span class="material-symbols-outlined">notifications</span>
                                                    <span
                                                        class="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full border-2 border-white font-black"></span>
                                                </button>
                                                <!-- Notifications Dropdown -->
                                                <div id="notificationsDropdown" class="fixed lg:absolute right-4 lg:right-0 top-16 lg:top-12 z-50 w-80 bg-white rounded-3xl shadow-2xl border border-slate-100 hidden p-2">
                                                    <div class="p-4 border-b border-slate-50 flex items-center justify-between">
                                                        <h4 class="font-black text-slate-900 text-sm">Recent Activity</h4>
                                                        <span class="text-[10px] font-black text-primary uppercase tracking-widest bg-primary/5 px-2 py-1 rounded-lg">New Logs</span>
                                                    </div>
                                                    <div class="max-h-96 overflow-y-auto">
                                                        <% for (SystemLog log : globalLogs) { %>
                                                        <div class="p-4 hover:bg-slate-50 transition-colors rounded-2xl group">
                                                            <div class="flex gap-3">
                                                                <div class="shrink-0 w-8 h-8 rounded-xl flex items-center justify-center <%= "security".equalsIgnoreCase(log.getType()) ? "bg-red-50 text-red-500" : "bg-primary/5 text-primary" %>">
                                                                    <span class="material-symbols-outlined text-sm"><%= "security".equalsIgnoreCase(log.getType()) ? "shield" : "history_edu" %></span>
                                                                </div>
                                                                <div class="flex-1">
                                                                    <p class="text-xs font-bold text-slate-900 leading-tight mb-1"><%= log.getActivity() %></p>
                                                                    <p class="text-[10px] text-slate-500 line-clamp-2"><%= log.getDetails() %></p>
                                                                    <p class="text-[10px] font-black text-slate-400 mt-2 uppercase tracking-widest"><%= log.getTimestamp() %></p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                    </div>
                                                    <a href="system_logs.jsp" class="block p-4 text-center text-xs font-black text-primary border-t border-slate-50 hover:bg-slate-50 transition-all rounded-b-2xl">View All Logs</a>
                                                </div>
                                            </div>
                                            <button onclick="openHelpModal()" class="p-2 text-slate-400 hover:bg-slate-50 rounded-full">
                                                <span class="material-symbols-outlined">help</span>
                                            </button>
                                            <div class="h-8 w-[1px] bg-slate-200 mx-2 hidden lg:block"></div>
                                        </div>
                                        <button
                                            onclick="openNewModal()"
                                            class="bg-primary hover:bg-primary/90 text-white px-5 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2 shadow-lg shadow-primary/20 whitespace-nowrap">
                                            <span class="material-symbols-outlined text-lg">add</span>
                                            New Config
                                        </button>
                                    </div>
                                </header>

                                <!-- Page Content -->
                                <div class="flex-1 p-6 lg:p-10">
                                    <div class="mb-10">
                                        <h1 class="text-3xl font-black text-slate-900 tracking-tight">System Creator -
                                            Master Config</h1>
                                        <p class="text-slate-500 mt-1 font-medium">Manage platform-wide settings and
                                            role hierarchies from a central dashboard.</p>
                                    </div>

                                    <!-- Stats -->
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-10">
                                        <div
                                            class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5">
                                            <div class="bg-primary/5 text-primary p-4 rounded-2xl">
                                                <span class="material-symbols-outlined text-3xl">tune</span>
                                            </div>
                                            <div>
                                                <p class="text-xs font-black text-slate-400 uppercase tracking-widest">
                                                    Active Settings</p>
                                                <p class="text-3xl font-black text-slate-900">
                                                    <%= activeSettings %>
                                                </p>
                                                <p
                                                    class="text-[10px] text-emerald-500 font-black flex items-center mt-1">
                                                    <span
                                                        class="material-symbols-outlined text-xs mr-1">trending_up</span>
                                                    +12% vs last month
                                                </p>
                                            </div>
                                        </div>
                                        <div
                                            class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5">
                                            <div class="bg-indigo-50 text-indigo-600 p-4 rounded-2xl">
                                                <span class="material-symbols-outlined text-3xl">shield_person</span>
                                            </div>
                                            <div>
                                                <p class="text-xs font-black text-slate-400 uppercase tracking-widest">
                                                    System Roles</p>
                                                <p class="text-3xl font-black text-slate-900"><%= roles.size() %></p>
                                                <p class="text-[10px] text-slate-400 font-bold mt-1 tracking-tight">Access Control Groups</p>
                                            </div>
                                        </div>
                                        <div
                                            class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5">
                                            <div class="bg-emerald-50 text-emerald-600 p-4 rounded-2xl">
                                                <span class="material-symbols-outlined text-3xl">verified_user</span>
                                            </div>
                                            <div>
                                                <p class="text-xs font-black text-slate-400 uppercase tracking-widest">
                                                    Security Alerts</p>
                                                <p class="text-3xl font-black text-slate-900">0</p>
                                                <p
                                                    class="text-[10px] text-emerald-500 font-black flex items-center mt-1">
                                                    <span
                                                        class="material-symbols-outlined text-xs mr-1">check_circle</span>
                                                    System healthy
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-10">
                                        <!-- Platform Settings Table -->
                                        <div
                                            class="xl:col-span-2 bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden flex flex-col">
                                            <div
                                                class="p-6 border-b border-slate-50 flex items-center justify-between bg-slate-50/30">
                                                <h2 class="font-black text-slate-900 flex items-center gap-3">
                                                    <span
                                                        class="material-symbols-outlined text-slate-400">table_rows</span>
                                                    Platform Settings
                                                </h2>
                                                <div class="flex gap-2 text-slate-400">
                                                    <button class="hover:text-slate-600 p-1 transition-colors"><span
                                                            class="material-symbols-outlined">filter_list</span></button>
                                                    <button class="hover:text-slate-600 p-1 transition-colors"><span
                                                            class="material-symbols-outlined">download</span></button>
                                                </div>
                                            </div>
                                            <div class="overflow-x-auto font-medium">
                                                <table class="w-full text-left">
                                                    <thead>
                                                        <tr
                                                            class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-b border-slate-50">
                                                            <th class="px-4 lg:px-8 py-5">Configuration Key</th>
                                                            <th class="px-4 lg:px-8 py-5">Current Value</th>
                                                            <th class="px-4 lg:px-8 py-5 hidden sm:table-cell">Updated At</th>
                                                            <th class="px-4 lg:px-8 py-5 text-right">Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="divide-y divide-slate-50" id="settingsContainer">
                                                        <% 
                                                           int rowIndex = 0;
                                                           for (SystemSetting setting : allSettings) { 
                                                        %>
                                                        <tr class="group hover:bg-slate-50/50 transition-colors config-row" data-index="<%= rowIndex++ %>" style="display: none;">
                                                            <td class="px-4 lg:px-8 py-4 lg:py-6"><code
                                                                    class="text-xs lg:text-sm font-black text-slate-900 border-b border-primary/10 break-all"><%= setting.getSettingKey() %></code>
                                                            </td>
                                                            <td class="px-4 lg:px-8 py-4 lg:py-6 font-mono text-xs">
                                                                <span
                                                                    class="px-2 lg:px-3 py-1 bg-slate-100 text-slate-600 rounded-lg break-all">"<%= setting.getSettingValue() %>"</span>
                                                            </td>
                                                            <td
                                                                class="px-4 lg:px-8 py-4 lg:py-6 text-xs text-slate-500 font-bold tracking-tight hidden sm:table-cell">
                                                                <%= setting.getUpdatedAt() %></td>
                                                            <td class="px-4 lg:px-8 py-4 lg:py-6 text-right space-x-2">
                                                                <button onclick="openEditModal('<%= setting.getSettingKey() %>', '<%= setting.getSettingValue() %>')"
                                                                    class="text-primary hover:underline text-xs font-black uppercase tracking-widest">Edit</button>
                                                                <button onclick="deleteConfig('<%= setting.getSettingKey() %>')"
                                                                    class="text-red-500 hover:underline text-xs font-black uppercase tracking-widest">Delete</button>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div
                                                class="p-6 mt-auto border-t border-slate-50 flex items-center justify-between bg-slate-50/30">
                                                <span class="text-xs text-slate-400 font-bold" id="paginationLabel">Showing 0 of <%= allSettings.size() %> configurations</span>
                                                <div class="flex gap-2">
                                                    <button onclick="changePage(-1)" id="prevBtn"
                                                        class="px-4 py-1.5 border border-slate-200 rounded-xl text-xs font-bold hover:bg-white bg-white shadow-sm transition-all text-slate-900 disabled:bg-slate-50 disabled:text-slate-400 disabled:cursor-not-allowed inline-block">Previous</button>
                                                    
                                                    <button onclick="changePage(1)" id="nextBtn"
                                                        class="px-4 py-1.5 border border-slate-200 rounded-xl text-xs font-bold hover:bg-slate-800 bg-slate-900 text-white shadow-sm transition-all disabled:bg-slate-100 disabled:text-slate-400 disabled:cursor-not-allowed inline-block">Next</button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Activity Log -->
                                        <div
                                            class="bg-white rounded-3xl border border-slate-100 shadow-sm flex flex-col pt-6 pb-2">
                                            <div class="px-6 mb-8 flex items-center justify-between">
                                                <h2 class="font-black text-slate-900 flex items-center gap-3">
                                                    <span
                                                        class="material-symbols-outlined text-slate-400">history</span>
                                                    Activity Logs
                                                </h2>
                                            </div>
                                            <div
                                                class="flex-1 px-6 space-y-8 overflow-y-auto max-h-[600px] relative before:absolute before:left-10 before:top-2 before:bottom-0 before:w-px before:bg-slate-50">
                                                <% if (globalLogs.isEmpty()) { %>
                                                    <div class="h-full flex flex-col items-center justify-center text-center py-20 px-4">
                                                        <div class="w-16 h-16 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-300 mb-4">
                                                            <span class="material-symbols-outlined text-3xl">history</span>
                                                        </div>
                                                        <p class="text-sm font-black text-slate-900">No Recent Activity</p>
                                                        <p class="text-[10px] text-slate-400 font-bold mt-1 uppercase tracking-widest">Waiting for system logs...</p>
                                                    </div>
                                                <% } else { %>
                                                    <% for (SystemLog log : globalLogs) { 
                                                        String icon = "history";
                                                        String iconBg = "bg-primary/10 text-primary";
                                                        if ("security".equalsIgnoreCase(log.getType())) {
                                                            icon = "shield";
                                                            iconBg = "bg-amber-50 text-amber-600";
                                                        } else if ("error".equalsIgnoreCase(log.getType())) {
                                                            icon = "error";
                                                            iconBg = "bg-red-50 text-red-600";
                                                        }
                                                    %>
                                                    <div class="relative pl-10">
                                                        <div
                                                            class="absolute left-[-5px] top-0 w-10 h-10 rounded-full <%= iconBg %> border-4 border-white flex items-center justify-center shadow-sm z-10">
                                                            <span class="material-symbols-outlined text-sm"><%= icon %></span>
                                                        </div>
                                                        <div>
                                                            <p class="text-sm font-bold text-slate-900 leading-tight">
                                                                <%= log.getActivity() %>
                                                            </p>
                                                            <p
                                                                class="text-[10px] text-slate-400 font-bold mt-1 uppercase tracking-tighter">
                                                                <%= log.getTimestamp() %> • Impact: <%= log.getImpact() %></p>
                                                            <div
                                                                class="mt-3 p-3 bg-slate-50 border border-slate-100 rounded-2xl text-[10px] font-mono whitespace-pre-wrap">
                                                                <%= log.getDetails() %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                                <% } %>
                                            </div>
                                            <div class="p-6 border-t border-slate-50 bg-slate-50/10">
                                                <button
                                                    class="w-full text-center text-xs font-black text-primary hover:underline uppercase tracking-widest leading-none">View
                                                    Full Audit Trail</button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Roles Section -->
                                    <div
                                        class="mt-10 bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
                                        <div
                                            class="p-6 border-b border-slate-50 bg-slate-50/30 flex items-center justify-between">
                                            <h2 class="font-black text-slate-900 flex items-center gap-3">
                                                <span
                                                    class="material-symbols-outlined text-slate-400">shield_person</span>
                                                Roles & Permissions Matrix
                                            </h2>
                                            <div class="flex items-center gap-4">
                                                <span
                                                    class="text-[10px] font-bold text-slate-400 flex items-center gap-1"><span
                                                        class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Changes
                                                    auto-save</span>
                                                <div class="w-px h-4 bg-slate-200"></div>
                                                <button
                                                    class="text-xs font-black text-primary uppercase tracking-widest">Add
                                                    New Role</button>
                                            </div>
                                        </div>
                                        <div class="overflow-x-auto">
                                            <table class="w-full text-left">
                                                <thead>
                                                    <tr
                                                        class="bg-indigo-50/30 text-indigo-900/40 text-[10px] font-black uppercase tracking-widest border-b border-indigo-50/50">
                                                        <th class="px-4 lg:px-10 py-5">Module / Action</th>
                                                        <% for (Role role : roles) { %>
                                                        <th class="px-4 lg:px-6 py-5 text-center border-l border-slate-50 text-slate-950 font-black">
                                                            <%= role.getRoleName() %>
                                                        </th>
                                                        <% } %>
                                                    </tr>
                                                </thead>
                                                <tbody class="divide-y divide-slate-50 font-medium">
                                                    <% for (Permission perm : perms) { %>
                                                    <tr class="hover:bg-slate-50/30 transition-colors group">
                                                        <td class="px-4 lg:px-10 py-4 text-sm font-bold text-slate-600">
                                                            <%= perm.getPermissionName() %>
                                                            <span class="block text-[9px] text-slate-400 font-bold uppercase tracking-widest mt-0.5"><%= perm.getModule() %></span>
                                                        </td>
                                                        <% for (Role role : roles) { 
                                                            boolean hasPerm = rolePermsMap.get(role.getId()) != null && rolePermsMap.get(role.getId()).contains(perm.getId());
                                                            boolean isSystemCreator = "ROLE_SYSTEM_CREATOR".equals(role.getId());
                                                        %>
                                                        <td class="px-4 lg:px-6 py-4 text-center border-l border-slate-100/50">
                                                            <% if (isSystemCreator) { %>
                                                                <span class="material-symbols-outlined text-indigo-500 scale-110" style="font-variation-settings: 'FILL' 1">verified</span>
                                                            <% } else { %>
                                                                <input type="checkbox" <%= hasPerm ? "checked" : "" %> 
                                                                    onchange="togglePermission('<%= role.getId() %>', '<%= perm.getId() %>', this.checked)"
                                                                    class="rounded-md border-slate-300 text-indigo-600 focus:ring-indigo-500/20 w-5 h-5 transition-all cursor-pointer">
                                                            <% } %>
                                                        </td>
                                                        <% } %>
                                                    </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <!-- Edit Config Modal -->
                                    <div id="editConfigModal" class="fixed inset-0 z-50 hidden bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
                                        <div class="bg-white rounded-3xl w-full max-w-md shadow-2xl overflow-hidden border border-slate-100 transform transition-all scale-95 opacity-0 duration-300" id="editModalContent">
                                            <div class="p-8">
                                                <div class="flex items-center justify-between mb-8">
                                                    <div class="bg-primary/10 p-3 rounded-2xl text-primary">
                                                        <span class="material-symbols-outlined">edit_note</span>
                                                    </div>
                                                    <button onclick="closeEditModal()" class="text-slate-400 hover:bg-slate-50 p-2 rounded-xl transition-all">
                                                        <span class="material-symbols-outlined">close</span>
                                                    </button>
                                                </div>
                                                <h3 class="text-2xl font-black text-slate-900 tracking-tight mb-2">Update Configuration</h3>
                                                <p class="text-slate-500 text-sm font-medium mb-8">Modify the platform setting. Changes take effect immediately after saving.</p>
                                                
                                                <form id="updateConfigForm" class="space-y-6">
                                                    <div>
                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Setting Key</label>
                                                        <input type="text" id="editConfigKey" name="key" readonly class="w-full bg-slate-50 border-slate-100 rounded-2xl px-5 py-4 text-sm font-black text-slate-500 cursor-not-allowed">
                                                    </div>
                                                    <div>
                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">New Value</label>
                                                        <input type="text" id="editConfigValue" name="value" class="w-full bg-white border-slate-200 focus:border-primary focus:ring-4 focus:ring-primary/10 rounded-2xl px-5 py-4 text-sm font-bold transition-all" placeholder="Enter new value">
                                                    </div>
                                                    <button type="submit" class="w-full bg-slate-900 hover:bg-slate-800 text-white py-4 rounded-2xl font-black text-sm transition-all shadow-xl shadow-slate-200">
                                                        Save Changes
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- New Config Modal -->
                                    <div id="newConfigModal" class="fixed inset-0 z-50 hidden bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
                                        <div class="bg-white rounded-3xl w-full max-w-md shadow-2xl overflow-hidden border border-slate-100 transform transition-all scale-95 opacity-0 duration-300" id="newModalContent">
                                            <div class="p-8">
                                                <div class="flex items-center justify-between mb-8">
                                                    <div class="bg-primary/10 p-3 rounded-2xl text-primary">
                                                        <span class="material-symbols-outlined">add_circle</span>
                                                    </div>
                                                    <button onclick="closeNewModal()" class="text-slate-400 hover:bg-slate-50 p-2 rounded-xl transition-all">
                                                        <span class="material-symbols-outlined">close</span>
                                                    </button>
                                                </div>
                                                <h3 class="text-2xl font-black text-slate-900 tracking-tight mb-2">New Configuration</h3>
                                                <p class="text-slate-500 text-sm font-medium mb-8">Add a new platform-wide setting. Keys must be unique.</p>
                                                
                                                <form id="newConfigForm" class="space-y-6">
                                                    <div>
                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Setting Key</label>
                                                        <input type="text" name="key" required class="w-full bg-white border-slate-200 focus:border-primary focus:ring-4 focus:ring-primary/10 rounded-2xl px-5 py-4 text-sm font-bold transition-all" placeholder="e.g. platform.maintenance_mode">
                                                    </div>
                                                    <div>
                                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Setting Value</label>
                                                        <input type="text" name="value" required class="w-full bg-white border-slate-200 focus:border-primary focus:ring-4 focus:ring-primary/10 rounded-2xl px-5 py-4 text-sm font-bold transition-all" placeholder="Enter value">
                                                    </div>
                                                    <button type="submit" class="w-full bg-primary hover:bg-primary/90 text-white py-4 rounded-2xl font-black text-sm transition-all shadow-xl shadow-primary/20">
                                                        Add Configuration
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Help Modal -->
                                    <div id="helpModal" class="fixed inset-0 z-50 hidden bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
                                        <div class="bg-white rounded-3xl w-full max-w-lg shadow-2xl overflow-hidden border border-slate-100 transform transition-all scale-95 opacity-0 duration-300" id="helpModalContent">
                                            <div class="p-8">
                                                <div class="flex items-center justify-between mb-8">
                                                    <div class="bg-primary/10 p-3 rounded-2xl text-primary">
                                                        <span class="material-symbols-outlined">help_center</span>
                                                    </div>
                                                    <button onclick="closeHelpModal()" class="text-slate-400 hover:bg-slate-50 p-2 rounded-xl transition-all">
                                                        <span class="material-symbols-outlined">close</span>
                                                    </button>
                                                </div>
                                                <h3 class="text-2xl font-black text-slate-900 tracking-tight mb-2">System Creator Guide</h3>
                                                <p class="text-slate-500 text-sm font-medium mb-8">As a System Creator, you have root-level control over the National Insurance Company platform.</p>
                                                
                                                <div class="space-y-6">
                                                    <div class="flex gap-4">
                                                        <div class="bg-slate-50 px-3 py-1 self-start rounded-lg text-xs font-black text-slate-900">1</div>
                                                        <div>
                                                            <h4 class="font-bold text-slate-900 text-sm mb-1">Platform Settings</h4>
                                                            <p class="text-xs text-slate-500 leading-relaxed">Modify global configuration keys. These control themes, maintenance modes, and external API integrations.</p>
                                                        </div>
                                                    </div>
                                                    <div class="flex gap-4">
                                                        <div class="bg-slate-50 px-3 py-1 self-start rounded-lg text-xs font-black text-slate-900">2</div>
                                                        <div>
                                                            <h4 class="font-bold text-slate-900 text-sm mb-1">Access Control</h4>
                                                            <p class="text-xs text-slate-500 leading-relaxed">Manage the platform's role-permission matrix. Be careful: disabling core permissions can lock out specific roles.</p>
                                                        </div>
                                                    </div>
                                                    <div class="flex gap-4">
                                                        <div class="bg-slate-50 px-3 py-1 self-start rounded-lg text-xs font-black text-slate-900">3</div>
                                                        <div>
                                                            <h4 class="font-bold text-slate-900 text-sm mb-1">Audit Logs</h4>
                                                            <p class="text-xs text-slate-500 leading-relaxed">Monitor every action taken on the system. All administrative changes are logged for security and compliance.</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <button onclick="closeHelpModal()" class="w-full mt-10 bg-slate-900 hover:bg-slate-800 text-white py-4 rounded-2xl font-black text-sm transition-all shadow-xl shadow-slate-200">
                                                    Got it, thanks!
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <script>
                                        let currentConfigPage = 1;
                                        const configsPerPage = 4;
                                        let allConfigRows = [];

                                        function initPagination() {
                                            allConfigRows = Array.from(document.querySelectorAll('.config-row'));
                                            renderPage();
                                        }

                                        function renderPage() {
                                            const totalRows = allConfigRows.length;
                                            const totalPages = Math.ceil(totalRows / configsPerPage);
                                            
                                            // Handle edge case if rows empty
                                            if (totalRows === 0) {
                                                document.getElementById('paginationLabel').innerText = 'Showing 0 of 0 configurations';
                                                document.getElementById('prevBtn').disabled = true;
                                                document.getElementById('nextBtn').disabled = true;
                                                return;
                                            }

                                            // Determine boundaries
                                            const startIndex = (currentConfigPage - 1) * configsPerPage;
                                            const endIndex = Math.min(startIndex + configsPerPage, totalRows);

                                            // Toggle visibility
                                            allConfigRows.forEach((row, index) => {
                                                if (index >= startIndex && index < endIndex) {
                                                    row.style.display = '';
                                                } else {
                                                    row.style.display = 'none';
                                                }
                                            });

                                            // Update details text and buttons
                                            const displayedCount = endIndex - startIndex;
                                            document.getElementById('paginationLabel').innerText = `Showing ${displayedCount} of ${totalRows} configurations`;
                                            
                                            document.getElementById('prevBtn').disabled = (currentConfigPage <= 1);
                                            document.getElementById('nextBtn').disabled = (currentConfigPage >= totalPages);
                                        }

                                        function changePage(direction) {
                                            const totalPages = Math.ceil(allConfigRows.length / configsPerPage);
                                            currentConfigPage += direction;
                                            if (currentConfigPage < 1) currentConfigPage = 1;
                                            if (currentConfigPage > totalPages) currentConfigPage = totalPages;
                                            renderPage();
                                        }

                                        // Call on loaded
                                        document.addEventListener('DOMContentLoaded', initPagination);

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

                                        function openEditModal(key, value) {
                                            document.getElementById('editConfigKey').value = key;
                                            document.getElementById('editConfigValue').value = value;
                                            const modal = document.getElementById('editConfigModal');
                                            const content = document.getElementById('editModalContent');
                                            modal.classList.remove('hidden');
                                            setTimeout(() => {
                                                content.classList.remove('scale-95', 'opacity-0');
                                                content.classList.add('scale-100', 'opacity-100');
                                            }, 10);
                                        }

                                        function closeEditModal() {
                                            const content = document.getElementById('editModalContent');
                                            content.classList.remove('scale-100', 'opacity-100');
                                            content.classList.add('scale-95', 'opacity-0');
                                            setTimeout(() => {
                                                document.getElementById('editConfigModal').classList.add('hidden');
                                            }, 300);
                                        }

                                        function openNewModal() {
                                            const modal = document.getElementById('newConfigModal');
                                            const content = document.getElementById('newModalContent');
                                            modal.classList.remove('hidden');
                                            setTimeout(() => {
                                                content.classList.remove('scale-95', 'opacity-0');
                                                content.classList.add('scale-100', 'opacity-100');
                                            }, 10);
                                        }

                                        function closeNewModal() {
                                            const content = document.getElementById('newModalContent');
                                            content.classList.remove('scale-100', 'opacity-100');
                                            content.classList.add('scale-95', 'opacity-0');
                                            setTimeout(() => {
                                                document.getElementById('newConfigModal').classList.add('hidden');
                                            }, 300);
                                        }

                                        async function deleteConfig(key) {
                                            if (!confirm('Are you sure you want to delete configuration: ' + key + '?')) return;
                                            try {
                                                const response = await fetch(`delete_system_config.jsp?key=${encodeURIComponent(key)}`);
                                                if (response.ok) {
                                                    const res = await response.json();
                                                    if (res.success) {
                                                        location.reload();
                                                    } else {
                                                        alert('Deletion failed: ' + (res.message || 'Unknown error'));
                                                    }
                                                }
                                            } catch (err) { console.error(err); alert('Network error'); }
                                        }

                                        async function togglePermission(roleId, permId, enabled) {
                                            try {
                                                const response = await fetch(`update_role_permission.jsp?roleId=${encodeURIComponent(roleId)}&permissionId=${encodeURIComponent(permId)}&enabled=${enabled}`);
                                                if (!response.ok) {
                                                    alert('Failed to update permission');
                                                    location.reload();
                                                }
                                            } catch (err) {
                                                console.error(err);
                                                alert('Network error while updating permission');
                                                location.reload();
                                            }
                                        }

                                        function filterAll(query) {
                                            const q = query.toLowerCase();
                                            // Filter settings table
                                            const settingsRows = document.querySelectorAll('tbody tr');
                                            settingsRows.forEach(row => {
                                                const text = row.innerText.toLowerCase();
                                                row.style.display = text.includes(q) ? '' : 'none';
                                            });
                                        }

                                        document.getElementById('newConfigForm').onsubmit = async (e) => {
                                            e.preventDefault();
                                            const formData = new FormData(e.target);
                                            const key = formData.get('key');
                                            const value = formData.get('value');
                                            try {
                                                const response = await fetch(`add_system_config.jsp?key=${encodeURIComponent(key)}&value=${encodeURIComponent(value)}`);
                                                if (response.ok) {
                                                    const res = await response.json();
                                                    if (res.success) {
                                                        closeNewModal();
                                                        location.reload();
                                                    } else {
                                                        alert('Addition failed: ' + (res.message || 'Duplicate key?'));
                                                    }
                                                }
                                            } catch (err) { console.error(err); alert('Network error'); }
                                        };

                                        document.getElementById('updateConfigForm').onsubmit = async (e) => {
                                            e.preventDefault();
                                            const formData = new FormData(e.target);
                                            const key = formData.get('key');
                                            const value = formData.get('value');
                                            try {
                                                const response = await fetch(`update_system_config.jsp?key=${encodeURIComponent(key)}&value=${encodeURIComponent(value)}`);
                                                if (response.ok) {
                                                    const res = await response.json();
                                                    if (res.success) {
                                                        closeEditModal();
                                                        location.reload();
                                                    } else {
                                                        alert('Update failed: ' + (res.message || 'Unknown error'));
                                                    }
                                                }
                                            } catch (err) { console.error(err); alert('Network error'); }
                                        };

                                        function toggleNotifications() {
                                            const dropdown = document.getElementById('notificationsDropdown');
                                            dropdown.classList.toggle('hidden');
                                        }

                                        function openHelpModal() {
                                            const modal = document.getElementById('helpModal');
                                            const content = document.getElementById('helpModalContent');
                                            modal.classList.remove('hidden');
                                            setTimeout(() => {
                                                content.classList.remove('scale-95', 'opacity-0');
                                                content.classList.add('scale-100', 'opacity-100');
                                            }, 10);
                                        }

                                        function closeHelpModal() {
                                            const content = document.getElementById('helpModalContent');
                                            content.classList.remove('scale-100', 'opacity-100');
                                            content.classList.add('scale-95', 'opacity-0');
                                            setTimeout(() => {
                                                document.getElementById('helpModal').classList.add('hidden');
                                            }, 300);
                                        }

                                        // Close dropdowns on outside click
                                        window.onclick = (event) => {
                                            if (!event.target.closest('.relative')) {
                                                const dropdown = document.getElementById('notificationsDropdown');
                                                if (dropdown && !dropdown.classList.contains('hidden')) {
                                                    dropdown.classList.add('hidden');
                                                }
                                            }
                                        };
                                    </script>
                                </div>
                            </main>
                        </div>
                    </body>

                    </html>
