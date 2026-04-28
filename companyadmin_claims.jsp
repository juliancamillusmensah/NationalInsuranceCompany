<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess.getAttribute("roleId") != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || (!"ROLE_ADMIN".equals(roleId) && !"ROLE_SUPPORT".equals(roleId))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    ClaimDAO claimDAO = new ClaimDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    
    request.setAttribute("notifications", notificationDAO.getNotificationsByUserId(currentUser.getId()));
    request.setAttribute("unreadNotifications", notificationDAO.getUnreadCount(currentUser.getId()));
    
    List<Claim> allClaims = (companyId != null) ? claimDAO.getClaimsByCompanyId(companyId) : claimDAO.getAllClaims();
    
    String currentFilter = request.getParameter("filter");
    if (currentFilter == null || currentFilter.trim().isEmpty()) {
        currentFilter = "all";
    }
    
    // Workflow stats
    int untreatedCount = 0;
    int processingCount = 0;
    int settledCount = 0;
    for(Claim c : allClaims) {
        String st = c.getStatus() != null ? c.getStatus().toLowerCase() : "";
        if(st.equals("reported") || st.equals("acknowledged") || st.equals("pending")) untreatedCount++;
        else if(st.equals("reviewing") || st.equals("offer_made") || st.equals("processing") || st.equals("under review")) processingCount++;
        else if(st.equals("settled") || st.equals("approved") || st.equals("rejected") || st.equals("paid")) settledCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Claims Pipeline - NIC Regulatory Workflow</title>
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
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
</head>
<body class="bg-background-light text-slate-900 antialiased min-h-screen">
    <div class="flex flex-col xl:flex-row min-h-screen">
        <!-- Sidebar -->
        <jsp:include page="common/sidebar.jsp" />

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50 min-w-0 overflow-x-hidden">
            <jsp:include page="common/header.jsp" />

            <div class="p-6 lg:p-10 xl:p-14 space-y-10">
                <!-- Header Stats -->
                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 lg:gap-8">
                    <div class="bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Untreated</p>
                        <h3 class="text-3xl font-black text-slate-950"><%= untreatedCount %></h3>
                        <p class="text-[10px] text-amber-600 font-bold mt-2 flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">schedule</span> 48h Acknowledgment Target
                        </p>
                    </div>
                    <div class="bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">In Processing</p>
                        <h3 class="text-3xl font-black text-slate-950"><%= processingCount %></h3>
                        <p class="text-[10px] text-blue-600 font-bold mt-2 flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">assignment</span> Under active review
                        </p>
                    </div>
                    <div class="bg-white p-6 rounded-[2rem] border border-slate-100 shadow-sm">
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Settled (YTD)</p>
                        <h3 class="text-3xl font-black text-slate-950"><%= settledCount %></h3>
                        <p class="text-[10px] text-emerald-600 font-bold mt-2 flex items-center gap-1">
                            <span class="material-symbols-outlined text-sm">verified</span> 4-Week TAT compliance
                        </p>
                    </div>
                </div>

                <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                    <div class="p-8 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-6">
                        <h3 class="text-xl font-black text-slate-950">NIC Regulatory Pipeline</h3>
                        <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto relative">
                            <!-- Filter Dropdown Container -->
                            <div class="relative w-full sm:w-auto z-[60]">
                                <button onclick="document.getElementById('filterDropdown').classList.toggle('hidden')" class="px-6 py-3 bg-white border border-slate-200 text-slate-500 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-slate-50 transition-all w-full sm:w-auto text-center flex items-center justify-center gap-2">
                                    <span class="material-symbols-outlined text-sm">filter_list</span>
                                    <%= currentFilter.equals("all") ? "Filter" : currentFilter.replace("_", " ") %>
                                </button>
                                <!-- Dropdown Menu -->
                                <div id="filterDropdown" class="hidden absolute left-0 sm:right-auto right-0 mt-2 w-full sm:w-48 bg-white border border-slate-100 rounded-2xl shadow-xl overflow-hidden text-left origin-top">
                                    <a href="?filter=all" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "all".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">All Claims</a>
                                    <a href="?filter=Reported" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "Reported".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">Reported</a>
                                    <a href="?filter=Acknowledged" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "Acknowledged".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">Acknowledged</a>
                                    <a href="?filter=Reviewing" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "Reviewing".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">Reviewing</a>
                                    <a href="?filter=Offer_Made" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "Offer_Made".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">Offer Made</a>
                                    <a href="?filter=Settled" class="block px-5 py-3 text-[10px] font-black text-slate-600 hover:bg-slate-50 hover:text-primary uppercase tracking-widest transition-colors <%= "Settled".equals(currentFilter) ? "bg-slate-50 text-primary" : "" %>">Settled</a>
                                </div>
                            </div>
                            <!-- Export Button -->
                            <a href="export_claims.jsp?filter=<%= currentFilter %>" class="px-6 py-3 bg-primary text-white rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-primary/90 transition-all w-full sm:w-auto text-center flex items-center justify-center gap-2 shadow-lg shadow-primary/20">
                                <span class="material-symbols-outlined text-sm">download</span>
                                Export NIC Report
                            </a>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <!-- Mobile View: Cards (Visible on screens < 1280px) -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 xl:hidden">
                            <% if (allClaims != null && !allClaims.isEmpty()) {
                                boolean hasVisibleMobileClaims = false;
                                for (Claim c : allClaims) { 
                                    if (!"all".equals(currentFilter) && !c.getStatus().equalsIgnoreCase(currentFilter)) continue;
                                    hasVisibleMobileClaims = true;
                                    
                                    long now = System.currentTimeMillis();
                                    long hoursPassed = (now - c.getCreatedAt().getTime()) / (1000 * 60 * 60);
                                    String slaStatus = hoursPassed > 48 && c.getAcknowledgedAt() == null ? "Acknowledgment Overdue" : "On Track";
                                    String slaColor = slaStatus.contains("Overdue") ? "bg-red-50 text-red-600" : "bg-emerald-50 text-emerald-600";
                            %>
                            <div class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-sm space-y-4">
                                <div class="flex items-center justify-between">
                                    <div class="flex flex-col">
                                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">#<%= c.getId() %></span>
                                        <p class="text-sm font-black text-slate-950 font-display"><%= c.getPolicyName() %></p>
                                    </div>
                                    <span class="px-3 py-1 bg-slate-50 text-slate-600 rounded-full text-[9px] font-black uppercase tracking-tight border border-slate-100 italic">
                                        <%= c.getStatus() %>
                                    </span>
                                </div>

                                <div class="flex items-center gap-3 py-4 border-y border-slate-50">
                                    <div class="h-9 w-9 bg-slate-100 rounded-xl flex items-center justify-center font-bold text-slate-400 text-xs shrink-0">
                                        <%= (c.getUserName() != null) ? c.getUserName().substring(0, 1) : "?" %>
                                    </div>
                                    <div class="min-w-0">
                                        <p class="text-sm font-bold text-slate-950 truncate"><%= c.getUserName() %></p>
                                        <p class="text-[10px] text-slate-500 truncate"><%= c.getUserEmail() %></p>
                                    </div>
                                </div>

                                <div class="flex flex-col gap-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">SLA Status</span>
                                        <span class="px-2 py-0.5 rounded-full text-[9px] font-bold <%= slaColor %>"><%= slaStatus %></span>
                                    </div>
                                    <div class="flex justify-between items-end">
                                        <div class="flex flex-col">
                                            <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Incident Date</span>
                                            <span class="text-xs font-bold text-slate-700"><%= c.getIncidentDate() %></span>
                                        </div>
                                        <div class="flex gap-2">
                                            <% if (c.getDocumentPath() != null && !c.getDocumentPath().trim().isEmpty()) { %>
                                                <a href="DocumentDownloadServlet?file=<%= c.getDocumentPath() %>" class="p-2 bg-slate-50 text-slate-400 rounded-xl hover:text-primary transition-colors border border-slate-100">
                                                    <span class="material-symbols-outlined text-lg">attachment</span>
                                                </a>
                                            <% } %>
                                            <% if ("Reported".equals(c.getStatus())) { %>
                                                <form action="update_claim_status_process.jsp" method="POST">
                                                    <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                    <input type="hidden" name="status" value="Acknowledged">
                                                    <button type="submit" class="px-4 py-2 bg-primary text-white rounded-xl text-[10px] font-black uppercase tracking-widest">Ack.</button>
                                                </form>
                                            <% } else if ("Acknowledged".equals(c.getStatus())) { %>
                                                <form action="update_claim_status_process.jsp" method="POST">
                                                    <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                    <input type="hidden" name="status" value="Reviewing">
                                                    <button type="submit" class="px-4 py-2 bg-indigo-500 text-white rounded-xl text-[10px] font-black uppercase tracking-widest">Review</button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } 
                               if (!hasVisibleMobileClaims) { %>
                                <div class="bg-white p-12 rounded-[2.5rem] text-center border border-slate-100">
                                    <span class="material-symbols-outlined text-slate-200 text-4xl">gavel</span>
                                    <p class="text-xs text-slate-400 font-bold mt-4">No matching claims</p>
                                </div>
                            <% }
                               } %>
                        </div>

                        <!-- Desktop View: Table (Visible on screens >= 1280px) -->
                        <div class="hidden xl:block bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-slate-50/50 border-b border-slate-100">
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Incident</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Policyholder</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Compliance Status</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Current Stage</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-50">
                                        <% if (allClaims != null && !allClaims.isEmpty()) {
                                            boolean hasVisibleClaims = false;
                                            for (Claim c : allClaims) { 
                                                if (!"all".equals(currentFilter) && !c.getStatus().equalsIgnoreCase(currentFilter)) continue;
                                                hasVisibleClaims = true;
                                                long now = System.currentTimeMillis();
                                                long created = c.getCreatedAt().getTime();
                                                long hoursPassed = (now - created) / (1000 * 60 * 60);
                                                
                                                String slaStatus = "On Track";
                                                String slaColor = "text-emerald-500 bg-emerald-50";
                                                
                                                if (c.getAcknowledgedAt() == null && hoursPassed > 48) {
                                                    slaStatus = "Acknowledgment Overdue";
                                                    slaColor = "text-red-500 bg-red-100 animate-pulse";
                                                } else if (c.getSettledAt() == null && hoursPassed > (24 * 28)) {
                                                    slaStatus = "Settlement Breach";
                                                    slaColor = "text-red-600 bg-red-200 font-black";
                                                }
                                        %>
                                        <tr class="hover:bg-slate-50/50 transition-colors group">
                                            <td class="px-8 py-6">
                                                <p class="text-xs font-black text-slate-400">#<%= c.getId() %></p>
                                                <p class="text-sm font-bold text-slate-900 mt-1"><%= c.getPolicyName() %></p>
                                                <p class="text-[10px] text-slate-500 mt-1 italic"><%= c.getIncidentDate() %></p>
                                            </td>
                                            <td class="px-8 py-6">
                                                <div class="flex items-center gap-3">
                                                    <div class="h-9 w-9 bg-slate-100 rounded-xl flex items-center justify-center font-bold text-slate-400 text-xs">
                                                        <%= (c.getUserName() != null) ? c.getUserName().substring(0, 1) : "?" %>
                                                    </div>
                                                    <div>
                                                        <p class="text-sm font-bold text-slate-950"><%= c.getUserName() %></p>
                                                        <p class="text-[10px] text-slate-500"><%= c.getUserEmail() %></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-8 py-6">
                                                <span class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest <%= slaColor %>">
                                                    <%= slaStatus %>
                                                </span>
                                            </td>
                                            <td class="px-8 py-6">
                                                <div class="flex flex-col gap-1">
                                                    <span class="text-xs font-bold text-slate-900"><%= c.getStatus() %></span>
                                                    <% if (c.getAcknowledgedAt() != null) { %>
                                                        <span class="text-[9px] text-emerald-600 font-bold">Ack: <%= c.getAcknowledgedAt() %></span>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td class="px-8 py-6 text-right">
                                                <div class="flex items-center justify-end gap-2">
                                                    <% if (c.getDocumentPath() != null && !c.getDocumentPath().trim().isEmpty()) { %>
                                                        <a href="DocumentDownloadServlet?file=<%= c.getDocumentPath() %>" class="px-4 py-2 bg-slate-100 text-slate-600 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-slate-200 transition-all flex items-center gap-1 shadow-sm" title="Download Evidence">
                                                            <span class="material-symbols-outlined text-[14px]">attachment</span> Evidence
                                                        </a>
                                                    <% } %>
                                                    <% if ("Reported".equals(c.getStatus())) { %>
                                                        <form action="update_claim_status_process.jsp" method="POST">
                                                            <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                            <input type="hidden" name="status" value="Acknowledged">
                                                            <button type="submit" class="px-4 py-2 bg-primary text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-primary/90 transition-all shadow-md shadow-primary/20">Acknowledge</button>
                                                        </form>
                                                    <% } else if ("Acknowledged".equals(c.getStatus())) { %>
                                                        <form action="update_claim_status_process.jsp" method="POST">
                                                            <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                            <input type="hidden" name="status" value="Reviewing">
                                                            <button type="submit" class="px-4 py-2 bg-indigo-500 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-indigo-600 transition-all">Begin Review</button>
                                                        </form>
                                                    <% } else if ("Reviewing".equals(c.getStatus())) { %>
                                                        <form action="update_claim_status_process.jsp" method="POST">
                                                            <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                            <input type="hidden" name="status" value="Offer_Made">
                                                            <button type="submit" class="px-4 py-2 bg-emerald-500 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-emerald-600 transition-all">Issue DV</button>
                                                        </form>
                                                    <% } else if ("Offer_Made".equals(c.getStatus())) { %>
                                                        <form action="update_claim_status_process.jsp" method="POST">
                                                            <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                                            <input type="hidden" name="status" value="Settled">
                                                            <button type="submit" class="px-4 py-2 bg-slate-900 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-black transition-all">Settle Fund</button>
                                                        </form>
                                                    <% } else { %>
                                                        <span class="material-symbols-outlined text-emerald-500" style="font-variation-settings: 'FILL' 1">check_circle</span>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                        <% }
                                           if (!hasVisibleClaims) { %>
                                        <tr>
                                            <td colspan="5" class="px-8 py-20 text-center">
                                                <div class="flex flex-col items-center">
                                                    <span class="material-symbols-outlined text-slate-200 text-6xl">gavel</span>
                                                    <p class="text-slate-400 font-bold mt-4">No claims match the selected filter</p>
                                                </div>
                                            </td>
                                        </tr>
                                           <% }
                                         } else { %>
                                        <tr>
                                            <td colspan="5" class="px-8 py-20 text-center">
                                                <div class="flex flex-col items-center">
                                                    <span class="material-symbols-outlined text-slate-200 text-6xl">inventory_2</span>
                                                    <p class="text-slate-400 font-bold mt-4">No claims pipeline activity found</p>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <script>
                document.addEventListener('click', function(event) {
                    var dropdown = document.getElementById('filterDropdown');
                    var button = dropdown ? dropdown.previousElementSibling : null;
                    if (dropdown && button && !button.contains(event.target) && !dropdown.contains(event.target)) {
                        dropdown.classList.add('hidden');
                    }
                });
            </script>
        </main>
    </div>
</body>
</html>
