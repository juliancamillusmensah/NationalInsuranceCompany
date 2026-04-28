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
    
    Account currentUser = (Account) sess.getAttribute("user");
    String roleId = (String) sess.getAttribute("roleId");

    if (roleId != null && roleId.contains("CUSTOMER")) {
        response.sendRedirect("customer_profile.jsp");
        return;
    }
    
    NotificationDAO notificationDAO = new NotificationDAO();
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());

    String portalHome = "Customerportal.jsp";
    String portalName = "Customer Portal";
    
    if (roleId != null) {
        if (roleId.contains("SUPERADMIN")) {
            portalHome = "Superadmin.jsp";
            portalName = "Regulatory Portal";
        } else if (roleId.contains("ADMIN")) {
            portalHome = "Companyadmin.jsp";
            portalName = "Admin Portal";
        } else if (roleId.contains("SUPPORT")) {
            portalHome = "companyadmin_claims.jsp";
            portalName = "Claims Hub";
        } else if (roleId.contains("AUDITOR")) {
            portalHome = "companyadmin_transactions.jsp";
            portalName = "Billing & Audit";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Account Settings - NIC Ghana</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#059669",
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
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-size: 24px; vertical-align: middle; }
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
                <button onclick="document.getElementById('sidebar').classList.add('-translate-x-full')" class="lg:hidden p-2 text-slate-400">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <nav class="flex-1 px-4 mt-4 space-y-1">
                <a href="<%= portalHome %>" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl">arrow_back</span>
                    <span class="text-sm">Back to Portal</span>
                </a>
                <div class="pt-4 pb-2 px-3 text-[10px] font-black text-slate-400 uppercase tracking-widest">Personal</div>
                <a href="account_settings.jsp" class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">manage_accounts</span>
                    <span class="text-sm">Profile Settings</span>
                </a>
            </nav>

            <div class="p-6 mt-auto border-t border-slate-50">
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
                <h2 class="text-lg font-bold text-slate-900 uppercase tracking-tight">Account Settings</h2>
                
                <div class="flex items-center gap-6">
                    <!-- Notification Button -->
                    <div class="relative">
                        <button id="notificationBtn" class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                            <span class="material-symbols-outlined">notifications</span>
                            <% if (unreadNotifications > 0) { %>
                                <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                            <% } %>
                        </button>
                    </div>

                    <!-- Profile Button -->
                    <div class="flex items-center gap-3 pl-4 border-l border-slate-200">
                        <div class="flex flex-col text-right hidden sm:flex">
                            <span class="text-sm font-bold text-slate-900 leading-none"><%= currentUser.getFullName() %></span>
                            <span class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider mt-1"><%= roleId.replace("ROLE_", "").replace("_", " ") %></span>
                        </div>
                        <div class="h-10 w-10 rounded-full bg-slate-200 overflow-hidden shadow-sm border-2 border-transparent">
                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= currentUser.getFullName() %>" class="h-full w-full object-cover">
                        </div>
                    </div>
                </div>
            </header>

            <!-- Scrollable Body -->
            <div class="flex-1 p-8 max-w-4xl">
                <% if ("profile_updated".equals(request.getParameter("success"))) { %>
                    <div class="mb-8 p-4 bg-emerald-50 border border-emerald-100 rounded-2xl flex items-center gap-3 text-emerald-600 font-bold text-sm animate-in fade-in slide-in-from-top-4 duration-500">
                        <span class="material-symbols-outlined">check_circle</span>
                        Profile information updated successfully!
                    </div>
                <% } else if ("password_updated".equals(request.getParameter("success"))) { %>
                    <div class="mb-8 p-4 bg-emerald-50 border border-emerald-100 rounded-2xl flex items-center gap-3 text-emerald-600 font-bold text-sm animate-in fade-in slide-in-from-top-4 duration-500">
                        <span class="material-symbols-outlined">lock_open</span>
                        Password successfully changed.
                    </div>
                <% } else if (request.getParameter("error") != null) { %>
                    <div class="mb-8 p-4 bg-red-50 border border-red-100 rounded-2xl flex items-center gap-3 text-red-600 font-bold text-sm animate-in fade-in slide-in-from-top-4 duration-500">
                        <span class="material-symbols-outlined">error</span>
                        <%= "pass_mismatch".equals(request.getParameter("error")) ? "Passwords do not match." : "Failed to update profile. Please try again." %>
                    </div>
                <% } %>

                <div class="grid grid-cols-1 gap-8">
                    <!-- Profile Information Card -->
                    <div class="bg-white rounded-[2.5rem] border border-slate-200 shadow-sm overflow-hidden">
                        <div class="p-8 border-b border-slate-50 flex items-center justify-between bg-slate-50/30">
                            <div class="flex items-center gap-4">
                                <div class="p-3 bg-primary/10 text-primary rounded-2xl">
                                    <span class="material-symbols-outlined">person</span>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-900 px-1">Profile Information</h3>
                                    <p class="text-xs font-semibold text-slate-400 mt-1 uppercase tracking-widest px-1">Manage your identity on the portal</p>
                                </div>
                            </div>
                            <button onclick="document.getElementById('profileForm').submit()" class="px-6 py-2.5 bg-primary text-white text-sm font-bold rounded-xl hover:bg-primary-dark transition-all shadow-lg shadow-primary/20 active:scale-95">
                                Save Profile
                            </button>
                        </div>
                        
                        <div class="p-8">
                            <form id="profileForm" action="profile_update_process.jsp" method="POST" class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <input type="hidden" name="action" value="update_profile">
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 ml-1">Full Display Name</label>
                                        <input type="text" name="fullName" value="<%= currentUser.getFullName() %>" required class="w-full bg-slate-50 border-slate-100 rounded-2xl px-5 py-4 text-sm font-semibold focus:ring-4 focus:ring-primary/10 focus:border-primary transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 ml-1">Email Address</label>
                                        <input type="email" name="email" value="<%= currentUser.getEmail() %>" required class="w-full bg-slate-50 border-slate-100 rounded-2xl px-5 py-4 text-sm font-semibold focus:ring-4 focus:ring-primary/10 focus:border-primary transition-all">
                                    </div>
                                </div>
                                <div class="bg-slate-50/50 rounded-3xl p-8 border border-dashed border-slate-200 flex flex-col items-center justify-center text-center">
                                    <div class="h-24 w-24 rounded-full bg-white p-2 shadow-xl border border-slate-100 mb-4 ring-4 ring-primary/5">
                                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= currentUser.getFullName() %>" class="h-full w-full object-cover">
                                    </div>
                                    <p class="text-sm font-bold text-slate-900">Dynamic Avatar</p>
                                    <p class="text-[10px] text-slate-400 font-medium mt-1 leading-relaxed">Your avatar is automatically generated<br>based on your name.</p>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Security / Password Card -->
                    <div class="bg-white rounded-[2.5rem] border border-slate-200 shadow-sm overflow-hidden">
                        <div class="p-8 border-b border-slate-50 bg-slate-50/30 flex items-center justify-between">
                            <div class="flex items-center gap-4">
                                <div class="p-3 bg-amber-50 text-amber-600 rounded-2xl">
                                    <span class="material-symbols-outlined">lock</span>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-900 px-1">Security Credentials</h3>
                                    <p class="text-xs font-semibold text-slate-400 mt-1 uppercase tracking-widest px-1">Ensure your account remains private</p>
                                </div>
                            </div>
                            <button onclick="document.getElementById('passwordForm').submit()" class="px-6 py-2.5 bg-slate-900 text-white text-sm font-bold rounded-xl hover:bg-slate-800 transition-all shadow-lg shadow-slate-900/10 active:scale-95">
                                Change Password
                            </button>
                        </div>
                        
                        <div class="p-8">
                            <form id="passwordForm" action="profile_update_process.jsp" method="POST" class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <input type="hidden" name="action" value="update_password">
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 ml-1">New Password</label>
                                        <input type="password" name="newPassword" required placeholder="Min. 8 characters" class="w-full bg-slate-50 border-slate-100 rounded-2xl px-5 py-4 text-sm font-semibold focus:ring-4 focus:ring-amber-500/10 focus:border-amber-500 transition-all">
                                    </div>
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 ml-1">Confirm New Password</label>
                                        <input type="password" name="confirmPassword" required placeholder="Must match exactly" class="w-full bg-slate-50 border-slate-100 rounded-2xl px-5 py-4 text-sm font-semibold focus:ring-4 focus:ring-amber-500/10 focus:border-amber-500 transition-all">
                                    </div>
                                </div>
                                <div>
                                    <div class="p-6 bg-amber-50 rounded-3xl border border-amber-100">
                                        <h4 class="text-xs font-black text-amber-900 uppercase tracking-tight mb-2">Password Policy</h4>
                                        <ul class="space-y-2">
                                            <li class="flex items-center gap-2 text-[10px] font-bold text-amber-700/70">
                                                <span class="material-symbols-outlined text-sm">check_circle</span> Use at least 8 characters
                                            </li>
                                            <li class="flex items-center gap-2 text-[10px] font-bold text-amber-700/70">
                                                <span class="material-symbols-outlined text-sm">check_circle</span> Mix numbers and symbols
                                            </li>
                                            <li class="flex items-center gap-2 text-[10px] font-bold text-amber-700/70">
                                                <span class="material-symbols-outlined text-sm">check_circle</span> Avoid common phrases
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Account Metadata Card -->
                    <div class="bg-slate-900 rounded-[2.5rem] p-8 text-white flex flex-col md:flex-row items-center justify-between gap-8">
                        <div class="flex items-center gap-6">
                            <div class="h-16 w-16 rounded-2xl bg-white/10 flex items-center justify-center border border-white/10 shadow-inner">
                                <span class="material-symbols-outlined text-3xl font-light">fingerprint</span>
                            </div>
                            <div>
                                <h4 class="text-sm font-black uppercase tracking-widest opacity-40 leading-none mb-2">Member ID</h4>
                                <p class="text-2xl font-bold tracking-tight"><%= currentUser.getId() %></p>
                            </div>
                        </div>
                        <div class="h-12 w-px bg-white/10 hidden md:block"></div>
                        <div class="flex items-center gap-6">
                            <div>
                                <h4 class="text-sm font-black uppercase tracking-widest opacity-40 leading-none mb-2">System Role</h4>
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                    <p class="text-xl font-bold uppercase tracking-tighter"><%= roleId.replace("ROLE_", "") %></p>
                                </div>
                            </div>
                        </div>
                        <div class="h-12 w-px bg-white/10 hidden md:block"></div>
                        <div class="text-center md:text-right">
                            <h4 class="text-sm font-black uppercase tracking-widest opacity-40 leading-none mb-2">Member Since</h4>
                            <p class="text-sm font-bold opacity-80"><%= currentUser.getCreatedAt().toString().substring(0, 10) %></p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
