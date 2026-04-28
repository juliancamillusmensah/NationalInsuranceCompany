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
    PolicyDAO policyDAO = new PolicyDAO();
    NotificationDAO notificationDAO = new NotificationDAO();
    Account currentUser = (Account) sess.getAttribute("user");
    String companyId = (String) sess.getAttribute("companyId");
    
    List<Policy> allPolicies = (companyId != null) ? policyDAO.getPoliciesByCompany(companyId) : policyDAO.getAllPolicies();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Policy Inventory</title>
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
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50 min-w-0 overflow-x-hidden">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-12">
                <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-8">
                    <div>
                        <h2 class="text-3xl xl:text-4xl font-black text-slate-950">Policy Inventory</h2>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em] mt-2">Regulatory Portfolio Control</p>
                    </div>
                    <button onclick="document.getElementById('newPolicyModal').classList.remove('hidden')" 
                            class="bg-primary text-white px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-primary/90 transition-all flex items-center justify-center gap-3 shadow-2xl shadow-primary/20 w-full md:w-auto">
                        <span class="material-symbols-outlined text-xl">add_circle</span>
                        Launch New Policy
                    </button>
                </div>

                <% if ("added".equals(request.getParameter("status"))) { %>
                <div class="bg-emerald-50 border border-emerald-100 text-emerald-700 px-6 py-4 rounded-3xl flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500">
                    <span class="material-symbols-outlined flex-shrink-0">check_circle</span>
                    <p class="text-sm font-bold">Policy successfully integrated into the market.</p>
                </div>
                <% } %>

                <div class="space-y-6">
                    <!-- Mobile View: Cards (Visible on screens < 1280px) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 xl:hidden">
                        <% if (allPolicies != null && !allPolicies.isEmpty()) { 
                            for (Policy p : allPolicies) { 
                                boolean isActive = "active".equalsIgnoreCase(p.getStatus());
                        %>
                        <div class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-sm space-y-4 group">
                            <div class="flex items-center justify-between gap-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-2xl bg-slate-100 overflow-hidden flex-shrink-0">
                                        <img src="<%= (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) ? p.getImageUrl() : "https://api.dicebear.com/7.x/shapes/svg?seed=" + p.getPolicyName() %>" 
                                             class="w-full h-full object-cover">
                                    </div>
                                    <div>
                                        <p class="text-sm font-black text-slate-950"><%= p.getPolicyName() %></p>
                                        <span class="px-2 py-0.5 bg-slate-100 text-slate-500 rounded-full text-[8px] font-black uppercase tracking-widest mt-1">
                                            <%= p.getPolicyType() != null ? p.getPolicyType() : "General" %>
                                        </span>
                                    </div>
                                </div>
                                <span class="px-3 py-1 <%= isActive ? "bg-emerald-50 text-emerald-600 border-emerald-100" : "bg-slate-50 text-slate-400 border-slate-100" %> border rounded-full text-[9px] font-black uppercase tracking-tight">
                                    <%= p.getStatus() %>
                                </span>
                            </div>

                            <p class="text-[10px] text-slate-400 font-bold leading-relaxed line-clamp-2"><%= p.getDescription() %></p>

                            <div class="pt-4 border-t border-slate-50">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest">Base Premium</p>
                                        <p class="text-lg font-black text-slate-950">GH₵<%= p.getPremiumAmount() %></p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest">Tenure</p>
                                        <p class="text-[10px] font-black text-primary uppercase"><%= p.getCoverageDuration() != null ? p.getCoverageDuration() : "12 Months" %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="bg-white p-16 rounded-[3rem] border border-slate-100 text-center">
                            <span class="material-symbols-outlined text-slate-200 text-5xl">inventory_2</span>
                            <p class="text-slate-400 font-bold mt-4">Inventory is empty.</p>
                        </div>
                        <% } %>
                    </div>

                    <!-- Desktop View: Table (Visible on screens >= 1280px) -->
                    <div class="hidden xl:block bg-white rounded-[3rem] border border-slate-100 shadow-sm overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left min-w-[800px]">
                                <thead>
                                    <tr class="bg-slate-50/50 border-b border-slate-50">
                                        <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Policy Details</th>
                                        <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest text-center">Class</th>
                                        <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Premium</th>
                                        <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Tenure</th>
                                        <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <% if (allPolicies != null && !allPolicies.isEmpty()) { 
                                        for (Policy p : allPolicies) { 
                                            boolean isActive = "active".equalsIgnoreCase(p.getStatus());
                                    %>
                                    <tr class="hover:bg-slate-50/50 transition-colors group">
                                        <td class="px-10 py-8">
                                            <div class="flex items-center gap-4">
                                                <div class="w-12 h-12 rounded-2xl bg-slate-100 overflow-hidden flex-shrink-0">
                                                    <img src="<%= (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) ? p.getImageUrl() : "https://api.dicebear.com/7.x/shapes/svg?seed=" + p.getPolicyName() %>" 
                                                         class="w-full h-full object-cover transition-transform group-hover:scale-110">
                                                </div>
                                                <div>
                                                    <p class="text-sm font-black text-slate-950 group-hover:text-primary transition-colors"><%= p.getPolicyName() %></p>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-0.5 line-clamp-1 max-w-sm"><%= p.getDescription() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-10 py-8 text-center">
                                            <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[9px] font-black uppercase tracking-widest">
                                                <%= p.getPolicyType() != null ? p.getPolicyType() : "General" %>
                                            </span>
                                        </td>
                                        <td class="px-10 py-8">
                                            <p class="text-sm font-black text-slate-950">GH₵<%= p.getPremiumAmount() %></p>
                                        </td>
                                        <td class="px-10 py-8">
                                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest"><%= p.getCoverageDuration() != null ? p.getCoverageDuration() : "12 Months" %></p>
                                        </td>
                                        <td class="px-10 py-8 text-center">
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 <%= isActive ? "bg-emerald-50 text-emerald-600 border-emerald-100" : "bg-slate-50 text-slate-400 border-slate-100" %> border rounded-full text-[9px] font-black uppercase tracking-tight">
                                                <span class="w-1.5 h-1.5 rounded-full <%= isActive ? "bg-emerald-500 animate-pulse" : "bg-slate-300" %>"></span>
                                                <%= p.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <%  } 
                                       } else { %>
                                    <tr>
                                        <td colspan="5" class="px-10 py-32 text-center">
                                            <div class="flex flex-col items-center">
                                                <span class="material-symbols-outlined text-slate-200 text-6xl">inventory_2</span>
                                                <p class="text-slate-400 font-bold mt-4">Inventory is empty.</p>
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

            <jsp:include page="common/footer.jsp" />
        </main>
    </div>

    <!-- New Policy Modal (Unchanged functional logic, integrated styling) -->
    <div id="newPolicyModal" class="fixed inset-0 z-[100] hidden">
        <div class="absolute inset-0 bg-slate-950/40 backdrop-blur-md transition-opacity" onclick="this.parentElement.classList.add('hidden')"></div>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[calc(100%-2rem)] max-w-2xl max-h-[calc(100vh-2rem)] flex flex-col bg-white rounded-[2rem] md:rounded-[3rem] shadow-2xl overflow-hidden animate-in zoom-in-95 duration-200">
            <div class="p-6 md:p-10 border-b border-slate-50 flex items-center justify-between shrink-0">
                <div>
                    <h3 class="text-xl md:text-2xl font-black text-slate-950 leading-tight">Launch Policy</h3>
                    <p class="text-[10px] md:text-xs text-slate-400 font-bold uppercase tracking-widest mt-1">Product Market Entry</p>
                </div>
                <button onclick="document.getElementById('newPolicyModal').classList.add('hidden')" class="p-2 md:p-3 text-slate-400 hover:text-slate-950 hover:bg-slate-50 rounded-2xl transition-all">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <form action="add_policy_process.jsp" method="POST" class="p-6 md:p-10 space-y-6 md:space-y-8 overflow-y-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
                    <div class="md:col-span-2 space-y-3">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-1">Policy Identity</label>
                        <input type="text" name="policyName" required class="w-full bg-slate-50 border-none rounded-2xl py-4 md:py-5 px-5 md:px-6 text-sm font-bold text-slate-950 focus:ring-4 focus:ring-primary/10 transition-all" placeholder="e.g. Shield Plus Auto">
                    </div>
                    
                    <div class="md:col-span-2 space-y-3">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-1">Market Description</label>
                        <textarea name="description" required rows="3" class="w-full bg-slate-50 border-none rounded-2xl py-4 md:py-5 px-5 md:px-6 text-sm font-bold text-slate-950 focus:ring-4 focus:ring-primary/10 transition-all resize-none" placeholder="Target audience and key benefits..."></textarea>
                    </div>

                    <div class="space-y-3">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-1">Base Premium (GH₵)</label>
                        <input type="number" name="premium" required step="0.01" class="w-full bg-slate-50 border-none rounded-2xl py-4 md:py-5 px-5 md:px-6 text-sm font-bold text-slate-950 focus:ring-4 focus:ring-primary/10 transition-all">
                    </div>

                    <div class="space-y-3">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-1">Portfolio Category</label>
                        <select name="policyType" class="w-full bg-slate-50 border-none rounded-2xl py-4 md:py-5 px-5 md:px-6 text-sm font-bold text-slate-950 focus:ring-4 focus:ring-primary/10 transition-all">
                            <option value="Auto">Auto</option>
                            <option value="Health">Health</option>
                            <option value="Life">Life</option>
                            <option value="Home">Home</option>
                            <option value="Travel">Travel</option>
                        </select>
                    </div>
                </div>

                <div class="pt-4 md:pt-6 flex flex-col sm:flex-row gap-3 md:gap-4 shrink-0 mt-4 md:mt-0">
                    <button type="button" onclick="document.getElementById('newPolicyModal').classList.add('hidden')"
                            class="w-full sm:flex-1 py-4 md:py-5 rounded-2xl text-[10px] md:text-xs font-black text-slate-400 bg-slate-50 uppercase tracking-widest hover:bg-slate-100 transition-all">Cancel</button>
                    <button type="submit" 
                            class="w-full sm:flex-[2] py-4 md:py-5 rounded-2xl text-[10px] md:text-xs font-black text-white bg-slate-950 uppercase tracking-widest shadow-2xl hover:bg-slate-800 transition-all">Submit for Market Approval</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
