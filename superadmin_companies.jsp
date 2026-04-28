<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    Account currentUser = (Account) sess.getAttribute("user");
    CompanyDAO companyDAO = new CompanyDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    
    List<Company> companies = companyDAO.getAllCompanies();
    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Regulated Entities - NIC Ghana Portal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#059669", "background-light": "#f6f7f9" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
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
            </div>

            <nav class="flex-1 px-4 mt-4 space-y-1">
                <a href="Superadmin.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">dashboard</span>
                    <span class="text-sm">Dashboard</span>
                </a>
                <a href="superadmin_companies.jsp" class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">corporate_fare</span>
                    <span class="text-sm">Regulated Entities</span>
                </a>
                <a href="superadmin_policies.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">verified_user</span>
                    <span class="text-sm">Policies</span>
                </a>
                <a href="superadmin_reports.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">insights</span>
                    <span class="text-sm">Reports</span>
                </a>
                <a href="superadmin_publications.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">library_books</span>
                    <span class="text-sm">Publications</span>
                </a>
            </nav>

            <div class="p-6 mt-auto">
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
                <div class="flex items-center gap-4 flex-1">
                    <button id="sidebarToggle" class="lg:hidden p-2 text-slate-400">
                        <span class="material-symbols-outlined">menu</span>
                    </button>
                    <div class="relative flex-1 max-w-xl">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                        <input type="text" id="headerSearchInput" placeholder="Search resources..." class="w-full pl-10 pr-4 py-2 bg-slate-50 border-none rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
                    </div>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Notification Dropdown -->
                    <div class="relative">
                        <button id="notificationBtn" class="relative p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors">
                            <span class="material-symbols-outlined">notifications</span>
                            <% if (unreadNotifications > 0) { %>
                                <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
                            <% } %>
                        </button>
                        
                        <div id="notificationDropdown" class="hidden absolute right-0 mt-3 w-80 bg-white rounded-2xl shadow-2xl border border-slate-100 z-[110] overflow-hidden">
                            <div class="p-4 border-b border-slate-50 flex items-center justify-between">
                                <h3 class="font-bold text-slate-900">Notifications</h3>
                                <span class="text-[10px] bg-primary/10 text-primary px-2 py-0.5 rounded-full font-bold"><%= unreadNotifications %> New</span>
                            </div>
                            <div class="max-h-96 overflow-y-auto">
                                <% if (notifications != null && !notifications.isEmpty()) { 
                                    for (Notification n : notifications) { %>
                                    <div class="p-4 hover:bg-slate-50 border-b border-slate-50 cursor-pointer transition-colors">
                                        <h4 class="text-xs font-bold text-slate-900"><%= n.getTitle() %></h4>
                                        <p class="text-[10px] text-slate-500 mt-1"><%= n.getMessage() %></p>
                                        <span class="text-[9px] text-slate-400 mt-2 block"><%= n.getCreatedAt() %></span>
                                    </div>
                                <% } } else { %>
                                    <div class="p-8 text-center">
                                        <span class="material-symbols-outlined text-slate-200 text-4xl">notifications_off</span>
                                        <p class="text-xs text-slate-400 mt-2">No new notifications</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Dropdown -->
                    <div class="relative">
                        <div id="profileBtn" class="flex items-center gap-3 pl-4 border-l border-slate-200 cursor-pointer group">
                            <div class="flex flex-col text-right hidden sm:flex">
                                <span class="text-sm font-bold text-slate-900 group-hover:text-primary transition-colors leading-none"><%= currentUser.getFullName() %></span>
                                <span class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider mt-1">Super Admin</span>
                            </div>
                            <div class="h-10 w-10 rounded-full bg-slate-200 overflow-hidden shadow-sm border-2 border-transparent group-hover:border-primary transition-all">
                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= currentUser.getFullName() %>" class="h-full w-full object-cover">
                            </div>
                        </div>

                        <div id="profileDropdown" class="hidden absolute right-0 mt-3 w-56 bg-white rounded-2xl shadow-2xl border border-slate-100 z-[110] overflow-hidden">
                            <div class="p-4 border-b border-slate-50 bg-slate-50/30">
                                <p class="text-xs font-bold text-slate-900"><%= currentUser.getFullName() %></p>
                                <p class="text-[10px] text-slate-400 mt-0.5"><%= currentUser.getEmail() %></p>
                            </div>
                            <div class="p-2">
                                <a href="Superadmin.jsp" class="flex items-center gap-3 px-3 py-2 text-slate-600 hover:bg-slate-50 rounded-xl text-xs font-semibold transition-colors">
                                    <span class="material-symbols-outlined text-lg">manage_accounts</span> Account Settings
                                </a>
                                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl text-xs font-semibold transition-colors mt-1">
                                    <span class="material-symbols-outlined text-lg">logout</span> Sign Out
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Body -->
            <div class="flex-1 p-8 space-y-8">
                <% if ("invited".equals(request.getParameter("success"))) { %>
                    <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-xl flex items-center gap-3 text-emerald-600 font-bold text-sm">
                        <span class="material-symbols-outlined">mail</span>
                        Invitation sent successfully! Activation link generated.
                    </div>
                <% } %>
                <% if ("1".equals(request.getParameter("success"))) { %>
                    <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-xl flex items-center gap-3 text-emerald-600 font-bold text-sm">
                        <span class="material-symbols-outlined">check_circle</span>
                        Partner organization added successfully!
                    </div>
                <% } %>
                <% if ("renewed".equals(request.getParameter("success"))) { %>
                    <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-xl flex items-center gap-3 text-emerald-600 font-bold text-sm">
                        <span class="material-symbols-outlined">verified</span>
                        License successfully renewed! Compliance status updated to Compliant.
                    </div>
                <% } %>
                <% if (request.getParameter("error") != null) { %>
                    <div class="p-4 bg-red-50 border border-red-100 rounded-xl flex items-center gap-3 text-red-600 font-bold text-sm">
                        <span class="material-symbols-outlined">error</span>
                        <%= "invalid_input".equals(request.getParameter("error")) ? "Please provide a valid input." : "Action failed. Please check the logs." %>
                    </div>
                <% } %>

                <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex flex-col font-display">
                    <div class="p-6 flex items-center justify-between gap-6 border-b border-slate-100">
                        <div>
                            <h3 class="text-lg font-bold text-slate-900">Network Partners</h3>
                            <p class="text-sm text-slate-500 mt-1 font-medium">Manage and oversee all partner organizations in the network.</p>
                        </div>
                        <div class="flex items-center gap-3">
                            <button onclick="document.getElementById('addCompanyModal').classList.remove('hidden')" class="px-5 py-2 text-sm font-bold text-white bg-primary rounded-xl hover:bg-primary/90 flex items-center gap-2 shadow-lg shadow-primary/10 transition-all active:scale-95">
                                <span class="material-symbols-outlined text-lg">add</span> Add Company
                            </button>
                        </div>
                    </div>

                    <!-- Add Company Modal -->
                    <div id="addCompanyModal" class="fixed inset-0 z-[100] hidden">
                        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="document.getElementById('addCompanyModal').classList.add('hidden')"></div>
                        <div class="flex items-center justify-center min-h-screen p-4">
                            <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl p-6 sm:p-8 border border-white/20 max-h-[95vh] overflow-y-auto">
                                <div class="flex items-center justify-between mb-6">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-primary/10 p-2.5 rounded-xl text-primary">
                                            <span class="material-symbols-outlined">corporate_fare</span>
                                        </div>
                                        <h3 class="text-xl font-bold text-slate-900">Add New Partner</h3>
                                    </div>
                                    <button onclick="document.getElementById('addCompanyModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                                        <span class="material-symbols-outlined">close</span>
                                    </button>
                                </div>
                                <form action="add_company_process.jsp" method="POST" class="space-y-6">
                                    <input type="hidden" name="redirect" value="superadmin_companies.jsp">
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Company Name</label>
                                            <input type="text" name="name" required placeholder="e.g. Global Safe Insurance" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                        </div>
                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Official Email</label>
                                                <input type="email" name="email" required placeholder="contact@company.com" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Phone Number</label>
                                                <input type="text" name="phone" placeholder="+233..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Entity Category</label>
                                                <select name="companyType" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Life">Life Insurance</option>
                                                    <option value="Non-Life" selected>Non-Life Insurance</option>
                                                    <option value="Life & Non-Life">Life & Non-Life Insurance</option>
                                                    <option value="Social Security">Social Security</option>
                                                    <option value="Reinsurer">Reinsurer</option>
                                                    <option value="Broker">Broker</option>
                                                    <option value="Loss Adjuster">Loss Adjuster</option>
                                                    <option value="Agent">Agent</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Number</label>
                                                <input type="text" name="licenseNumber" placeholder="NIC-..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Regulatory Status</label>
                                                <select name="complianceStatus" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Compliant">Compliant</option>
                                                    <option value="At Risk">At Risk</option>
                                                    <option value="Non-Compliant">Non-Compliant</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">TIN (Tax ID)</label>
                                                <input type="text" name="tin" placeholder="P00..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Portal Account</label>
                                                <select name="status" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Active">Active</option>
                                                    <option value="Pending">Pending</option>
                                                    <option value="Inactive">Inactive</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Expiry</label>
                                                <input type="date" name="licenseExpiry" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Headquarters Address</label>
                                            <textarea name="address" rows="3" placeholder="Full legal address..." class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20"></textarea>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 pt-4">
                                        <button type="button" onclick="document.getElementById('addCompanyModal').classList.add('hidden')" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                        <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-primary rounded-xl shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all active:scale-95">Establish Partnership</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Invite Modal -->
                    <div id="inviteAdminModal" class="fixed inset-0 z-[100] hidden">
                        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="closeInviteModal()"></div>
                        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-md bg-white rounded-3xl shadow-2xl p-8 border border-white/20">
                            <div class="flex items-center justify-between mb-6">
                                <div class="flex items-center gap-3">
                                    <div class="bg-blue-500 p-2.5 rounded-xl text-white">
                                        <span class="material-symbols-outlined">person_add</span>
                                    </div>
                                    <h3 class="text-xl font-bold text-slate-900">Invite Company Admin</h3>
                                </div>
                                <button onclick="closeInviteModal()" class="text-slate-400 hover:text-slate-600">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                            <form action="superadmin_invite_process.jsp" method="POST" class="space-y-6">
                                <input type="hidden" name="companyId" id="inviteCompanyId">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Company</label>
                                    <input type="text" id="inviteCompanyName" readonly class="w-full bg-slate-100 border-none rounded-xl px-4 py-3 text-sm font-bold text-slate-600">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Administrator Email</label>
                                    <input type="email" name="email" required placeholder="admin@partner-company.com" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div class="flex items-center gap-3 pt-2">
                                    <button type="button" onclick="closeInviteModal()" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                    <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-blue-600 rounded-xl shadow-lg shadow-blue-200 hover:bg-blue-700 transition-all active:scale-95">Send Invitation</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Renew License Modal -->
                    <div id="renewLicenseModal" class="fixed inset-0 z-[100] hidden">
                        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="closeRenewModal()"></div>
                        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-md bg-white rounded-3xl shadow-2xl p-8 border border-white/20">
                            <div class="flex items-center justify-between mb-6">
                                <div class="flex items-center gap-3">
                                    <div class="bg-emerald-600 p-2.5 rounded-xl text-white">
                                        <span class="material-symbols-outlined">published_with_changes</span>
                                    </div>
                                    <h3 class="text-xl font-bold text-slate-900">Renew Regulatory License</h3>
                                </div>
                                <button onclick="closeRenewModal()" class="text-slate-400 hover:text-slate-600">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                            <form action="license_renewal_checkout.jsp" method="POST" class="space-y-6">
                                <input type="hidden" name="companyId" id="renewCompanyId">
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Regulated Entity</label>
                                    <input type="text" id="renewCompanyName" readonly class="w-full bg-slate-100 border-none rounded-xl px-4 py-3 text-sm font-bold text-slate-600">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Current Expiry</label>
                                    <input type="text" id="currentExpiryDate" readonly class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm text-slate-400">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">New Expiry Date</label>
                                    <input type="date" name="licenseExpiry" required class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                </div>
                                <div class="bg-amber-50 rounded-2xl p-4 border border-amber-100/50">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10px] font-black text-amber-600 uppercase tracking-widest">Regulatory Renewal Fee</span>
                                        <span id="renewFeeDisplay" class="text-sm font-black text-amber-700">GH₵0.00</span>
                                    </div>
                                    <p class="text-[9px] text-amber-600/70 mt-1 font-medium italic">* Fee is mandated based on entity category.</p>
                                </div>
                                <div class="flex items-center gap-3 pt-2">
                                    <button type="button" onclick="closeRenewModal()" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                    <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-emerald-600 rounded-xl shadow-lg shadow-emerald-200 hover:bg-emerald-700 transition-all active:scale-95">Issue Renewal</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Edit Company Modal -->
                    <div id="editCompanyModal" class="fixed inset-0 z-[100] hidden">
                        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="closeEditModal()"></div>
                        <div class="flex items-center justify-center min-h-screen p-4">
                            <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl p-6 sm:p-8 border border-white/20 max-h-[95vh] overflow-y-auto">
                                <div class="flex items-center justify-between mb-6">
                                    <div class="flex items-center gap-3">
                                        <div class="bg-primary/10 p-2.5 rounded-xl text-primary">
                                            <span class="material-symbols-outlined">edit_note</span>
                                        </div>
                                        <h3 class="text-xl font-bold text-slate-900">Edit Regulated Entity</h3>
                                    </div>
                                    <button onclick="closeEditModal()" class="text-slate-400 hover:text-slate-600">
                                        <span class="material-symbols-outlined">close</span>
                                    </button>
                                </div>
                                <form action="edit_company_process.jsp" method="POST" class="space-y-6">
                                    <input type="hidden" name="id" id="editCompanyId">
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Company Name</label>
                                            <input type="text" name="name" id="editName" required class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                        </div>
                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Official Email</label>
                                                <input type="email" name="email" id="editEmail" required class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Phone Number</label>
                                                <input type="text" name="phone" id="editPhone" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Entity Category</label>
                                                <select name="companyType" id="editType" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Life">Life Insurance</option>
                                                    <option value="Non-Life">Non-Life Insurance</option>
                                                    <option value="Life & Non-Life">Life & Non-Life Insurance</option>
                                                    <option value="Social Security">Social Security</option>
                                                    <option value="Reinsurer">Reinsurer</option>
                                                    <option value="Broker">Broker</option>
                                                    <option value="Loss Adjuster">Loss Adjuster</option>
                                                    <option value="Agent">Agent</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Number</label>
                                                <input type="text" name="licenseNumber" id="editLicense" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Regulatory Status</label>
                                                <select name="complianceStatus" id="editCompliance" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Compliant">Compliant</option>
                                                    <option value="At Risk">At Risk</option>
                                                    <option value="Non-Compliant">Non-Compliant</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">TIN (Tax ID)</label>
                                                <input type="text" name="tin" id="editTin" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Portal Account</label>
                                                <select name="status" id="editStatus" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                                    <option value="Active">Active</option>
                                                    <option value="Pending">Pending</option>
                                                    <option value="Inactive">Inactive</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">License Expiry</label>
                                                <input type="date" name="licenseExpiry" id="editExpiry" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Headquarters Address</label>
                                            <textarea name="address" id="editAddress" rows="3" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20"></textarea>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 pt-4">
                                        <button type="button" onclick="closeEditModal()" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                        <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-primary rounded-xl shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all active:scale-95">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Local Search -->
                    <div class="px-6 py-4 bg-slate-50/30 border-b border-slate-100">
                        <div class="relative max-w-lg">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                            <input type="text" id="localSearchInput" placeholder="Filter companies by name or email..." class="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 text-slate-400 text-[10px] font-black uppercase tracking-widest border-t border-slate-100">
                                    <th class="px-8 py-5">Regulated Entity</th>
                                    <th class="px-8 py-5">Contact Details</th>
                                    <th class="px-8 py-5">Category & License</th>
                                    <th class="px-8 py-5">Regulatory Status</th>
                                    <th class="px-8 py-5 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="companyTableBody" class="divide-y divide-slate-100">
                                <% if (companies != null) { 
                                    for (Company c : companies) { 
                                        boolean isActive = "Active".equalsIgnoreCase(c.getStatus());
                                        String statusBg = isActive ? "bg-emerald-50 text-emerald-600 border-emerald-100" : "bg-slate-50 text-slate-400 border-slate-100";
                                        String dotColor = isActive ? "bg-emerald-500" : "bg-slate-400";
                                %>
                                <tr class="hover:bg-slate-50/50 transition-colors group search-row">
                                    <td class="px-8 py-6">
                                        <div class="flex items-center gap-4">
                                            <div class="h-10 w-10 rounded-xl bg-primary/5 flex items-center justify-center text-primary font-black border border-primary/10 group-hover:scale-110 transition-transform">
                                                <%= c.getName().substring(0, 1) %>
                                            </div>
                                            <span class="text-sm font-bold text-slate-900 search-target"><%= c.getName() %></span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex flex-col">
                                            <span class="text-xs font-bold text-primary search-target"><%= c.getEmail() %></span>
                                            <span class="text-xs font-medium text-slate-400 mt-1"><%= c.getPhoneNumber() %></span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-slate-50 text-slate-600 rounded-full text-[10px] font-black uppercase tracking-tighter border border-slate-100 mb-1">
                                            <%= c.getCompanyType() %>
                                        </span>
                                        <p class="text-[10px] font-bold text-slate-400">License: <span class="text-primary font-black"><%= c.getLicenseNumber() %></span></p>
                                    </td>
                                    <td class="px-8 py-6">
                                        <% 
                                            String compStatus = c.getComplianceStatus();
                                            String compBg = "bg-emerald-50 text-emerald-600 border-emerald-100";
                                            String compDot = "bg-emerald-500";
                                            if("At Risk".equalsIgnoreCase(compStatus)) {
                                                compBg = "bg-amber-50 text-amber-600 border-amber-100";
                                                compDot = "bg-amber-500";
                                            } else if("Non-Compliant".equalsIgnoreCase(compStatus)) {
                                                compBg = "bg-rose-50 text-rose-600 border-rose-100";
                                                compDot = "bg-rose-500";
                                            }
                                        %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 <%= compBg %> rounded-full text-[10px] font-black uppercase tracking-tighter border">
                                            <span class="w-1.5 h-1.5 rounded-full <%= compDot %>"></span>
                                            <%= compStatus %>
                                        </span>
                                        <p class="text-[9px] font-medium text-slate-300 mt-1 uppercase tracking-widest">Portal: <%= c.getStatus() %></p>
                                    </td>
                                    <td class="px-8 py-6 text-right">
                                        <div class="flex justify-end gap-2">
                                            <button data-id="<%= c.getId() %>" data-name="<%= c.getName() %>" data-expiry="<%= c.getLicenseExpiry() %>" data-type="<%= c.getCompanyType() %>" onclick="handleRenewClick(this)" class="p-2 text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors group/btn" title="Renew License">
                                                <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">published_with_changes</span>
                                            </button>
                                            <button data-id="<%= c.getId() %>" data-name="<%= c.getName() %>" onclick="handleInviteClick(this)" class="p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors group/btn" title="Invite Admin">
                                                <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">person_add</span>
                                            </button>
                                            <button data-id="<%= c.getId() %>" data-name="<%= c.getName() %>" data-email="<%= c.getEmail() %>" data-phone="<%= c.getPhoneNumber() %>" data-address="<%= c.getAddress() != null ? c.getAddress() : "" %>" data-status="<%= c.getStatus() %>" data-type="<%= c.getCompanyType() %>" data-license="<%= c.getLicenseNumber() %>" data-expiry="<%= c.getLicenseExpiry() != null ? c.getLicenseExpiry() : "" %>" data-compliance="<%= c.getComplianceStatus() %>" data-tin="<%= c.getTin() != null ? c.getTin() : "" %>" onclick="handleEditClick(this)" class="p-2 text-slate-400 hover:text-primary hover:bg-primary/5 rounded-lg transition-colors group/btn" title="Edit Company">
                                                <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">edit</span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pending Onboarding -->
                <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden flex flex-col font-display mt-8">
                    <div class="p-6 border-b border-slate-100">
                        <h3 class="text-lg font-bold text-slate-900">Pending Onboarding</h3>
                        <p class="text-sm text-slate-500 mt-1 font-medium">Invitations sent to future partner administrators.</p>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <tbody class="divide-y divide-slate-100">
                                <% 
                                    SystemDAO sysDAO = new SystemDAO();
                                    List<AdminInvitation> pending = sysDAO.getAllInvitations();
                                    if (pending != null && !pending.isEmpty()) {
                                        for (AdminInvitation inv : pending) {
                                            if (!inv.isUsed()) {
                                                Company parent = companyDAO.getCompanyById(inv.getCompanyId());
                                                String cName = parent != null ? parent.getName() : "Unknown Company";
                                %>
                                <tr class="hover:bg-slate-50/50 transition-colors group">
                                    <td class="px-8 py-5">
                                        <div class="flex flex-col">
                                            <span class="text-sm font-bold text-slate-900"><%= inv.getEmail() %></span>
                                            <span class="text-[10px] font-bold text-primary uppercase tracking-tighter"><%= cName %></span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-5">
                                        <div class="flex items-center gap-2">
                                            <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest bg-slate-100 px-2 py-1 rounded">TOKEN: <%= inv.getInviteToken().substring(0, 8) %>...</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-5 text-right">
                                        <button data-token="<%= inv.getInviteToken() %>" onclick="handleCopyInvite(this)" class="text-xs font-bold text-primary hover:underline flex items-center gap-1 ml-auto">
                                            <span class="material-symbols-outlined text-sm">content_copy</span> Copy Link
                                        </button>
                                    </td>
                                </tr>
                                <% } } } else { %>
                                <tr>
                                    <td colspan="3" class="px-8 py-10 text-center">
                                        <div class="flex flex-col items-center">
                                            <span class="material-symbols-outlined text-slate-200 text-5xl">mail</span>
                                            <p class="text-sm text-slate-400 mt-2 font-medium">No pending invitations found.</p>
                                        </div>
                                    </td>
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
        // UI Toggles
        document.getElementById('sidebarToggle')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });

        function setupDropdown(btnId, dropdownId) {
            const btn = document.getElementById(btnId);
            const dropdown = document.getElementById(dropdownId);
            if (!btn || !dropdown) return;

            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const isHidden = dropdown.classList.contains('hidden');
                document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
                if (isHidden) dropdown.classList.remove('hidden');
            });
        }

        setupDropdown('notificationBtn', 'notificationDropdown');
        setupDropdown('profileBtn', 'profileDropdown');

        window.addEventListener('click', () => {
            document.querySelectorAll('#notificationDropdown, #profileDropdown').forEach(d => d.classList.add('hidden'));
        });

        // Global Search
        document.getElementById('headerSearchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                window.location.href = 'search_results.jsp?q=' + encodeURIComponent(this.value);
            }
        });

        // Local Search
        document.getElementById('localSearchInput')?.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.search-row').forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(term) ? '' : 'none';
            });
        });

        // Modal Functions
        function handleInviteClick(btn) {
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            openInviteModal(id, name);
        }

        function openInviteModal(id, name) {
            document.getElementById('inviteCompanyId').value = id;
            document.getElementById('inviteCompanyName').value = name;
            document.getElementById('inviteAdminModal').classList.remove('hidden');
        }
        
        function closeInviteModal() {
            document.getElementById('inviteAdminModal').classList.add('hidden');
        }

        function handleCopyInvite(btn) {
            copyInviteLink(btn.getAttribute('data-token'));
        }

        function copyInviteLink(token) {
            const domain = window.location.origin;
            const path = "/NationalInsuranceCompany/register_admin.jsp?token=";
            const url = domain + path + token;
            navigator.clipboard.writeText(url).then(() => {
                alert("Invitation link copied!");
            });
        }

        // Renew Functions
        function handleRenewClick(btn) {
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const expiry = btn.getAttribute('data-expiry');
            const type = btn.getAttribute('data-type') || 'Life';
            openRenewModal(id, name, expiry, type);
        }

        function openRenewModal(id, name, expiry, type) {
            document.getElementById('renewCompanyId').value = id;
            document.getElementById('renewCompanyName').value = name;
            document.getElementById('currentExpiryDate').value = expiry || "Not Set";
            
            // Calculate and Show Fee
            let fee = "GH₵5,000.00";
            if (type.toLowerCase().includes('broker')) {
                fee = "GH₵1,000.00";
            }
            document.getElementById('renewFeeDisplay').innerText = fee;
            
            document.getElementById('renewLicenseModal').classList.remove('hidden');
        }

        function closeRenewModal() {
            document.getElementById('renewLicenseModal').classList.add('hidden');
        }

        // Edit Functions
        function handleEditClick(btn) {
            document.getElementById('editCompanyId').value = btn.getAttribute('data-id');
            document.getElementById('editName').value = btn.getAttribute('data-name');
            document.getElementById('editEmail').value = btn.getAttribute('data-email');
            document.getElementById('editPhone').value = btn.getAttribute('data-phone');
            document.getElementById('editAddress').value = btn.getAttribute('data-address');
            document.getElementById('editStatus').value = btn.getAttribute('data-status');
            document.getElementById('editType').value = btn.getAttribute('data-type');
            document.getElementById('editLicense').value = btn.getAttribute('data-license');
            document.getElementById('editExpiry').value = btn.getAttribute('data-expiry');
            document.getElementById('editCompliance').value = btn.getAttribute('data-compliance');
            document.getElementById('editTin').value = btn.getAttribute('data-tin');
            document.getElementById('editCompanyModal').classList.remove('hidden');
        }

        function closeEditModal() {
            document.getElementById('editCompanyModal').classList.add('hidden');
        }

        // Auto-open modal if redirected from search with action=add
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('action') === 'add') {
                const name = urlParams.get('name');
                const email = urlParams.get('email');
                const phone = urlParams.get('phone');
                const address = urlParams.get('address');
                const type = urlParams.get('type');
                const license = urlParams.get('license');
                const tin = urlParams.get('tin');

                const setValue = (name, val) => {
                    const el = document.getElementsByName(name)[0];
                    if (el && val) el.value = val;
                };

                setValue('name', name);
                setValue('email', email);
                setValue('phone', phone);
                setValue('address', address);
                setValue('companyType', type);
                setValue('licenseNumber', license);
                setValue('tin', tin);

                document.getElementById('addCompanyModal').classList.remove('hidden');
            }
        });
    </script>
</body>
</html>
