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
    SystemDAO systemDAO = new SystemDAO();
    List<Role> roles = systemDAO.getAllRoles();
    List<Permission> permissions = systemDAO.getAllPermissions();
    Map<String, List<String>> rolePerms = systemDAO.getRolePermissionsMap();
    Account currentUser = (Account) sess.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Roles & Permissions - Master Config</title>
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
                        "background-dark": "#101622",
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
                <a class="flex items-center gap-3 px-3 py-2 text-primary bg-primary/10 rounded-xl font-bold transition-all" href="system_roles.jsp">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">verified_user</span> Roles & Permissions
                </a>
                <a class="flex items-center gap-3 px-3 py-2 text-slate-500 hover:bg-slate-50 rounded-xl font-semibold transition-all" href="system_logs.jsp">
                    <span class="material-symbols-outlined text-xl">history_edu</span> Activity Logs
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
            <div class="p-4 border-t border-slate-100">
                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl font-semibold transition-all">
                    <span class="material-symbols-outlined text-xl">logout</span> Sign Out
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-h-screen min-w-0 overflow-hidden">
            <header class="h-auto lg:h-16 bg-white border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between px-6 lg:px-8 py-4 lg:py-0 shrink-0 gap-4">
                <h2 class="text-sm font-black text-slate-400 uppercase tracking-widest">Access Control Matrix</h2>
                <div class="flex items-center gap-4">
                    <div class="flex items-center gap-2 bg-emerald-50 text-emerald-600 px-3 py-1.5 rounded-full">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="text-[10px] font-black uppercase tracking-widest">Live Sync Enabled</span>
                    </div>
                </div>
            </header>

            <div class="flex-1 p-4 lg:p-10 overflow-x-hidden">
                <div class="mb-10">
                    <h1 class="text-3xl font-black text-slate-900 tracking-tight">Roles & Permissions</h1>
                    <p class="text-slate-500 mt-1 font-medium">Define granular access levels across the platform modules.</p>
                </div>

                <div class="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
                    <div class="overflow-x-auto -mx-px">
                        <table class="min-w-[700px] w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-b border-slate-50">
                                    <th class="px-4 lg:px-10 py-4 lg:py-6">Module / Permission</th>
                                    <% for (Role role : roles) { %>
                                    <th class="px-4 lg:px-10 py-4 lg:py-6 text-center border-l border-slate-50 text-slate-900">
                                        <%= role.getRoleName() %>
                                    </th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50 font-medium text-sm">
                                <% 
                                   String currentModule = "";
                                   for (Permission perm : permissions) { 
                                       if (!perm.getModule().equals(currentModule)) {
                                           currentModule = perm.getModule();
                                %>
                                <tr class="bg-slate-50/20">
                                    <td colspan="<%= roles.size() + 1 %>" class="px-4 lg:px-10 py-3 lg:py-4 text-[10px] font-black text-primary uppercase tracking-widest">
                                        Module: <%= currentModule %>
                                    </td>
                                </tr>
                                <% } %>
                                <tr class="hover:bg-slate-50/30 transition-colors">
                                    <td class="px-4 lg:px-10 py-3 lg:py-5 font-bold text-slate-700">
                                        <%= perm.getPermissionName() %>
                                    </td>
                                    <% for (Role role : roles) { 
                                        boolean hasPerm = rolePerms.getOrDefault(role.getId(), new ArrayList<>()).contains(perm.getId());
                                        boolean isSystemCreator = "ROLE_SYSTEM_CREATOR".equals(role.getId());
                                    %>
                                    <td class="px-4 lg:px-10 py-3 lg:py-5 text-center border-l border-slate-50">
                                        <input type="checkbox" 
                                               <%= hasPerm ? "checked" : "" %> 
                                               <%= isSystemCreator ? "disabled" : "" %>
                                               onchange="togglePermission('<%= role.getId() %>', '<%= perm.getId() %>', this.checked)"
                                               class="rounded-md border-slate-200 text-primary focus:ring-primary/20 w-5 h-5 transition-all cursor-pointer <%= isSystemCreator ? "opacity-50 cursor-not-allowed" : "" %>">
                                    </td>
                                    <% } %>
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

        async function togglePermission(roleId, permId, enabled) {
            try {
                const response = await fetch(`update_role_permission.jsp?roleId=${encodeURIComponent(roleId)}&permissionId=${encodeURIComponent(permId)}&enabled=${enabled}`);
                if (!response.ok) throw new Error('Failed to update');
                console.log(`Permission updated for Role ${roleId}`);
            } catch (err) {
                alert('Error updating permission synchronization.');
                location.reload();
            }
        }
    </script>
</body>
</html>
