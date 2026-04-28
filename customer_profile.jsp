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
                    Account user = (Account) sess.getAttribute("user");
                    String roleId = (String) sess.getAttribute("roleId");
                    String userId = (String) sess.getAttribute("userId");
                    
                    if (roleId == null || !roleId.contains("CUSTOMER")) {
                        response.sendRedirect("account_settings.jsp");
                        return;
                    }
                    
                    NotificationDAO noteDAO = new NotificationDAO();
                    List<Notification> notifications = noteDAO.getNotificationsByUserId(userId);
                    int unreadCount = noteDAO.getUnreadCount(userId);
                %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>My Profile - NIC Insurance</title>
                            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                rel="stylesheet" />
                            <link
                                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                                rel="stylesheet" />
                            <script id="tailwind-config">
                                tailwind.config = {
                                    darkMode: "class",
                                    theme: {
                                        extend: {
                                            colors: {
                                                "primary": "#1152d4",
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
                                body {
                                    font-family: 'Inter', sans-serif;
                                }

                                .material-symbols-outlined {
                                    font-size: 20px;
                                    vertical-align: middle;
                                }
                            </style>
                        </head>

                        <body class="bg-background-light text-slate-900 antialiased min-h-screen">
                            <!-- Main Header -->
                            <header
                                class="bg-white border-b border-slate-100 h-auto lg:h-20 flex flex-col lg:flex-row lg:items-center px-6 lg:px-10 py-4 lg:py-0 sticky top-0 z-50 overflow-hidden shadow-sm gap-4">
                                <div class="flex items-center justify-between w-full lg:w-auto">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-primary p-2 rounded-lg text-white">
                                            <span class="material-symbols-outlined">shield</span>
                                        </div>
                                        <span
                                            class="text-xl font-black tracking-tight text-slate-900 border-r border-slate-200 lg:pr-4">Customer
                                            Portal</span>
                                    </div>
                                    <button onclick="document.getElementById('mobile-nav').classList.toggle('hidden')" class="md:hidden p-2 text-slate-500">
                                        <span class="material-symbols-outlined">menu</span>
                                    </button>
                                </div>

                                <nav id="mobile-nav" class="hidden md:flex flex-col md:flex-row items-start md:items-center gap-4 md:gap-8 w-full lg:w-auto">
                                    <a href="Customerportal.jsp" class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">My Coverage</a>
                                    <a href="customer_explore_policies.jsp"
                                        class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Explore
                                        Policies</a>
                                    <a href="customer_support.jsp"
                                        class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Support</a>
                                </nav>

                                <div class="ml-auto flex items-center justify-between lg:justify-end gap-6 w-full lg:w-auto">
                                    <form action="customer_explore_policies.jsp" method="get" class="relative w-full lg:w-72">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                        <input type="text" name="q" placeholder="Search policies..."
                                            class="w-full bg-slate-50 border-none rounded-xl pl-10 pr-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
                                    </form>
                                    <div class="flex items-center gap-6">
                                        <!-- Notification Dropdown -->
                                        <div class="relative group">
                                            <button
                                                onclick="document.getElementById('notif-dropdown').classList.toggle('hidden')"
                                                class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                                                <span class="material-symbols-outlined">notifications</span>
                                                <% if (unreadCount > 0) { %>
                                                    <span
                                                        class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                                                <% } %>
                                            </button>
                                            
                                            <!-- Dropdown Menu -->
                                            <div id="notif-dropdown" class="hidden absolute right-0 mt-2 w-80 bg-white rounded-2xl shadow-xl border border-slate-100 transition-all duration-300 z-[60] py-4">
                                                <div class="flex items-center justify-between px-6 mb-4">
                                                    <h3 class="text-sm font-black text-slate-900">Notifications</h3>
                                                    <% if (unreadCount > 0) { %>
                                                        <span class="text-[10px] font-bold bg-primary/10 text-primary px-2 py-0.5 rounded-full"><%= unreadCount %> New</span>
                                                    <% } %>
                                                </div>
                                                
                                                <div class="max-h-64 overflow-y-auto px-2 space-y-1">
                                                    <% if (notifications.isEmpty()) { %>
                                                        <div class="py-10 text-center">
                                                            <span class="material-symbols-outlined text-slate-200 text-4xl mb-2">notifications_off</span>
                                                            <p class="text-xs font-medium text-slate-400">All caught up!</p>
                                                        </div>
                                                    <% } else { %>
                                                        <% for (Notification note : notifications) { %>
                                                            <a href="mark_notification_read.jsp?id=<%= note.getId() %>" class="block p-3 rounded-xl transition-colors <%= note.isRead() ? "opacity-60" : "bg-primary/5 hover:bg-primary/10" %>">
                                                                <div class="flex gap-3">
                                                                    <div class="h-8 w-8 rounded-lg flex items-center justify-center shrink-0 <%= "Success".equals(note.getType()) ? "bg-emerald-100 text-emerald-600" : "bg-blue-100 text-blue-600" %>">
                                                                        <span class="material-symbols-outlined text-sm"><%= "Success".equals(note.getType()) ? "check_circle" : "info" %></span>
                                                                    </div>
                                                                    <div>
                                                                        <p class="text-xs font-black text-slate-900"><%= note.getTitle() %></p>
                                                                        <p class="text-[10px] text-slate-500 line-clamp-2 mt-0.5"><%= note.getMessage() %></p>
                                                                        <p class="text-[9px] font-bold text-slate-400 mt-1 uppercase"><%= new java.text.SimpleDateFormat("MMM dd, HH:mm").format(note.getCreatedAt()) %></p>
                                                                    </div>
                                                                </div>
                                                            </a>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                                
                                                <% if (!notifications.isEmpty()) { %>
                                                <div class="px-6 mt-4 pt-4 border-t border-slate-50">
                                                    <a href="clear_notifications_process.jsp" class="block w-full text-center py-2 text-[10px] font-black text-slate-400 uppercase tracking-widest hover:text-primary transition-colors">Clear All</a>
                                                </div>
                                                <% } %>
                                            </div>
                                        </div>
                                        <a href="customer_profile.jsp"
                                            class="h-10 w-10 rounded-full overflow-hidden border-2 border-primary shadow-sm cursor-pointer hover:scale-105 transition-all">
                                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= user.getFullName() %>" alt="Avatar"
                                                class="h-full w-full object-cover">
                                        </a>
                                        <a href="${pageContext.request.contextPath}/logout.jsp" class="p-2 text-slate-400 hover:text-red-500 transition-colors" title="Sign Out">
                                            <span class="material-symbols-outlined text-2xl">logout</span>
                                        </a>
                                    </div>
                                </div>
                            </header>

                            <main class="max-w-4xl mx-auto p-6 lg:p-10 space-y-10">
                                <% if ("update".equals(request.getParameter("success"))) { %>
                                    <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-6 py-4 rounded-2xl flex items-center gap-3">
                                        <span class="material-symbols-outlined text-emerald-600">check_circle</span>
                                        <p class="font-bold">Profile updated successfully!</p>
                                    </div>
                                <% } %>

                                <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
                                    <!-- Sidebar info -->
                                    <div class="md:col-span-1 space-y-6">
                                        <div class="bg-white rounded-[2.5rem] p-8 border border-slate-100 shadow-sm text-center">
                                            <div class="h-24 w-24 rounded-full overflow-hidden border-4 border-slate-50 shadow-md mx-auto mb-4">
                                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Alex" alt="Avatar" class="h-full w-full object-cover">
                                            </div>
                                            <h2 class="text-xl font-black text-slate-900"><%= user.getFullName() %></h2>
                                            <p class="text-xs font-bold text-primary px-3 py-1 bg-primary/10 rounded-full inline-block mt-2">Premium Member</p>
                                            
                                            <div class="mt-8 pt-6 border-t border-slate-100 text-left space-y-4">
                                                <div>
                                                    <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Status</p>
                                                    <p class="text-sm font-black text-emerald-600"><%= user.getStatus() != null ? user.getStatus() : "Active" %></p>
                                                </div>
                                                <div>
                                                    <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Member Since</p>
                                                    <p class="text-sm font-black text-slate-900"><%= user.getCreatedAt() != null ? new java.text.SimpleDateFormat("MMMM dd, yyyy").format(user.getCreatedAt()) : "March 2026" %></p>
                                                </div>
                                                <div>
                                                    <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider">Identity Verification</p>
                                                    <% 
                                                        String kycStatus = user.getKycStatus() != null ? user.getKycStatus() : "Not Started";
                                                        String kycColor = "text-slate-400";
                                                        if ("Verified".equalsIgnoreCase(kycStatus)) kycColor = "text-emerald-600";
                                                        else if ("Pending".equalsIgnoreCase(kycStatus)) kycColor = "text-amber-500";
                                                        else if ("Rejected".equalsIgnoreCase(kycStatus)) kycColor = "text-red-500";
                                                    %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Main Profile Content -->
                                    <div class="md:col-span-2 space-y-8">
                                        <!-- Identity Verification Card -->
                                        <div class="bg-white rounded-[2.5rem] p-8 lg:p-10 border border-slate-100 shadow-xl shadow-slate-200/50">
                    <div class="flex items-center justify-between mb-8">
                        <h1 class="text-2xl font-black text-slate-950">Identity Verification</h1>
                        <span class="material-symbols-outlined text-slate-300">verified_user</span>
                    </div>

                    <% if ("Verified".equalsIgnoreCase(user.getKycStatus())) { %>
                        <div class="bg-emerald-50/50 border border-emerald-100 p-8 rounded-[2rem] text-center">
                            <div class="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 mx-auto mb-4">
                                <span class="material-symbols-outlined text-3xl">verified</span>
                            </div>
                            <h3 class="text-lg font-black text-slate-900">Your identity is verified</h3>
                            <p class="text-sm text-slate-500 mt-2 max-w-xs mx-auto">Thank you for securing your account. You have full access to all NIC premium features.</p>
                        </div>
                    <% } else if ("Pending".equalsIgnoreCase(user.getKycStatus())) { %>
                        <div class="bg-amber-50/50 border border-amber-100 p-8 rounded-[2rem] text-center">
                            <div class="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center text-amber-600 mx-auto mb-4 animate-pulse">
                                <span class="material-symbols-outlined text-3xl">hourglass_empty</span>
                            </div>
                            <h3 class="text-lg font-black text-slate-900">Verification in progress</h3>
                            <p class="text-sm text-slate-500 mt-2 max-w-xs mx-auto">Our compliance team is currently reviewing your documents. This usually takes 24-48 hours.</p>
                        </div>
                    <% } else { %>
                        <% if ("Rejected".equalsIgnoreCase(user.getKycStatus())) { %>
                            <div class="bg-red-50 border border-red-100 p-6 rounded-2xl mb-8 flex gap-4">
                                <span class="material-symbols-outlined text-red-500">error</span>
                                <div>
                                    <p class="text-sm font-black text-red-900">Verification Rejected</p>
                                    <p class="text-xs text-red-800 opacity-80 mt-1">The documents you provided were unclear or invalid. Please re-upload your ID and a clear portrait.</p>
                                </div>
                            </div>
                        <% } %>

                        <form action="SubmitKYCServlet" method="post" enctype="multipart/form-data" class="space-y-8">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <div class="space-y-4">
                                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Identity Document Type</label>
                                    <select name="docType" required class="w-full bg-slate-50 border-none rounded-2xl p-4 text-sm font-black focus:ring-4 focus:ring-primary/10 transition-all">
                                        <option value="Ghana Card">Ghana Card (National ID)</option>
                                        <option value="Passport">International Passport</option>
                                        <option value="Voter ID">Voter ID Card</option>
                                    </select>
                                </div>
                                <div class="space-y-4">
                                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Upload ID Document</label>
                                    <input type="file" name="idCard" required accept="image/*,.pdf" class="block w-full text-xs text-slate-500 file:mr-4 file:py-3 file:px-6 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:uppercase file:bg-primary/5 file:text-primary hover:file:bg-primary/10 transition-all">
                                </div>
                            </div>

                            <div class="space-y-4 pt-6 border-t border-slate-50">
                                <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-sm">face</span> Portrait Photo Verification
                                </label>
                                <p class="text-xs text-slate-500 font-medium mb-4">Please upload a clear, front-facing portrait of yourself so we can verify it matches your ID.</p>
                                <input type="file" name="portrait" required accept="image/*" class="block w-full text-xs text-slate-500 file:mr-4 file:py-3 file:px-6 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:uppercase file:bg-primary/5 file:text-primary hover:file:bg-primary/10 transition-all">
                            </div>

                            <button type="submit" class="w-full py-4 bg-primary text-white rounded-2xl text-sm font-black hover:bg-primary/90 shadow-2xl shadow-primary/20 transition-all flex items-center justify-center gap-2 mt-4">
                                <span class="material-symbols-outlined text-lg">cloud_upload</span> Submit for Review
                            </button>
                        </form>
                    <% } %>
                </div>

                <div class="bg-white rounded-[2.5rem] p-8 lg:p-10 border border-slate-100 shadow-xl shadow-slate-200/50">
                    <h1 class="text-2xl font-black text-slate-950 mb-8">Personal Information</h1>
                    
                    <form action="profile_update_process.jsp" method="post" class="space-y-6">
                        <input type="hidden" name="action" value="update_profile">
                        <div class="space-y-4">
                            <div class="space-y-2">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Full Name</label>
                                <div class="relative">
                                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">person</span>
                                    <input type="text" name="fullName" value="<%= user.getFullName() %>" 
                                        class="w-full bg-slate-50 border border-slate-100 rounded-2xl pl-12 pr-4 py-4 text-sm focus:ring-2 focus:ring-primary outline-none transition-all font-medium" required>
                                </div>
                            </div>

                            <div class="space-y-2">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Email Address</label>
                                <div class="relative">
                                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">mail</span>
                                    <input type="email" name="email" value="<%= user.getEmail() %>" 
                                        class="w-full bg-slate-50 border border-slate-100 rounded-2xl pl-12 pr-4 py-4 text-sm focus:ring-2 focus:ring-primary outline-none transition-all font-medium" required>
                                </div>
                            </div>
                        </div>

                        <div class="pt-4">
                            <button type="submit" 
                                class="w-full py-4 bg-slate-900 text-white rounded-2xl text-sm font-black hover:bg-slate-800 shadow-lg shadow-slate-900/10 transition-all flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-sm">save_as</span> Save Changes
                            </button>
                        </div>
                    </form>

                    <div class="mt-12 pt-8 border-t border-slate-100">
                        <h2 class="text-lg font-black text-slate-900 mb-4">Security</h2>
                        <form action="profile_update_process.jsp" method="post" class="space-y-4">
                            <input type="hidden" name="action" value="update_password">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div class="space-y-2">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">New Password</label>
                                    <input type="password" name="newPassword" required class="w-full bg-slate-50 border border-slate-100 rounded-2xl px-4 py-4 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                                </div>
                                <div class="space-y-2">
                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Confirm Password</label>
                                    <input type="password" name="confirmPassword" required class="w-full bg-slate-50 border border-slate-100 rounded-2xl px-4 py-4 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                                </div>
                            </div>
                            <button type="submit" class="px-6 py-4 bg-slate-100 text-slate-900 rounded-2xl text-xs font-black hover:bg-slate-200 transition-all">Update Security</button>
                        </form>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
                                <script>
                                    // Close dropdown when clicking outside
                                    window.onclick = function(event) {
                                        if (!event.target.closest('.group')) {
                                            const dropdown = document.getElementById('notif-dropdown');
                                            if (dropdown && !dropdown.classList.contains('hidden')) {
                                                dropdown.classList.add('hidden');
                                            }
                                        }
                                    }
                                </script>
                            </body>

                        </html>
