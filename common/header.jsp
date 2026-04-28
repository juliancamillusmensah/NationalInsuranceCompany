<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.model.Account" %>
<%@ page import="com.insurance.model.Notification" %>
<%@ page import="java.util.List" %>
<%
    Account headerUser = (Account) session.getAttribute("user");
    List<Notification> headerNotifications = (List<Notification>) request.getAttribute("notifications");
    Integer unreadCount = (Integer) request.getAttribute("unreadNotifications");
    if (unreadCount == null) unreadCount = 0;
%>
<header class="h-20 xl:h-24 bg-white/80 backdrop-blur-md border-b border-slate-100 flex items-center justify-between px-4 sm:px-8 xl:px-12 sticky top-0 z-[40]">
    <div class="flex items-center gap-6 xl:hidden">
        <button onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')" class="p-2 text-slate-500 hover:bg-slate-50 rounded-xl transition-all">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </div>

    <div class="hidden xl:block">
        <h2 class="text-sm font-black text-slate-900 uppercase tracking-[0.2em]">
            <% 
                String role = (String) session.getAttribute("roleId");
                if ("ROLE_SUPERADMIN".equals(role)) out.print("Supervision Dashboard");
                else if ("ROLE_ADMIN".equals(role) || "ROLE_COMPANY_ADMIN".equals(role)) out.print("Insurer Portal");
                else out.print("Customer Dashboard");
            %>
        </h2>
    </div>

    <div class="flex items-center justify-end gap-4 xl:gap-8 w-full xl:w-auto">
        <form action="global_search.jsp" method="GET" class="relative hidden md:block w-72 lg:w-96 xl:w-[32rem]">
            <span class="material-symbols-outlined absolute left-5 top-1/2 -translate-y-1/2 text-slate-400 text-2xl">search</span>
            <input type="text" name="q" id="headerSearchInput" placeholder="Search resources..."
                class="w-full bg-slate-50 border-none rounded-2xl pl-14 pr-4 py-4 text-sm font-medium focus:ring-2 focus:ring-primary/20 transition-all placeholder:text-slate-400">
        </form>
        
        <div class="flex items-center gap-6">
            <!-- Notification Dropdown -->
            <div class="relative">
                <button id="notificationBtn" class="relative p-3 text-slate-400 hover:bg-slate-50 rounded-2xl transition-all">
                    <span class="material-symbols-outlined text-2xl">notifications</span>
                    <% if (unreadCount > 0) { %>
                        <span class="absolute top-3.5 right-3.5 w-2.5 h-2.5 bg-primary rounded-full border-2 border-white"></span>
                    <% } %>
                </button>
                
                <div id="notificationDropdown" class="hidden absolute right-0 mt-4 w-96 bg-white rounded-[2rem] shadow-2xl border border-slate-100 z-[110] overflow-hidden animate-in fade-in slide-in-from-top-2 duration-300">
                    <div class="p-6 border-b border-slate-50 flex items-center justify-between">
                        <h3 class="font-black text-slate-950">Notifications</h3>
                        <span class="text-[10px] bg-primary/10 text-primary px-3 py-1 rounded-full font-black uppercase"><%= unreadCount %> New</span>
                    </div>
                    <div class="max-h-[30rem] overflow-y-auto">
                        <% if (headerNotifications != null && !headerNotifications.isEmpty()) { 
                            for (Notification n : headerNotifications) { %>
                            <div class="p-6 hover:bg-slate-50 border-b border-slate-50 cursor-pointer transition-colors">
                                <h4 class="text-sm font-bold text-slate-950"><%= n.getTitle() %></h4>
                                <p class="text-xs text-slate-500 mt-1 leading-relaxed"><%= n.getMessage() %></p>
                                <span class="text-[10px] text-slate-400 font-bold mt-4 block uppercase tracking-wider"><%= n.getCreatedAt() %></span>
                            </div>
                        <% } } else { %>
                            <div class="py-12 text-center">
                                <div class="bg-slate-50 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                                    <span class="material-symbols-outlined text-slate-300 text-3xl">notifications_off</span>
                                </div>
                                <p class="text-sm text-slate-400 font-medium">No alerts today</p>
                            </div>
                        <% } %>
                    </div>
                    <div class="p-4 bg-slate-50/50 text-center">
                        <a href="#" class="text-xs font-black text-primary hover:underline uppercase tracking-widest">View All Insights</a>
                    </div>
                </div>
            </div>

            <!-- Profile Dropdown -->
            <div class="relative">
                <div id="profileBtn" class="flex items-center gap-4 cursor-pointer group">
                    <div class="flex flex-col text-right hidden sm:flex">
                        <span class="text-sm font-black text-slate-950 group-hover:text-primary transition-colors leading-none"><%= headerUser != null ? headerUser.getFullName() : "Guest" %></span>
                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest mt-1.5">
                            <%= role != null ? role.replace("ROLE_", "").replace("_", " ") : "Member" %>
                        </span>
                    </div>
                    <div class="h-12 w-12 rounded-2xl bg-slate-100 overflow-hidden shadow-sm border-2 border-transparent group-hover:border-primary transition-all duration-300">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= headerUser != null ? headerUser.getFullName() : "Guest" %>" class="h-full w-full object-cover">
                    </div>
                </div>

                <div id="profileDropdown" class="hidden absolute right-0 mt-4 w-64 bg-white rounded-[2rem] shadow-2xl border border-slate-100 z-[110] overflow-hidden animate-in fade-in slide-in-from-top-2 duration-300">
                    <div class="p-6 border-b border-slate-50 bg-slate-50/30">
                        <p class="text-sm font-black text-slate-950"><%= headerUser != null ? headerUser.getFullName() : "Guest" %></p>
                        <p class="text-[10px] font-bold text-slate-400 mt-1 uppercase tracking-wider"><%= headerUser != null ? headerUser.getEmail() : "" %></p>
                    </div>
                    <div class="p-3">
                        <a href="<%= (role != null && role.contains("CUSTOMER")) ? "customer_profile.jsp" : "account_settings.jsp" %>" class="flex items-center gap-4 px-4 py-3 text-slate-600 hover:bg-slate-50 rounded-2xl text-xs font-black transition-all">
                            <span class="material-symbols-outlined text-xl">settings</span> Personal Settings
                        </a>
                        <a href="logout.jsp" class="flex items-center gap-4 px-4 py-3 text-red-500 hover:bg-red-50 rounded-2xl text-xs font-black transition-all mt-1">
                            <span class="material-symbols-outlined text-xl">logout</span> End Session
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    // Simple Dropdown Toggle Logic
    document.addEventListener('DOMContentLoaded', function() {
        const profileBtn = document.getElementById('profileBtn');
        const profileDropdown = document.getElementById('profileDropdown');
        const notificationBtn = document.getElementById('notificationBtn');
        const notificationDropdown = document.getElementById('notificationDropdown');

        if(profileBtn) {
            profileBtn.onclick = (e) => {
                e.stopPropagation();
                profileDropdown.classList.toggle('hidden');
                notificationDropdown.classList.add('hidden');
            };
        }

        if(notificationBtn) {
            notificationBtn.onclick = (e) => {
                e.stopPropagation();
                notificationDropdown.classList.toggle('hidden');
                profileDropdown.classList.add('hidden');
            };
        }

        document.onclick = () => {
            if(profileDropdown) profileDropdown.classList.add('hidden');
            if(notificationDropdown) notificationDropdown.classList.add('hidden');
        };
    });
</script>
