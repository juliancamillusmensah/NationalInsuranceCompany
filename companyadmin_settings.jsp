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
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
    List<Notification> topNotifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    
    SystemDAO systemDAO = new SystemDAO();
    String companyId = systemDAO.getCompanyIdByUserId(currentUser.getId());
    CompanySettings settings = systemDAO.getCompanySettings(companyId);
    
    CompanyDAO companyDAO = new CompanyDAO();
    Company currentCompany = companyDAO.getCompanyById(companyId);
    
    List<TeamMember> teamMembers = systemDAO.getTeamMembersByCompanyId(companyId);
    List<AdminInvitation> invitations = systemDAO.getInvitationsByCompanyId(companyId);

    // Fetch Bank Details (In-lined to bypass Java model limitations)
    String bankName = "";
    String accName = "";
    String accNum = "";
    try (java.sql.Connection conn = com.insurance.util.DBConnection.getConnection();
         java.sql.PreparedStatement pstmt = conn.prepareStatement("SELECT bank_name, account_name, account_number FROM insurance_companies WHERE id = ?")) {
        pstmt.setString(1, companyId);
        try (java.sql.ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                bankName = rs.getString("bank_name");
                accName = rs.getString("account_name");
                accNum = rs.getString("account_number");
                if (bankName == null) bankName = "";
                if (accName == null) accName = "";
                if (accNum == null) accNum = "";
            }
        }
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Settings</title>
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
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
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
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col lg:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 space-y-10">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <h2 class="text-3xl font-black text-slate-950">Admin Settings</h2>
                        <p class="text-xs text-slate-500 font-bold uppercase tracking-[0.2em] mt-1">System Governance & Control</p>
                    </div>
                    <button onclick="document.getElementById('settingsForm').submit()" class="bg-primary text-white px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-primary/90 transition-all flex items-center justify-center gap-3 shadow-2xl shadow-primary/20 w-full md:w-auto">
                        <span class="material-symbols-outlined text-xl">save</span>
                        Save Configuration
                    </button>
                </div>

            <div class="flex-1 p-6 lg:p-10 space-y-10">
                <% 
                    String successMsg = request.getParameter("success");
                    String errorMsg = request.getParameter("error");
                    if ("invited".equals(successMsg)) {
                %>
                    <div class="p-4 mb-4 text-sm text-emerald-800 rounded-2xl bg-emerald-50 border border-emerald-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-emerald-500">check_circle</span>
                        <span class="font-bold">Admin invitation sent successfully!</span>
                    </div>
                <% } else if ("settings_updated".equals(successMsg)) { %>
                    <div class="p-4 mb-4 text-sm text-emerald-800 rounded-2xl bg-emerald-50 border border-emerald-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-emerald-500">check_circle</span>
                        <span class="font-bold">System preferences updated successfully!</span>
                    </div>
                <% } else if ("invalid_input".equals(errorMsg)) { %>
                    <div class="p-4 mb-4 text-sm text-red-800 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-red-500">error</span>
                        <span class="font-bold">Please provide a valid email and role.</span>
                    </div>
                <% } else if ("db_error".equals(errorMsg)) { %>
                    <div class="p-4 mb-4 text-sm text-red-800 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-red-500">error</span>
                        <span class="font-bold">An error occurred while saving the invitation. Please try again.</span>
                    </div>
                <% } else if ("status_updated".equals(successMsg)) { %>
                    <div class="p-4 mb-4 text-sm text-emerald-800 rounded-2xl bg-emerald-50 border border-emerald-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-emerald-500">verified_user</span>
                        <span class="font-bold">Account status updated successfully.</span>
                    </div>
                <% } else if (errorMsg != null && errorMsg.contains("failed")) { %>
                    <div class="p-4 mb-4 text-sm text-red-800 rounded-2xl bg-red-50 border border-red-200 flex items-center gap-3">
                        <span class="material-symbols-outlined text-red-500">block</span>
                        <span class="font-bold">Failed to update account status.</span>
                    </div>
                <% } %>
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-10">
                    <div id="registration-section" class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-8 flex flex-col justify-between">
                        <div>
                            <div class="flex items-center gap-4 mb-8">
                                <div class="p-3 bg-indigo-50 text-indigo-600 rounded-xl">
                                    <span class="material-symbols-outlined">badge</span>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-900">Registration Details</h3>
                                    <p class="text-xs font-bold text-slate-500 mt-1">Official regulatory classification and license.</p>
                                </div>
                            </div>
                            
                            <div class="space-y-6">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Entity Name</label>
                                    <div class="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-sm font-bold text-slate-700">
                                        <%= currentCompany != null ? currentCompany.getName() : "N/A" %>
                                    </div>
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Market Category</label>
                                        <div class="w-full px-4 py-3 bg-primary/5 border border-primary/10 rounded-xl text-xs font-black text-primary uppercase">
                                            <%= currentCompany != null ? currentCompany.getCompanyType() : "N/A" %>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License No.</label>
                                        <div class="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-xs font-bold text-slate-600">
                                            <%= currentCompany != null ? currentCompany.getLicenseNumber() : "NIC-XXXXXX" %>
                                        </div>
                                    </div>
                                </div>
                             </div>
                         </div>
                         
                         <!-- License Management -->
                         <hr class="my-8 border-slate-50">
                         <div class="flex items-center gap-4 mb-6">
                             <div class="p-3 bg-primary/10 text-primary rounded-xl">
                                 <span class="material-symbols-outlined text-xl">verified_user</span>
                             </div>
                             <h4 class="text-sm font-bold text-slate-900">License Lifecycle</h4>
                         </div>
                         
                         <div class="space-y-4">
                             <div class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl">
                                 <div>
                                     <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Commission Status</p>
                                     <p class="text-sm font-bold text-slate-700 mt-1"><%= currentCompany.getComplianceStatus() %></p>
                                 </div>
                                 <div class="px-3 py-1 <%= "Compliant".equalsIgnoreCase(currentCompany.getComplianceStatus()) ? "bg-emerald-50 text-emerald-600" : "bg-red-50 text-red-600" %> rounded-full text-[9px] font-black uppercase">
                                     <%= currentCompany.getComplianceStatus() %>
                                 </div>
                             </div>
                             
                             <div class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl">
                                 <div>
                                     <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Valid Until</p>
                                     <p class="text-sm font-bold text-slate-700 mt-1"><%= currentCompany.getLicenseExpiry() %></p>
                                 </div>
                                 <form action="license_renewal_checkout.jsp" method="POST">
                                     <input type="hidden" name="companyId" value="<%= companyId %>">
                                     <button type="submit" class="px-4 py-2 bg-slate-900 text-white rounded-xl text-[10px] font-black uppercase hover:bg-slate-800 transition-colors">Renew License</button>
                                 </form>
                             </div>
                         </div>

                         <p class="text-[10px] font-medium text-slate-400 mt-8 italic">To update registration details, please contact the National Insurance Commission (NIC) support desk.</p>
                     </div>

                    <!-- Settlement & Bank Details -->
                    <div id="bank-section" class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-8">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="p-3 bg-emerald-50 text-emerald-600 rounded-xl">
                                <span class="material-symbols-outlined">account_balance</span>
                            </div>
                            <div>
                                <h3 class="text-xl font-bold text-slate-900">Settlement Account</h3>
                                <p class="text-xs font-bold text-slate-500 mt-1">Configure the corporate account for regulatory debits.</p>
                            </div>
                        </div>
                        
                        <form action="update_bank_details_process.jsp" method="POST" class="space-y-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="md:col-span-2">
                                    <label class="block text-xs font-black text-slate-900 uppercase tracking-widest mb-2">Corporate Bank</label>
                                    <input type="text" name="bankName" value="<%= bankName %>" placeholder="e.g. GCB Bank, Ecobank" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500 transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-black text-slate-900 uppercase tracking-widest mb-2">Account Name</label>
                                    <input type="text" name="accName" value="<%= accName %>" placeholder="Official business name" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500 transition-all">
                                </div>
                                <div>
                                    <label class="block text-xs font-black text-slate-900 uppercase tracking-widest mb-2">Account Number</label>
                                    <input type="text" name="accNum" value="<%= accNum %>" placeholder="Settlement account ID" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500 transition-all">
                                </div>
                            </div>
                            <button type="submit" class="w-full py-4 bg-emerald-600 text-white rounded-2xl text-sm font-bold hover:bg-emerald-700 transition-colors shadow-lg shadow-emerald-600/20">Update Settlement Details</button>
                        </form>
                    </div>

                    <!-- Invite Section -->
                    <div id="invite-section" class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-8">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="p-3 bg-primary/10 text-primary rounded-xl">
                                <span class="material-symbols-outlined">person_add</span>
                            </div>
                            <div>
                                <h3 class="text-xl font-bold text-slate-900">Invite Administrator</h3>
                                <p class="text-xs font-bold text-slate-500 mt-1">Send a registration link to a new team member.</p>
                            </div>
                        </div>
                        
                        <form action="admin_invite_process.jsp" method="POST" class="space-y-6">
                            <div>
                                <label class="block text-xs font-black text-slate-900 uppercase tracking-widest mb-2">Email Address</label>
                                <input type="email" name="email" required placeholder="colleague@company.com" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-black text-slate-900 uppercase tracking-widest mb-2">Access Level</label>
                                <select name="role" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-primary/50 focus:border-primary transition-all appearance-none cursor-pointer">
                                    <option value="companyadmin">Company Administrator</option>
                                    <option value="support">Customer Support Agent</option>
                                    <option value="auditor">Financial Auditor</option>
                                </select>
                            </div>
                            <button type="submit" class="w-full py-4 bg-slate-900 text-white rounded-2xl text-sm font-bold hover:bg-slate-800 transition-colors shadow-lg shadow-slate-900/20">Send Security Invitation</button>
                        </form>
                    </div>

                    <!-- Notification Preferences -->
                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-8">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="p-3 bg-amber-50 text-amber-600 rounded-xl">
                                <span class="material-symbols-outlined">tune</span>
                            </div>
                            <div>
                                <h3 class="text-xl font-bold text-slate-900">System Preferences</h3>
                                <p class="text-xs font-bold text-slate-500 mt-1">Configure automated reporting and alerts.</p>
                            </div>
                        </div>

                        <form id="settingsForm" action="update_settings_process.jsp" method="POST" class="space-y-6">
                            <label class="flex items-center justify-between p-4 bg-slate-50 rounded-xl cursor-pointer hover:bg-slate-100 transition-colors">
                                <div>
                                    <p class="text-sm font-bold text-slate-900">Daily Digest Email</p>
                                    <p class="text-[10px] font-semibold text-slate-500 mt-1">Receive a summary of all new policies.</p>
                                </div>
                                <div class="relative">
                                    <input type="checkbox" name="dailyDigest" class="sr-only peer" <%= settings.isDailyDigest() ? "checked" : "" %>>
                                    <div class="block bg-slate-200 w-10 h-6 rounded-full peer-checked:bg-primary transition-colors"></div>
                                    <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition transform peer-checked:translate-x-4"></div>
                                </div>
                            </label>
                            
                            <label class="flex items-center justify-between p-4 bg-slate-50 rounded-xl cursor-pointer hover:bg-slate-100 transition-colors">
                                <div>
                                    <p class="text-sm font-bold text-slate-900">Financial Alerts</p>
                                    <p class="text-[10px] font-semibold text-slate-500 mt-1">Notify immediately on failed transactions.</p>
                                </div>
                                <div class="relative">
                                    <input type="checkbox" name="financialAlerts" class="sr-only peer" <%= settings.isFinancialAlerts() ? "checked" : "" %>>
                                    <div class="block bg-slate-200 w-10 h-6 rounded-full peer-checked:bg-primary transition-colors"></div>
                                    <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition transform peer-checked:translate-x-4"></div>
                                </div>
                            </label>

                            <label class="flex items-center justify-between p-4 bg-slate-50 rounded-xl cursor-pointer hover:bg-slate-100 transition-colors">
                                <div>
                                    <p class="text-sm font-bold text-slate-900">SMS Notifications</p>
                                    <p class="text-[10px] font-semibold text-slate-500 mt-1">Send critical security alerts to mobile.</p>
                                </div>
                                <div class="relative">
                                    <input type="checkbox" name="smsNotifications" class="sr-only peer" <%= settings.isSmsNotifications() ? "checked" : "" %>>
                                    <div class="block bg-slate-200 w-10 h-6 rounded-full peer-checked:bg-primary transition-colors"></div>
                                    <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition transform peer-checked:translate-x-4"></div>
                                </div>
                            </label>

                            <label class="flex items-center justify-between p-4 bg-indigo-50/50 rounded-xl cursor-pointer hover:bg-indigo-50 transition-colors border border-indigo-100/50">
                                <div>
                                    <p class="text-sm font-bold text-slate-900">Privacy Mode</p>
                                    <p class="text-[10px] font-semibold text-slate-500 mt-1 italic">Hide company policies from the Superadmin's global list.</p>
                                </div>
                                <div class="relative">
                                    <input type="checkbox" name="hideFromSuperadmin" class="sr-only peer" <%= settings.isHideFromSuperadmin() ? "checked" : "" %>>
                                    <div class="block bg-slate-200 w-10 h-6 rounded-full peer-checked:bg-indigo-500 transition-colors"></div>
                                    <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition transform peer-checked:translate-x-4"></div>
                                </div>
                            </label>
                        </form>
                    </div>
                </div>

                <!-- Workforce Management Section -->
                <div class="space-y-10">
                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                        <div class="p-8 border-b border-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                            <div class="flex items-center gap-4">
                                <div class="p-3 bg-indigo-50 text-indigo-600 rounded-xl">
                                    <span class="material-symbols-outlined">groups</span>
                                </div>
                                <div>
                                    <h3 class="text-xl font-black text-slate-900 leading-tight">Workforce Management</h3>
                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-0.5">Active Specialist Team</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-2">
                                <span class="px-3 py-1 bg-slate-100 text-slate-500 rounded-full text-[10px] font-black uppercase tracking-widest"><%= teamMembers.size() %> Active</span>
                            </div>
                        </div>
                        
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-slate-50/50">
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Team Member</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Access Level</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Joined On</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Status</th>
                                        <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <% if (teamMembers != null && !teamMembers.isEmpty()) { 
                                        for (TeamMember member : teamMembers) { 
                                            String roleBadge = "bg-slate-100 text-slate-600";
                                            if ("ROLE_ADMIN".equals(member.getRoleId())) roleBadge = "bg-primary/10 text-primary";
                                            if ("ROLE_SUPPORT".equals(member.getRoleId())) roleBadge = "bg-amber-50 text-amber-600";
                                            if ("ROLE_AUDITOR".equals(member.getRoleId())) roleBadge = "bg-emerald-50 text-emerald-600";
                                            
                                            String initial = member.getFullName().length() > 0 ? member.getFullName().substring(0,1) : "?";
                                    %>
                                    <tr class="hover:bg-slate-50/30 transition-colors">
                                        <td class="px-8 py-6">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-full bg-slate-100 flex items-center justify-center text-xs font-bold text-slate-500 border border-slate-200 uppercase">
                                                    <%= initial %>
                                                </div>
                                                <div>
                                                    <p class="text-sm font-bold text-slate-900"><%= member.getFullName() %></p>
                                                    <p class="text-[10px] text-slate-500 font-medium"><%= member.getEmail() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest <%= roleBadge %>">
                                                <%= member.getRoleName() %>
                                            </span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="text-xs font-bold text-slate-500"><%= member.getJoinedAt() != null ? member.getJoinedAt().toString().substring(0, 10) : "N/A" %></span>
                                        </td>
                                        <td class="px-8 py-6">
                                            <% if ("active".equalsIgnoreCase(member.getStatus())) { %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-black bg-emerald-50 text-emerald-600 uppercase">
                                                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                                                Active
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[10px] font-black bg-red-50 text-red-600 uppercase">
                                                <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span>
                                                Deactivated
                                            </span>
                                            <% } %>
                                        </td>
                                        <td class="px-8 py-6 text-right">
                                            <% if (member.getId() != currentUser.getId()) { %>
                                                <% if ("active".equalsIgnoreCase(member.getStatus())) { %>
                                                <a href="admin_member_action.jsp?id=<%= member.getId() %>&action=deactivate" 
                                                   onclick="return confirm('Are you sure you want to DEACTIVATE this account? They will be immediately blocked from logging in.')"
                                                   class="text-[10px] font-black text-red-500 uppercase tracking-widest hover:underline">Deactivate</a>
                                                <% } else { %>
                                                <a href="admin_member_action.jsp?id=<%= member.getId() %>&action=activate" 
                                                   class="text-[10px] font-black text-emerald-600 uppercase tracking-widest hover:underline">Reactivate</a>
                                                <% } %>
                                            <% } else { %>
                                                <span class="text-[10px] font-black text-slate-300 uppercase tracking-widest cursor-not-allowed" title="You cannot deactivate your own account">Self</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="4" class="px-8 py-10 text-center text-xs font-bold text-slate-400 italic">No assigned team members yet.</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pending Invitations Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
                        <div class="lg:col-span-1 space-y-4">
                            <h4 class="text-sm font-black text-slate-900 uppercase tracking-tight">Pending Registrations</h4>
                            <p class="text-xs font-medium text-slate-500 leading-relaxed">These individuals have been issued secure access tokens but have not yet finalized their specialist profiles.</p>
                        </div>
                        <div class="lg:col-span-2 grid grid-cols-1 md:grid-cols-2 gap-4">
                            <% if (invitations != null && !invitations.isEmpty()) { 
                                boolean hasPending = false;
                                for (AdminInvitation inv : invitations) { 
                                    if (!inv.isUsed()) {
                                        hasPending = true;
                                        String roleDisplay = inv.getInvitedRole();
                            %>
                            <div class="p-5 bg-white rounded-3xl border border-slate-100 shadow-sm flex items-center justify-between group hover:border-primary/20 transition-all">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-2xl bg-slate-50 flex items-center justify-center text-slate-400 group-hover:bg-primary/5 group-hover:text-primary transition-all">
                                        <span class="material-symbols-outlined text-xl">mail</span>
                                    </div>
                                    <div class="min-w-0">
                                        <p class="text-xs font-bold text-slate-900 truncate"><%= inv.getEmail() %></p>
                                        <p class="text-[10px] font-bold text-primary uppercase tracking-tighter mt-0.5"><%= roleDisplay %></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-2">
                                    <div class="h-8 w-8 flex items-center justify-center rounded-lg bg-slate-50 text-slate-400 hover:text-red-500 hover:bg-red-50 transition-all cursor-pointer" title="Revoke Invitation">
                                        <span class="material-symbols-outlined text-base">delete</span>
                                    </div>
                                </div>
                            </div>
                            <% } } 
                                if (!hasPending) { %>
                                <div class="col-span-2 p-8 bg-slate-50/50 border border-dashed border-slate-200 rounded-[2rem] text-center">
                                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">No active pending links</p>
                                </div>
                            <% } } else { %>
                                <div class="col-span-2 p-8 bg-slate-50/50 border border-dashed border-slate-200 rounded-[2rem] text-center">
                                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">No invitations sent yet</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>

    </div>
</body>
</html>
