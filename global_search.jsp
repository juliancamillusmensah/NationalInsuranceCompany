<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || roleId == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String query = request.getParameter("q");
    if (query == null) query = "";
    
    // Support sandboxing for company-specific admins
    String searchCompanyId = null;
    if ("ROLE_COMPANY_ADMIN".equals(roleId) || "ROLE_ADMIN".equals(roleId)) {
        searchCompanyId = (String) sess.getAttribute("companyId");
    }

    SearchDAO searchDAO = new SearchDAO();
    Map<String, List<?>> results = ("".equals(query)) ? null : searchDAO.globalSearch(query, searchCompanyId);
    
    List<Company> companies = null;
    List<Policy> policies = null;
    List<Claim> claims = null;
    List<GhanaRegistryEntry> registry = null;
    
    boolean hasResults = false;
    if (results != null) {
        companies = (List<Company>) results.get("companies");
        policies = (List<Policy>) results.get("policies");
        claims = (List<Claim>) results.get("claims");
        registry = (List<GhanaRegistryEntry>) results.get("registry");
        
        hasResults = (companies != null && !companies.isEmpty()) || (policies != null && !policies.isEmpty()) || (claims != null && !claims.isEmpty()) || (registry != null && !registry.isEmpty());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Search Results - NIC Regulatory Workflow</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
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
    <div class="flex flex-col lg:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/50 min-w-0">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-6 lg:p-10 space-y-10">
                <!-- Search Header -->
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <h2 class="text-3xl font-black text-slate-950">Global Search Results</h2>
                        <p class="text-xs text-slate-500 font-bold uppercase tracking-[0.2em] mt-1">
                            Query: "<%= query %>"
                        </p>
                    </div>
                </div>

                <% if (results == null || "".equals(query)) { %>
                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-20 text-center flex flex-col items-center">
                        <span class="material-symbols-outlined text-slate-200 text-6xl">search</span>
                        <h3 class="text-xl font-bold text-slate-900 mt-4">Perform a Search</h3>
                        <p class="text-slate-500 text-sm mt-2">Use the top search bar to scan the platform resources.</p>
                    </div>
                <% } else if (!hasResults) { %>
                    <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm p-20 text-center flex flex-col items-center">
                        <span class="material-symbols-outlined text-red-200 text-6xl">search_off</span>
                        <h3 class="text-xl font-bold text-slate-900 mt-4">No results found mapping those exact keywords</h3>
                        <p class="text-slate-500 text-sm mt-2">Try adjusting your terms or using less restrictive terminology.</p>
                    </div>
                <% } else { %>
                    
                    <div class="space-y-12">
                        <!-- Claims Section -->
                        <% if (claims != null && !claims.isEmpty()) { %>
                        <div>
                            <h3 class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-base">assignment</span> Claims Pipeline (<%= claims.size() %>)
                            </h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <% for (Claim c : claims) { %>
                                <a href="companyadmin_claims.jsp" class="block bg-white p-6 rounded-[2rem] border border-slate-100 hover:border-primary/30 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all group">
                                    <div class="flex justify-between items-start mb-4">
                                        <div class="h-10 w-10 bg-slate-50 text-slate-400 group-hover:bg-primary/10 group-hover:text-primary rounded-2xl flex items-center justify-center transition-colors">
                                            <span class="material-symbols-outlined">receipt_long</span>
                                        </div>
                                        <span class="px-3 py-1 bg-slate-50 text-[10px] font-black uppercase text-slate-500 rounded-full"><%= c.getStatus() %></span>
                                    </div>
                                    <h4 class="font-black text-slate-950 text-lg">#<%= c.getId() %></h4>
                                    <p class="text-xs font-bold text-slate-500 mt-1"><%= c.getPolicyName() %></p>
                                    <p class="text-[10px] text-slate-400 mt-2 line-clamp-2"><%= c.getDescription() %></p>
                                </a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>

                        <!-- Policies Section -->
                        <% if (policies != null && !policies.isEmpty()) { %>
                        <div>
                            <h3 class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-base">shield</span> Policies (<%= policies.size() %>)
                            </h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <% for (Policy p : policies) { %>
                                <a href="companyadmin_policies.jsp" class="block bg-white p-6 rounded-[2rem] border border-slate-100 hover:border-primary/30 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all group">
                                    <div class="flex justify-between items-start mb-4">
                                        <div class="h-10 w-10 bg-slate-50 text-slate-400 group-hover:bg-primary/10 group-hover:text-primary rounded-2xl flex items-center justify-center transition-colors">
                                            <span class="material-symbols-outlined">verified_user</span>
                                        </div>
                                        <span class="px-3 py-1 bg-emerald-50 text-[10px] font-black uppercase text-emerald-600 rounded-full"><%= p.getStatus() %></span>
                                    </div>
                                    <h4 class="font-black text-slate-950 text-lg"><%= p.getPolicyName() %></h4>
                                    <p class="text-[10px] font-bold uppercase text-slate-400 mt-1"><%= p.getPolicyType() %></p>
                                </a>
                                <% } %>
                            </div>
                        </div>
                        <% } %>

                        <!-- Registry Section -->
                        <% if (registry != null && !registry.isEmpty()) { %>
                        <div>
                            <h3 class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-base">gavel</span> Registry Entries (<%= registry.size() %>)
                            </h3>
                            <div class="bg-white rounded-[2.5rem] border border-slate-100 shadow-sm overflow-hidden overflow-x-auto">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-slate-50/50 border-b border-slate-100">
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Entity Name</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">TIN</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Type</th>
                                            <th class="px-8 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-50">
                                        <% for (GhanaRegistryEntry e : registry) { %>
                                        <tr class="hover:bg-slate-50/50 transition-colors">
                                            <td class="px-8 py-6">
                                                <p class="text-sm font-bold text-slate-950"><%= e.getCompanyName() %></p>
                                            </td>
                                            <td class="px-8 py-6 text-xs font-bold text-slate-500"><%= e.getTin() %></td>
                                            <td class="px-8 py-6 text-xs text-slate-500"><%= e.getType() %></td>
                                            <td class="px-8 py-6">
                                                <span class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest bg-emerald-50 text-emerald-600"><%= e.getComplianceStatus() %></span>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <% } %>

                    </div>
                <% } %>

            </div>
        </main>
    </div>
</body>
</html>
