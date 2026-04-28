<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    Account currentUser = (Account) sess.getAttribute("user");
    NotificationDAO notificationDAO = new NotificationDAO();
    PublicationDAO pubDAO = new PublicationDAO();

    List<Notification> notifications = notificationDAO.getNotificationsByUserId(currentUser.getId());
    int unreadNotifications = notificationDAO.getUnreadCount(currentUser.getId());

    String filterCategory = request.getParameter("category");
    List<Publication> publications;
    if (filterCategory != null && !filterCategory.isEmpty() && !"All".equals(filterCategory)) {
        publications = pubDAO.getPublicationsByCategory(filterCategory);
    } else {
        publications = pubDAO.getAllPublications();
        filterCategory = "All";
    }

    /* Count by category */
    List<Publication> allPubs = pubDAO.getAllPublications();
    int annualCount = 0, quarterlyCount = 0, researchCount = 0, newsletterCount = 0, guidelineCount = 0;
    for (Publication p : allPubs) {
        String cat = p.getCategory();
        if ("Annual Report".equals(cat)) annualCount++;
        else if ("Quarterly Market Report".equals(cat)) quarterlyCount++;
        else if ("Market Research".equals(cat)) researchCount++;
        else if ("Newsletter".equals(cat)) newsletterCount++;
        else if ("Guideline".equals(cat)) guidelineCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Publications - NIC Ghana Portal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f6f7f9", "nic-purple": "#6b2fa0", "nic-gold": "#d4a017" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .category-btn.active { background: linear-gradient(135deg, #1152d4 0%, #6b2fa0 100%); color: white; box-shadow: 0 4px 15px rgba(17,82,212,0.3); }
        .pub-row:hover { transform: translateX(4px); }
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
                <a href="superadmin_companies.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl">corporate_fare</span>
                    <span class="text-sm">Regulated Entities</span>
                </a>
                <a href="superadmin_policies.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">verified_user</span>
                    <span class="text-sm">Policies</span>
                </a>
                <a href="superadmin_reports.jsp" class="flex items-center gap-3 px-3 py-2.5 text-slate-500 hover:bg-slate-50 rounded-xl transition-colors font-semibold group">
                    <span class="material-symbols-outlined text-xl">insights</span>
                    <span class="text-sm">Reports</span>
                </a>
                <a href="superadmin_publications.jsp" class="flex items-center gap-3 px-3 py-2.5 bg-primary/5 text-primary rounded-xl transition-colors font-bold group">
                    <span class="material-symbols-outlined text-xl" style="font-variation-settings: 'FILL' 1">library_books</span>
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
            <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-4 sm:px-8 shrink-0">
                <div class="flex items-center gap-4 flex-1">
                    <button id="sidebarToggle" class="lg:hidden p-2 text-slate-400">
                        <span class="material-symbols-outlined">menu</span>
                    </button>
                    <div class="relative flex-1 max-w-xl">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl font-light">search</span>
                        <input type="text" id="pubSearchInput" placeholder="Search publications..." class="w-full pl-10 pr-4 py-2 bg-slate-50 border-none rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
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

                    <!-- Profile -->
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
                                <a href="logout.jsp" class="flex items-center gap-3 px-3 py-2 text-red-500 hover:bg-red-50 rounded-xl text-xs font-semibold transition-colors mt-1">
                                    <span class="material-symbols-outlined text-lg">logout</span> Sign Out
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <div class="flex-1 p-4 sm:p-8 space-y-8">
                <!-- Page Header -->
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div>
                        <h2 class="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">Publications</h2>
                        <p class="text-sm text-slate-500 font-medium mt-1">Official NIC Ghana regulatory documents and industry reports.</p>
                    </div>
                    <button onclick="document.getElementById('addPubModal').classList.remove('hidden')" class="bg-primary hover:bg-primary/90 text-white font-bold px-6 py-3 rounded-xl shadow-lg shadow-primary/20 transition-all active:scale-95 flex items-center gap-2 text-sm self-start sm:self-auto">
                        <span class="material-symbols-outlined text-lg">upload_file</span>
                        Add Publication
                    </button>
                </div>

                <!-- Category Filter Tabs -->
                <div class="flex flex-wrap gap-2">
                    <a href="superadmin_publications.jsp" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "All".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">apps</span>
                            All (<%= allPubs.size() %>)
                        </span>
                    </a>
                    <a href="superadmin_publications.jsp?category=Annual+Report" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "Annual Report".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">calendar_month</span>
                            Annual Report (<%= annualCount %>)
                        </span>
                    </a>
                    <a href="superadmin_publications.jsp?category=Quarterly+Market+Report" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "Quarterly Market Report".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">trending_up</span>
                            Quarterly (<%= quarterlyCount %>)
                        </span>
                    </a>
                    <a href="superadmin_publications.jsp?category=Market+Research" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "Market Research".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">biotech</span>
                            Research (<%= researchCount %>)
                        </span>
                    </a>
                    <a href="superadmin_publications.jsp?category=Newsletter" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "Newsletter".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">newspaper</span>
                            Newsletter (<%= newsletterCount %>)
                        </span>
                    </a>
                    <a href="superadmin_publications.jsp?category=Guideline" class="category-btn px-4 py-2 rounded-xl text-xs font-bold border border-slate-200 transition-all hover:shadow-md <%= "Guideline".equals(filterCategory) ? "active" : "bg-white text-slate-600" %>">
                        <span class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-sm">gavel</span>
                            Guidelines (<%= guidelineCount %>)
                        </span>
                    </a>
                </div>

                <!-- Publications Table -->
                <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-gradient-to-r from-primary/5 to-nic-purple/5 text-slate-400 text-[10px] font-black uppercase tracking-widest border-b border-slate-100">
                                    <th class="px-8 py-5">Document</th>
                                    <th class="px-8 py-5">Category</th>
                                    <th class="px-8 py-5">Year</th>
                                    <th class="px-8 py-5">Size</th>
                                    <th class="px-8 py-5 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <% if (publications != null && !publications.isEmpty()) {
                                    for (Publication pub : publications) {
                                        String catIcon = "description";
                                        String catColor = "text-primary bg-primary/10";
                                        if ("Annual Report".equals(pub.getCategory())) { catIcon = "calendar_month"; catColor = "text-nic-purple bg-nic-purple/10"; }
                                        else if ("Quarterly Market Report".equals(pub.getCategory())) { catIcon = "trending_up"; catColor = "text-emerald-600 bg-emerald-50"; }
                                        else if ("Market Research".equals(pub.getCategory())) { catIcon = "biotech"; catColor = "text-blue-600 bg-blue-50"; }
                                        else if ("Newsletter".equals(pub.getCategory())) { catIcon = "newspaper"; catColor = "text-amber-600 bg-amber-50"; }
                                        else if ("Guideline".equals(pub.getCategory())) { catIcon = "gavel"; catColor = "text-rose-600 bg-rose-50"; }
                                %>
                                <tr class="hover:bg-slate-50/50 transition-all pub-row search-row">
                                    <td class="px-8 py-5">
                                        <div class="flex items-center gap-4">
                                            <div class="h-10 w-10 rounded-xl bg-red-50 flex items-center justify-center text-red-500 shrink-0">
                                                <span class="material-symbols-outlined text-xl">picture_as_pdf</span>
                                            </div>
                                            <div class="flex flex-col min-w-0">
                                                <span class="text-sm font-bold text-slate-900 truncate search-target"><%= pub.getTitle() %></span>
                                                <% if (pub.getDescription() != null && !pub.getDescription().isEmpty()) { %>
                                                    <span class="text-[10px] text-slate-400 font-medium mt-0.5 truncate"><%= pub.getDescription() %></span>
                                                <% } %>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-5">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 <%= catColor %> rounded-full text-[10px] font-black uppercase tracking-tighter">
                                            <span class="material-symbols-outlined text-xs"><%= catIcon %></span>
                                            <%= pub.getCategory() %>
                                        </span>
                                    </td>
                                    <td class="px-8 py-5">
                                        <span class="text-sm font-bold text-slate-700"><%= pub.getYear() != null ? pub.getYear() : "—" %></span>
                                    </td>
                                    <td class="px-8 py-5">
                                        <span class="text-xs font-semibold text-slate-400"><%= pub.getFileSize() != null ? pub.getFileSize() : "N/A" %></span>
                                    </td>
                                    <td class="px-8 py-5 text-right">
                                        <div class="flex justify-end gap-2">
                                            <% if (pub.getFileUrl() != null && !pub.getFileUrl().isEmpty()) { %>
                                                <button onclick="previewFile('<%= pub.getFileUrl() %>', '<%= pub.getTitle() %>')" class="p-2 text-nic-purple hover:bg-nic-purple/5 rounded-lg transition-colors group/btn" title="View Document Preview">
                                                    <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">visibility</span>
                                                </button>
                                                <a href="<%= pub.getFileUrl() %>" download class="p-2 text-primary hover:bg-primary/5 rounded-lg transition-colors group/btn" title="Download Document">
                                                    <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">download</span>
                                                </a>
                                            <% } %>
                                            <form action="publication_process.jsp" method="POST" style="display:inline;" onsubmit="return confirm('Delete this publication?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= pub.getId() %>">
                                                <button type="submit" class="p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors group/btn" title="Delete">
                                                    <span class="material-symbols-outlined text-xl transition-transform group-hover/btn:scale-110">delete</span>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="5" class="px-8 py-16 text-center">
                                        <div class="flex flex-col items-center">
                                            <div class="h-16 w-16 rounded-2xl bg-slate-50 flex items-center justify-center mb-4">
                                                <span class="material-symbols-outlined text-slate-200 text-4xl">folder_open</span>
                                            </div>
                                            <p class="text-sm font-bold text-slate-400">No publications found</p>
                                            <p class="text-xs text-slate-300 mt-1">Click "Add Publication" to upload regulatory documents.</p>
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

    <!-- Add Publication Modal -->
    <div id="addPubModal" class="fixed inset-0 z-[100] hidden">
        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity" onclick="document.getElementById('addPubModal').classList.add('hidden')"></div>
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="relative w-full max-w-lg bg-white rounded-3xl shadow-2xl p-6 sm:p-8 border border-white/20 max-h-[95vh] overflow-y-auto">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center gap-3">
                        <div class="bg-primary/10 p-2.5 rounded-xl text-primary">
                            <span class="material-symbols-outlined">upload_file</span>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900">Add Publication</h3>
                    </div>
                    <button onclick="document.getElementById('addPubModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>
                <form action="upload-publication" method="POST" enctype="multipart/form-data" class="space-y-5">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Document Title</label>
                        <input type="text" name="title" required placeholder="e.g. Annual Report 2024" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Category</label>
                            <select name="category" required class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                                <option value="Annual Report">Annual Report</option>
                                <option value="Quarterly Market Report">Quarterly Market Report</option>
                                <option value="Market Research">Market Research</option>
                                <option value="Newsletter">Newsletter</option>
                                <option value="Guideline">Guideline</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Year</label>
                            <input type="text" name="year" placeholder="2024" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Description (Optional)</label>
                        <input type="text" name="description" placeholder="Brief summary of the document" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                    </div>
                    
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Upload File (Auto-calculates size)</label>
                        <input type="file" name="file" accept=".pdf,.doc,.docx,.xls,.xlsx" class="w-full bg-slate-50 border-none rounded-xl px-4 py-2.5 text-sm file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-primary/10 file:text-primary hover:file:bg-primary/20 transition-all cursor-pointer">
                    </div>
                    
                    <div class="relative flex items-center py-2">
                        <div class="flex-grow border-t border-slate-200"></div>
                        <span class="flex-shrink-0 mx-4 text-xs font-bold text-slate-400 uppercase tracking-wider">OR PROVIDE LINK</span>
                        <div class="flex-grow border-t border-slate-200"></div>
                    </div>

                    <div class="grid grid-cols-3 gap-4 border border-slate-100 p-4 rounded-xl bg-slate-50/50">
                        <div class="col-span-2">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">File URL / Link</label>
                            <input type="url" name="fileUrl" placeholder="https://example.com/report.pdf" class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 ml-1">Manual Size</label>
                            <input type="text" name="fileSize" placeholder="e.g. 5.2 MB" class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary/20">
                        </div>
                    </div>
                    <div class="flex items-center gap-3 pt-4">
                        <button type="button" onclick="document.getElementById('addPubModal').classList.add('hidden')" class="flex-1 px-6 py-3 text-sm font-bold text-slate-500 hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                        <button type="submit" class="flex-1 px-6 py-3 text-sm font-bold text-white bg-primary rounded-xl shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all active:scale-95">Publish</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Document Viewer Modal -->
    <div id="viewerModal" class="fixed inset-0 z-[110] hidden flex flex-col pt-10 sm:p-10 pb-0 sm:pb-10">
        <div class="absolute inset-0 bg-slate-900/90 backdrop-blur-md transition-opacity" onclick="document.getElementById('viewerModal').classList.add('hidden')"></div>
        <div class="relative w-full max-w-7xl mx-auto flex flex-col bg-white rounded-t-3xl sm:rounded-3xl shadow-2xl border border-white/20 h-full overflow-hidden flex-1 z-10">
            <!-- Header -->
            <div class="bg-gradient-to-r from-nic-purple to-primary px-6 py-4 flex items-center justify-between shrink-0 shadow-md z-20">
                <div class="flex items-center gap-3">
                    <div class="bg-white/20 p-2 rounded-xl text-white shadow-inner backdrop-blur-sm">
                        <span class="material-symbols-outlined font-light" id="viewerIcon">preview</span>
                    </div>
                    <div class="flex flex-col">
                        <h3 class="text-lg font-black text-white tracking-tight leading-tight" id="viewerTitle">Document Preview</h3>
                        <span class="text-[10px] uppercase font-bold tracking-widest text-white/70" id="viewerExtBadge">LOADING...</span>
                    </div>
                </div>
                <button onclick="document.getElementById('viewerModal').classList.add('hidden')" class="text-white/70 hover:text-white bg-white/10 hover:bg-white/20 p-2 rounded-xl transition-all">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <!-- Dynamic Content Container -->
            <div id="viewerContent" class="flex-1 bg-slate-50 relative overflow-hidden flex flex-col">
                <!-- Injected via JS -->
            </div>
        </div>
    </div>

    <script>
        // Sidebar toggle
        document.getElementById('sidebarToggle')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });

        // Dropdown Toggles
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

        // Local search
        document.getElementById('pubSearchInput')?.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.search-row').forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(term) ? '' : 'none';
            });
        });

        // Intelligent Document Preview System
        async function previewFile(url, title) {
            const modal = document.getElementById('viewerModal');
            const contentDiv = document.getElementById('viewerContent');
            const titleEl = document.getElementById('viewerTitle');
            const badgeEl = document.getElementById('viewerExtBadge');
            const iconEl = document.getElementById('viewerIcon');

            modal.classList.remove('hidden');
            titleEl.textContent = title || 'Document Preview';
            contentDiv.innerHTML = `
                <div class="absolute inset-0 flex flex-col items-center justify-center">
                    <div class="h-12 w-12 border-4 border-slate-200 border-t-primary rounded-full animate-spin"></div>
                    <p class="mt-4 text-sm font-bold text-slate-400 animate-pulse">Loading Document...</p>
                </div>
            `;

            const ext = url.split('.').pop().toLowerCase();
            
            if (ext === 'pdf') {
                badgeEl.textContent = 'PDF DOCUMENT';
                iconEl.textContent = 'picture_as_pdf';
                // Bypass IDM by fetching as a blob and rendering a memory ObjectURL instead of jumping to the network URL
                try {
                    const response = await fetch(url);
                    const blob = await response.blob();
                    const objectUrl = URL.createObjectURL(blob);
                    contentDiv.innerHTML = '<iframe src="' + objectUrl + '#toolbar=0" class="absolute inset-0 w-full h-full border-none" style="min-height: 70vh;"></iframe>';
                } catch(err) {
                    contentDiv.innerHTML = '<iframe src="' + url + '" class="absolute inset-0 w-full h-full border-none" style="min-height: 70vh;"></iframe>';
                }
            }
            else if (ext === 'xls' || ext === 'xlsx' || ext === 'csv') {
                badgeEl.textContent = 'SPREADSHEET DATA';
                iconEl.textContent = 'table_chart';
                try {
                    // Fetch and parse the excel document directly in the browser!
                    const response = await fetch(url);
                    const arrayBuffer = await response.arrayBuffer();
                    const workbook = XLSX.read(arrayBuffer, { type: 'array' });
                    
                    let tabsHtml = '<div class="flex border-b border-slate-200 bg-slate-50 px-4 pt-2 overflow-x-auto hide-scrollbar gap-2 shrink-0">';
                    let sheetsHtml = '<div class="flex-1 overflow-auto bg-white custom-scrollbar relative">';
                    
                    workbook.SheetNames.forEach((sheetName, index) => {
                        const worksheet = workbook.Sheets[sheetName];
                        let htmlData = '';
                        
                        // Check if sheet is essentially empty
                        if (!worksheet['!ref']) {
                            htmlData = '<div class="flex flex-col items-center justify-center p-16 text-slate-300"><span class="material-symbols-outlined text-6xl mb-4">hourglass_empty</span><p class="text-lg font-bold text-slate-400">Empty Sheet</p></div>';
                        } else {
                            try {
                                htmlData = XLSX.utils.sheet_to_html(worksheet, { id: 'sheet-table-' + index });
                            } catch(err) { 
                                htmlData = '<div class="p-8 text-center text-red-400">Error rendering sheet data.</div>'; 
                            }
                        }
                        
                        const tabClasses = (index === 0) ? 'border-primary text-slate-900' : 'border-transparent text-slate-400 hover:text-slate-700 hover:border-slate-300';
                        tabsHtml += '<button onclick="document.querySelectorAll(\'.xls-sheet\').forEach(el=>el.classList.add(\'hidden\')); document.getElementById(\'sheet-view-' + index + '\').classList.remove(\'hidden\'); document.querySelectorAll(\'.xls-tab\').forEach(el=>el.classList.remove(\'border-primary\', \'text-slate-900\')); this.classList.add(\'border-primary\', \'text-slate-900\');" class="xls-tab whitespace-nowrap py-3 px-5 border-b-2 text-[10px] uppercase font-black tracking-widest transition-colors ' + tabClasses + '">' + sheetName + '</button>';
                        
                        const sheetHidden = (index === 0) ? '' : 'hidden';
                        sheetsHtml += '<div id="sheet-view-' + index + '" class="xls-sheet ' + sheetHidden + ' min-w-max mx-auto p-4 sm:p-8">' + htmlData + '</div>';
                    });
                    
                    tabsHtml += '</div>';
                    sheetsHtml += '</div>';
                    
                    contentDiv.innerHTML = '<div class="flex flex-col h-full">' + tabsHtml + sheetsHtml + '</div>';
                    
                    // Style ALL generated tables
                    const tables = contentDiv.getElementsByTagName('table');
                    for (let table of tables) {
                        table.className = "min-w-full divide-y divide-slate-300 shadow-sm ring-1 ring-slate-200 sm:rounded-lg bg-white";
                        const trs = table.getElementsByTagName('tr');
                        for(let i=0; i<trs.length; i++) {
                            trs[i].className = i === 0 ? "bg-slate-50" : "hover:bg-slate-50/50 transition-colors";
                            const cells = trs[i].querySelectorAll('td, th');
                            cells.forEach(cell => {
                                cell.className = "whitespace-nowrap px-4 py-3 text-xs text-slate-600 border border-slate-200/50";
                                if(i === 0) cell.classList.add("font-bold", "text-slate-900");
                            });
                        }
                    }
                } catch (e) {
                    contentDiv.innerHTML = `
                        <div class="absolute inset-0 flex flex-col items-center justify-center p-8 text-center bg-slate-50">
                            <span class="material-symbols-outlined text-red-500 text-6xl mb-4">error</span>
                            <h3 class="text-lg font-bold text-slate-900">Failed to render Spreadsheet</h3>
                            <p class="text-sm text-slate-500 mt-2 max-w-md">The file could not be parsed. The format may be unsupported or the file could be corrupt.</p>
                            <a href="` + url + `" download class="mt-8 px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-xl shadow-lg shadow-primary/20 font-bold transition-all active:scale-95 flex items-center gap-2">
                                <span class="material-symbols-outlined">download</span> Download File Now
                            </a>
                        </div>
                    `;
                }
            } 
            else {
                badgeEl.textContent = 'UNKNOWN FORMAT';
                iconEl.textContent = 'unknown_document';
                contentDiv.innerHTML = `
                    <div class="absolute inset-0 flex flex-col items-center justify-center p-8 text-center bg-slate-50">
                        <span class="material-symbols-outlined text-slate-300 text-8xl mb-6">description_off</span>
                        <h3 class="text-xl font-bold text-slate-900">Preview not available</h3>
                        <p class="text-sm text-slate-500 mt-2 max-w-md">Rich browser preview is only available for PDF documents and Excel spreadsheets. Please download this file to view it.</p>
                        <a href="` + url + `" download class="mt-8 px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-xl shadow-lg shadow-primary/20 font-bold transition-all active:scale-95 flex items-center gap-2">
                            <span class="material-symbols-outlined">download</span> Download File Now
                        </a>
                    </div>
                `;
            }
        }
    </script>
</body>
</html>
