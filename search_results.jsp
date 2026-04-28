<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String query = request.getParameter("q");
    if (query == null) query = "";
    
    SearchDAO searchDAO = new SearchDAO();
    Map<String, List<?>> searchResults = searchDAO.globalSearch(query);
    
    List<Company> companies = (List<Company>) searchResults.get("companies");
    List<Policy> policies = (List<Policy>) searchResults.get("policies");
    List<Claim> claims = (List<Claim>) searchResults.get("claims");
    List<GhanaRegistryEntry> registry = (List<GhanaRegistryEntry>) searchResults.get("registry");
    
    int totalResults = companies.size() + policies.size() + claims.size() + registry.size();
    
    // Helper for safe escaping
    java.util.function.Function<String, String> safe = (s) -> s == null ? "" : s.replace("\"", "&quot;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Search Results - <%= query %> | NIC Ghana Portal</title>
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
        <!-- Reuse Sidebar from Superadmin -->
        <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-slate-200 flex flex-col shrink-0 transform -translate-x-full lg:translate-x-0 lg:static transition-transform duration-300 ease-in-out">
            <div class="p-6 flex items-center justify-between lg:justify-start gap-3 border-b border-slate-50 lg:border-none">
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
            </nav>

            <div class="p-6 mt-auto border-t border-slate-50">
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
                        <input type="text" id="globalSearchInput" value="<%= query %>" placeholder="Search resources..." class="w-full pl-10 pr-4 py-2 bg-slate-50 border-none rounded-xl text-sm focus:ring-2 focus:ring-primary/20">
                    </div>
                </div>
            </header>

            <!-- Results Body -->
            <div class="flex-1 p-8 space-y-8">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 leading-tight">Search Results</h2>
                    <p class="text-slate-500 font-medium mt-1">Found <%= totalResults %> matches for "<span class="text-primary font-bold"><%= query %></span>"</p>
                </div>

                <% if (totalResults == 0) { %>
                    <div class="bg-white rounded-2xl border border-slate-200 p-12 text-center">
                        <div class="bg-slate-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
                            <span class="material-symbols-outlined text-slate-300 text-4xl">search_off</span>
                        </div>
                        <h3 class="text-lg font-bold text-slate-900">No results found</h3>
                        <p class="text-slate-500 max-w-xs mx-auto mt-2">Try adjusting your search terms or browsing the categories.</p>
                        <a href="Superadmin.jsp" class="inline-flex mt-6 px-6 py-2.5 bg-primary text-white rounded-xl font-bold text-sm">Return to Dashboard</a>
                    </div>
                <% } %>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Companies Results -->
                    <% if (!companies.isEmpty()) { %>
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 px-1">
                                <span class="material-symbols-outlined text-primary text-lg">corporate_fare</span>
                                <h3 class="text-sm font-black text-slate-900 uppercase tracking-widest">Network Partners</h3>
                            </div>
                            <div class="bg-white rounded-2xl border border-slate-200 overflow-hidden divide-y divide-slate-100">
                                <% for (Company c : companies) { %>
                                    <div class="p-4 hover:bg-slate-50 transition-colors cursor-pointer" onclick="window.location.href='superadmin_companies.jsp?search=<%= c.getName() %>'">
                                        <div class="flex items-center gap-3">
                                            <div class="h-10 w-10 bg-primary/5 rounded-xl flex items-center justify-center text-primary font-bold"><%= c.getName().substring(0,1) %></div>
                                            <div>
                                                <h4 class="text-sm font-bold text-slate-900"><%= c.getName() %></h4>
                                                <p class="text-[10px] font-medium text-slate-400"><%= c.getEmail() %></p>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <!-- Policies Results -->
                    <% if (!policies.isEmpty()) { %>
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 px-1">
                                <span class="material-symbols-outlined text-indigo-500 text-lg">verified_user</span>
                                <h3 class="text-sm font-black text-slate-900 uppercase tracking-widest">Insurance Policies</h3>
                            </div>
                            <div class="bg-white rounded-2xl border border-slate-200 overflow-hidden divide-y divide-slate-100">
                                <% for (Policy p : policies) { %>
                                    <div class="p-4 hover:bg-slate-50 transition-colors cursor-pointer">
                                        <div class="flex items-center gap-3">
                                            <div class="h-10 w-10 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-500"><span class="material-symbols-outlined text-xl">policy</span></div>
                                            <div class="flex-1 min-w-0">
                                                <h4 class="text-sm font-bold text-slate-900 truncate"><%= p.getPolicyName() %></h4>
                                                <p class="text-[10px] font-medium text-slate-400 truncate"><%= p.getDescription() %></p>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <!-- Claims Results -->
                    <% if (!claims.isEmpty()) { %>
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 px-1">
                                <span class="material-symbols-outlined text-amber-500 text-lg">emergency_home</span>
                                <h3 class="text-sm font-black text-slate-900 uppercase tracking-widest">Active Claims</h3>
                            </div>
                            <div class="bg-white rounded-2xl border border-slate-200 overflow-hidden divide-y divide-slate-100">
                                <% for (Claim c : claims) { %>
                                    <div class="p-4 hover:bg-slate-50 transition-colors cursor-pointer">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center gap-3">
                                                <div class="h-10 w-10 bg-amber-50 rounded-xl flex items-center justify-center text-amber-500 font-bold">#<%= c.getId() %></div>
                                                <div>
                                                    <h4 class="text-sm font-bold text-slate-900"><%= c.getPolicyName() %></h4>
                                                    <p class="text-[10px] font-medium text-slate-400">Status: <%= c.getStatus() %></p>
                                                </div>
                                            </div>
                                            <span class="material-symbols-outlined text-slate-300">chevron_right</span>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <!-- Global Ghana Registry Results -->
                    <% if (!registry.isEmpty()) { %>
                        <div class="col-span-full mt-8 border-t border-slate-200 pt-8 space-y-6">
                            <div class="flex items-center justify-between px-1">
                                <div class="flex items-center gap-3">
                                    <div class="bg-emerald-500 p-2 rounded-xl text-white shadow-lg shadow-emerald-200">
                                        <span class="material-symbols-outlined text-xl">verified</span>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-black text-slate-900 uppercase tracking-widest">Official Ghana Insurance Registry</h3>
                                        <p class="text-[10px] text-slate-500 font-bold mt-1">Official entries from the National Insurance Commission (NIC) Database</p>
                                    </div>
                                </div>
                                <span class="text-[10px] font-black bg-slate-100 text-slate-400 px-3 py-1 rounded-full uppercase tracking-tighter"><%= registry.size() %> Official Entities</span>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <% for (GhanaRegistryEntry e : registry) { 
                                    boolean alreadyPartner = false;
                                    for(Company comp : companies) {
                                        if(e.getCompanyName() != null && comp.getName() != null && comp.getName().equalsIgnoreCase(e.getCompanyName())) {
                                            alreadyPartner = true;
                                            break;
                                        }
                                    }
                                %>
                                    <div class="bg-white rounded-3xl border border-slate-200 p-6 hover:shadow-2xl hover:shadow-slate-200/50 transition-all group relative overflow-hidden">
                                        <div class="absolute -right-4 -top-4 w-24 h-24 bg-slate-50 rounded-full group-hover:scale-150 transition-transform duration-700"></div>
                                        <div class="relative flex flex-col h-full">
                                            <div class="flex items-center justify-between mb-4">
                                                <div class="h-12 w-12 bg-emerald-50 text-emerald-600 rounded-2xl flex items-center justify-center font-black text-xl border border-emerald-100">
                                                    <%= (e.getCompanyName() != null && !e.getCompanyName().isEmpty()) ? e.getCompanyName().substring(0,1) : "N" %>
                                                </div>
                                                <span class="text-[9px] font-black uppercase tracking-widest bg-emerald-50 text-emerald-600 px-2.5 py-1 rounded-lg border border-emerald-100"><%= e.getType() %></span>
                                            </div>
                                            <h4 class="text-base font-black text-slate-900 leading-tight"><%= e.getCompanyName() %></h4>
                                            <p class="text-xs font-bold text-primary mt-2 flex items-center gap-1">
                                                <span class="material-symbols-outlined text-sm">mail</span> <%= e.getOfficialEmail() %>
                                            </p>
                                            <p class="text-[10px] text-slate-400 mt-1 flex items-center gap-1 font-medium">
                                                <span class="material-symbols-outlined text-sm">location_on</span> <%= e.getHeadquarters() %>
                                            </p>

                                            <div class="mt-6 pt-6 border-t border-slate-50">
                                                <% if (alreadyPartner) { %>
                                                    <div class="flex items-center gap-2 text-emerald-600 text-[10px] font-black uppercase">
                                                        <span class="material-symbols-outlined text-base">check_circle</span> Already a Partner
                                                    </div>
                                                <% } else { %>
                                                    <button data-name="<%= safe.apply(e.getCompanyName()) %>" 
                                                            data-email="<%= safe.apply(e.getOfficialEmail()) %>" 
                                                            data-phone="<%= safe.apply(e.getOfficialPhone()) %>" 
                                                            data-address="<%= safe.apply(e.getHeadquarters()) %>" 
                                                            data-type="<%= safe.apply(e.getType()) %>" 
                                                            data-license="<%= safe.apply(e.getLicenseNumber()) %>" 
                                                            data-tin="<%= safe.apply(e.getTin()) %>" 
                                                            onclick="handleQuickAdd(this)"
                                                            class="w-full py-3 bg-slate-900 text-white rounded-2xl text-xs font-bold hover:bg-primary hover:shadow-lg hover:shadow-primary/20 transition-all active:scale-95 flex items-center justify-center gap-2">
                                                        <span class="material-symbols-outlined text-lg">add_business</span> Add as Partner
                                                    </button>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.getElementById('globalSearchInput').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                window.location.href = 'search_results.jsp?q=' + encodeURIComponent(this.value);
            }
        });
        
        document.getElementById('sidebarToggle')?.addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });
        
        function handleQuickAdd(btn) {
            const name = btn.getAttribute('data-name');
            const email = btn.getAttribute('data-email');
            const phone = btn.getAttribute('data-phone');
            const address = btn.getAttribute('data-address');
            const type = btn.getAttribute('data-type');
            const license = btn.getAttribute('data-license');
            const tin = btn.getAttribute('data-tin');
            quickAddPartner(name, email, phone, address, type, license, tin);
        }

        function quickAddPartner(name, email, phone, address, type, license, tin) {
            const params = new URLSearchParams({
                action: 'add',
                name: name,
                email: email,
                phone: phone,
                address: address,
                type: type,
                license: license,
                tin: tin
            });
            window.location.href = 'superadmin_companies.jsp?' + params.toString();
        }
    </script>
</body>
</html>
