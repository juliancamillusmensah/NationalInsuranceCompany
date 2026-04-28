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
    Account user = (Account) sess.getAttribute("user");
    
    NotificationDAO noteDAO = new NotificationDAO();
    List<Notification> notifications = noteDAO.getNotificationsByUserId(userId);
    int unreadCount = noteDAO.getUnreadCount(userId);

    String policyId = request.getParameter("id");
    if (policyId == null || policyId.isEmpty()) {
        response.sendRedirect("customer_explore_policies.jsp");
        return;
    }

    PolicyDAO policyDAO = new PolicyDAO();
    Policy p = policyDAO.getPolicyById(policyId);
    
    if (p == null) {
        response.sendRedirect("customer_explore_policies.jsp");
        return;
    }

    String type = (p.getPolicyType() != null ? p.getPolicyType() : "General").toLowerCase();
    String icon = type.contains("auto") ? "directions_car" : (type.contains("home") ? "home" : (type.contains("health") ? "medical_services" : (type.contains("life") ? "vital_signs" : (type.contains("travel") ? "flight" : "shield" )))); 
    
    String defaultImage = "https://images.unsplash.com/photo-1606836591695-4d58a73eba1e?q=80&w=800"; // General
    if (type.contains("auto")) defaultImage = "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800";
    else if (type.contains("home")) defaultImage = "https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800";
    else if (type.contains("health")) defaultImage = "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=80&w=800";
    else if (type.contains("life")) defaultImage = "https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=800";
    else if (type.contains("travel")) defaultImage = "https://images.unsplash.com/photo-1530521954074-e64f6810b32d?q=80&w=800";
    
    String customImage = p.getImageUrl();
    String imagePath = (customImage != null && !customImage.trim().isEmpty()) ? customImage : defaultImage;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title><%= p.getPolicyName() %> Details - NIC Insurance</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f8fafc" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>body { font-family: 'Inter', sans-serif; } .material-symbols-outlined { vertical-align: middle; }</style>
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <!-- Main Header -->
    <header class="bg-white border-b border-slate-100 h-auto lg:h-20 flex flex-col lg:flex-row lg:items-center px-6 lg:px-10 py-4 lg:py-0 sticky top-0 z-50 shadow-sm gap-4">
        <div class="flex items-center justify-between w-full lg:w-auto">
            <div class="flex items-center gap-3">
                <div class="bg-primary p-2 rounded-lg text-white">
                    <span class="material-symbols-outlined">shield</span>
                </div>
                <span class="text-xl font-black tracking-tight text-slate-900 border-r border-slate-200 lg:pr-4">Customer Portal</span>
            </div>
            <button onclick="document.getElementById('mobile-nav').classList.toggle('hidden')" class="md:hidden p-2 text-slate-500">
                <span class="material-symbols-outlined">menu</span>
            </button>
        </div>

        <nav id="mobile-nav" class="hidden md:flex flex-col md:flex-row items-start md:items-center gap-4 md:gap-8 w-full lg:w-auto">
            <a href="Customerportal.jsp" class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">My Coverage</a>
            <a href="customer_explore_policies.jsp" class="text-sm font-bold text-primary">Explore Policies</a>
            <a href="customer_support.jsp" class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Support</a>
        </nav>

        <div class="ml-auto flex items-center justify-between lg:justify-end gap-6 w-full lg:w-auto">
            <div class="flex items-center gap-6">
                <!-- Notification Dropdown -->
                <div class="relative group">
                    <button onclick="document.getElementById('notif-dropdown').classList.toggle('hidden')" class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                        <span class="material-symbols-outlined">notifications</span>
                        <% if (unreadCount > 0) { %>
                            <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                        <% } %>
                    </button>
                    <!-- Dropdown Menu -->
                    <div id="notif-dropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-2xl shadow-xl border border-slate-100 transition-all duration-300 z-[60] py-4">
                        <div class="flex items-center justify-between px-6 mb-4">
                            <h3 class="text-sm font-black text-slate-900">Notifications</h3>
                        </div>
                        <div class="max-h-64 overflow-y-auto px-2 space-y-1">
                            <% if (notifications.isEmpty()) { %>
                                <div class="py-10 text-center">
                                    <span class="material-symbols-outlined text-slate-200 text-4xl mb-2">notifications_off</span>
                                    <p class="text-xs font-medium text-slate-400">All caught up!</p>
                                </div>
                            <% } else { %>
                                <% for (Notification note : notifications) { 
                                    String noteReadClass = note.isRead() ? "opacity-60" : "bg-primary/5 hover:bg-primary/10";
                                    String noteIcon = "Success".equals(note.getType()) ? "check_circle" : "info";
                                %>
                                    <a href="mark_notification_read.jsp?id=<%= note.getId() %>" class="block p-3 rounded-xl transition-colors <%= noteReadClass %>">
                                        <div class="flex gap-3">
                                            <div>
                                                <p class="text-xs font-black text-slate-900"><%= note.getTitle() %></p>
                                                <p class="text-[10px] text-slate-500 line-clamp-2 mt-0.5"><%= note.getMessage() %></p>
                                            </div>
                                        </div>
                                    </a>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                </div>
                <a href="customer_profile.jsp" class="h-10 w-10 rounded-full overflow-hidden border-2 border-slate-100 shadow-sm cursor-pointer hover:border-primary transition-all">
                    <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= user.getFullName() %>" alt="Avatar" class="h-full w-full object-cover">
                </a>
            </div>
        </div>
    </header>

    <main class="max-w-6xl mx-auto p-6 md:p-10">
        <!-- Back navigation -->
        <a href="customer_explore_policies.jsp" class="inline-flex items-center gap-2 text-sm font-bold text-slate-500 hover:text-primary transition-colors mb-8">
            <span class="material-symbols-outlined text-sm">arrow_back</span>
            Back to Explore
        </a>

        <!-- Main Coverage -->
        <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-2xl shadow-slate-200/50 overflow-hidden flex flex-col md:flex-row">
            <!-- Left Side / Banner -->
            <div class="md:w-5/12 bg-slate-100 relative min-h-[300px] md:min-h-full basis-1/2">
                <img src="<%= imagePath %>" alt="<%= p.getPolicyName() %>"
                    onerror="this.onerror=null; this.src='<%= defaultImage %>';"
                    class="absolute inset-0 w-full h-full object-cover">
                <div class="absolute inset-0 bg-gradient-to-t from-slate-900/60 to-transparent flex items-end p-8">
                    <div class="inline-flex items-center gap-2 bg-white/20 backdrop-blur-md border border-white/30 text-white px-4 py-2 rounded-full">
                        <span class="material-symbols-outlined text-sm"><%= icon %></span>
                        <span class="text-xs font-black tracking-widest uppercase"><%= type %></span>
                    </div>
                </div>
            </div>

            <!-- Right Side / Details -->
            <div class="p-8 md:p-12 md:w-7/12 basis-1/2 flex flex-col">
                <h1 class="text-3xl md:text-5xl font-black text-slate-900 tracking-tight leading-none mb-4">
                    <%= p.getPolicyName() %>
                </h1>
                <p class="text-slate-500 text-sm leading-relaxed mb-10 pb-10 border-b border-slate-100 flex-1">
                    <%= p.getDescription() != null && !p.getDescription().isEmpty() ? p.getDescription() : "Comprehensive coverage plan designed to protect what matters most. Gain peace of mind knowing you and your loved ones are covered against unexpected events with our trusted policy framework." %>
                </p>

                <!-- Value Props -->
                <div class="grid grid-cols-2 gap-6 mb-10">
                    <div class="flex items-start gap-4">
                        <div class="h-12 w-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined">schedule</span>
                        </div>
                        <div>
                            <p class="text-[10px] uppercase font-black tracking-widest text-slate-400 mb-1 mt-1">Duration</p>
                            <p class="text-lg font-black text-slate-900"><%= p.getCoverageDuration() %></p>
                        </div>
                    </div>
                    <div class="flex items-start gap-4">
                        <div class="h-12 w-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined">payments</span>
                        </div>
                        <div>
                            <p class="text-[10px] uppercase font-black tracking-widest text-slate-400 mb-1 mt-1">Premium</p>
                            <p class="text-2xl font-black text-primary leading-none">GH₵<%= p.getPremiumAmount() %><span class="text-xs text-primary/60">/mo</span></p>
                        </div>
                    </div>
                </div>

                <!-- Call to action -->
                <a href="customer_enrollment_wizard.jsp?id=<%= p.getId() %>"
                    class="w-full py-5 bg-primary text-white hover:bg-primary-dark hover:scale-[1.02] shadow-xl shadow-primary/20 rounded-2xl text-base font-black transition-all flex items-center justify-center gap-3">
                    Enroll in Policy
                    <span class="material-symbols-outlined text-sm">arrow_forward</span>
                </a>
            </div>
        </div>
    </main>

    <!-- Multi-step enrollment wizard moves the checkout to a dedicated page -->
</body>
</html>
