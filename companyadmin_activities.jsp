<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.stream.Collectors" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    SystemDAO systemDAO = new SystemDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
    List<Notification> topNotifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    String filterParam = request.getParameter("filter");
    if (filterParam == null) filterParam = "all";
    final String filter = filterParam;

    String companyId = (String) sess.getAttribute("companyId");
    List<DashboardActivity> allActivities = (companyId != null) ? systemDAO.getRecentActivitiesByCompany(50, companyId) : new ArrayList<>();
    List<DashboardActivity> filteredActivities = allActivities;

    if (!"all".equals(filter)) {
        filteredActivities = allActivities.stream()
            .filter(a -> {
                String title = a.getTitle().toLowerCase();
                if ("claims".equals(filter)) return title.contains("claim");
                if ("payments".equals(filter)) return title.contains("payment");
                if ("enrollments".equals(filter)) return title.contains("enrollment");
                if ("policies".equals(filter)) return title.contains("policy");
                return true;
            })
            .collect(Collectors.toList());
    }
%>
<%!
    public String getTimeAgo(java.sql.Timestamp ts) {
        if (ts == null) return "Unknown time";
        long diff = System.currentTimeMillis() - ts.getTime();
        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;

        if (seconds < 60) return "Just now";
        if (minutes < 60) return minutes + " mins ago";
        if (hours < 24) return hours + " hours ago";
        return days + " days ago";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Platform Activity Log</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
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
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col lg:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50">
            <jsp:include page="common/header.jsp" />

            <div class="p-6 lg:p-10 space-y-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-4">
                    <div>
                        <h2 class="text-3xl font-black text-slate-950">Platform Activity Log</h2>
                        <p class="text-xs text-slate-500 font-bold uppercase tracking-[0.2em] mt-1">Real-time Regulatory Monitoring</p>
                    </div>
                    <div class="flex items-center gap-2 overflow-x-auto pb-2 md:pb-0">
                        <a href="?filter=all" class="px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all <%= "all".equals(filter) ? "bg-primary text-white shadow-lg shadow-primary/20" : "bg-white text-slate-500 hover:bg-slate-50 border border-slate-100" %>">Global</a>
                        <a href="?filter=claims" class="px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all <%= "claims".equals(filter) ? "bg-red-500 text-white shadow-lg shadow-red-500/20" : "bg-white text-slate-500 hover:bg-slate-50 border border-slate-100" %>">Claims</a>
                        <a href="?filter=payments" class="px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all <%= "payments".equals(filter) ? "bg-blue-600 text-white shadow-lg shadow-blue-600/20" : "bg-white text-slate-500 hover:bg-slate-50 border border-slate-100" %>">Payments</a>
                        <a href="?filter=policies" class="px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all <%= "policies".equals(filter) ? "bg-emerald-600 text-white shadow-lg shadow-emerald-600/20" : "bg-white text-slate-500 hover:bg-slate-50 border border-slate-100" %>">Policies</a>
                    </div>
                </div>

            <div class="flex-1 p-10 space-y-6">
                <% if (filteredActivities != null && !filteredActivities.isEmpty()) { 
                    for (DashboardActivity activity : filteredActivities) { %>
                <div class="flex items-start gap-4 p-5 bg-white rounded-3xl border border-slate-100 shadow-sm hover:shadow-md transition-all duration-300">
                    <div class="p-3 <%= activity.getColorClass() %> rounded-2xl">
                        <span class="material-symbols-outlined text-2xl"><%= activity.getIcon() %></span>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center justify-between">
                            <h4 class="text-base font-bold text-slate-900"><%= activity.getTitle() %></h4>
                            <span class="text-xs font-black text-slate-400 uppercase tracking-widest"><%= getTimeAgo(activity.getTimestamp()) %></span>
                        </div>
                        <p class="text-sm text-slate-500 mt-1"><%= activity.getDescription() %></p>
                    </div>
                </div>
                <% } } else { %>
                <div class="flex flex-col items-center justify-center py-20 text-center">
                    <div class="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
                        <span class="material-symbols-outlined text-4xl text-slate-300">history</span>
                    </div>
                    <h3 class="text-lg font-bold text-slate-900">No activities found</h3>
                    <p class="text-sm text-slate-500 max-w-xs mx-auto mt-1">Try adjusting your filters or check back later as platform actions occur.</p>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
