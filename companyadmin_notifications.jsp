<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    NotificationDAO notificationDAO = new NotificationDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    List<Notification> allNotifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - My Notifications</title>
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
    <div class="flex flex-col xl:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50 min-w-0 overflow-x-hidden">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-12">
                <div class="max-w-5xl mx-auto w-full space-y-10">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-6">
                        <div class="flex items-center gap-4 xl:gap-6">
                            <a href="Companyadmin.jsp" class="h-12 w-12 flex items-center justify-center bg-white border border-slate-100 rounded-2xl text-slate-400 hover:text-primary hover:border-primary/20 transition-all group shrink-0 shadow-sm">
                                <span class="material-symbols-outlined text-2xl group-hover:-translate-x-1 transition-transform">arrow_back</span>
                            </a>
                            <div class="h-8 w-px bg-slate-200 hidden sm:block"></div>
                            <div>
                                <h2 class="text-3xl font-black text-slate-950">Historical Alerts</h2>
                                <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em] mt-1">Audit Trail & System Events</p>
                            </div>
                        </div>
                        <div class="inline-flex items-center gap-3 bg-white px-6 py-3 rounded-2xl border border-slate-100 shadow-sm self-start sm:self-auto">
                            <span class="w-2 h-2 bg-primary rounded-full <%= unreadNotifications > 0 ? "animate-pulse" : "opacity-30" %>"></span>
                            <span class="text-[10px] font-black text-slate-950 uppercase tracking-widest"><%= unreadNotifications %> Unread Alerts</span>
                        </div>
                    </div>

                    <div class="space-y-4 lg:space-y-6">
                        <% if (allNotifications != null && !allNotifications.isEmpty()) { 
                            for (Notification note : allNotifications) { %>
                        <div class="bg-white rounded-[2rem] lg:rounded-[2.5rem] border border-slate-100 p-6 lg:p-8 flex items-start gap-6 hover:shadow-xl hover:shadow-primary/5 transition-all relative overflow-hidden group">
                            <div class="p-4 rounded-2xl <%= !note.isRead() ? "bg-primary/5 text-primary" : "bg-slate-50 text-slate-400" %> shrink-0">
                                <span class="material-symbols-outlined text-2xl"><%= !note.isRead() ? "notification_important" : "notifications" %></span>
                            </div>
                            <div class="flex-1 min-w-0">
                                <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-2 gap-1">
                                    <h3 class="text-sm lg:text-base font-black text-slate-950 truncate"><%= note.getTitle() %></h3>
                                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest sm:shrink-0"><%= note.getCreatedAt() %></span>
                                </div>
                                <p class="text-xs lg:text-sm text-slate-500 leading-relaxed max-w-2xl"><%= note.getMessage() %></p>
                                
                                <% if (!note.isRead()) { %>
                                <div class="mt-6 flex items-center gap-4">
                                    <button class="px-5 py-2.5 bg-slate-50 hover:bg-slate-100 text-primary text-[10px] font-black uppercase tracking-widest rounded-xl transition-all">
                                        Mark as seen
                                    </button>
                                </div>
                                <% } %>
                            </div>
                            
                            <% if (!note.isRead()) { %>
                            <div class="absolute top-0 right-0 p-1">
                                <div class="w-3 h-3 bg-primary rounded-full border-2 border-white shadow-sm"></div>
                            </div>
                            <% } %>
                        </div>
                        <% } } else { %>
                        <div class="p-20 text-center bg-white rounded-[3rem] border border-slate-100 shadow-sm">
                            <div class="inline-flex p-6 bg-slate-50 rounded-[2rem] mb-6">
                                <span class="material-symbols-outlined text-slate-200 text-6xl">notifications_off</span>
                            </div>
                            <h3 class="text-xl font-black text-slate-950 mb-2">No alerts found</h3>
                            <p class="text-slate-500 max-w-xs mx-auto text-sm">You're all caught up! When system events occur, they'll appear here for your review.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <jsp:include page="common/footer.jsp" />
        </main>
    </div>
</body>
</html>
