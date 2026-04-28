<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    CompanyDAO companyDAO = new CompanyDAO();
    List<Company> companies = companyDAO.getAllCompanies();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Registered Entities | NIC Ghana</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet" />
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
            @keyframes pulse-soft {
                0%, 100% { transform: scale(1); opacity: 1; }
                50% { transform: scale(1.1); opacity: 0.7; }
            }
            .pulse-live { animation: pulse-soft 2s infinite ease-in-out; }
            .entity-row { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
            .entity-row.hidden { display: none; }
        </style>
    </head>

    <body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
        <div class="relative flex min-h-screen flex-col">
            <jsp:include page="common/public_header.jsp" />

            <main class="flex-grow pb-32">
                <section class="py-20 bg-white dark:bg-slate-900">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="max-w-3xl mb-16">
                            <h1 class="text-4xl font-black tracking-tight sm:text-6xl">Registered <span class="text-primary italic">Entities.</span></h1>
                            <p class="mt-6 text-xl text-slate-600 dark:text-slate-400">
                                Verify the licensing status of insurance providers and intermediaries. Only entities listed here are authorized to conduct insurance business in Ghana.
                            </p>
                        </div>

                        <!-- Entity Header & Filter -->
                        <div class="flex flex-col md:flex-row md:items-end justify-between gap-8 mb-12">
                            <div class="flex-1 max-w-xl">
                                <div class="relative group">
                                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-primary transition-colors">search</span>
                                    <input type="text" id="entitySearch" placeholder="Search entities by name or license..." 
                                           class="w-full pl-12 pr-6 py-4 bg-white dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700 rounded-2xl text-sm focus:ring-4 focus:ring-primary/10 focus:border-primary transition-all shadow-sm">
                                </div>
                            </div>
                            
                            <div class="flex flex-wrap gap-2">
                                <button onclick="filterType('all', this)" class="filter-btn active px-5 py-2 rounded-xl bg-primary text-white text-xs font-black uppercase tracking-wider shadow-lg shadow-primary/20 transition-all">All Entities</button>
                                <button onclick="filterType('Non-Life', this)" class="filter-btn px-5 py-2 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 text-xs font-black uppercase tracking-wider hover:bg-slate-200 dark:hover:bg-slate-700 transition-all border border-transparent">Non-Life</button>
                                <button onclick="filterType('Life', this)" class="filter-btn px-5 py-2 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 text-xs font-black uppercase tracking-wider hover:bg-slate-200 dark:hover:bg-slate-700 transition-all border border-transparent">Life</button>
                                <button onclick="filterType('Broker', this)" class="filter-btn px-5 py-2 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 text-xs font-black uppercase tracking-wider hover:bg-slate-200 dark:hover:bg-slate-700 transition-all border border-transparent">Brokers</button>
                            </div>
                        </div>

                        <!-- Live Pulse Indicator -->
                        <div class="flex items-center gap-2 mb-4 px-2">
                            <div class="h-2 w-2 rounded-full bg-emerald-500 pulse-live"></div>
                            <span class="text-[10px] font-black uppercase tracking-[0.2em] text-emerald-600 dark:text-emerald-400">Live Registry Connection</span>
                        </div>

                        <!-- Entity List -->
                        <div class="overflow-hidden rounded-[2.5rem] border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-2xl">
                            <table class="w-full text-left">
                                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                                    <tr>
                                        <th class="px-8 py-6 text-xs font-black text-slate-500 uppercase tracking-widest">Entity Name</th>
                                        <th class="px-8 py-6 text-xs font-black text-slate-500 uppercase tracking-widest">License Type</th>
                                        <th class="px-8 py-6 text-xs font-black text-slate-500 uppercase tracking-widest">Status</th>
                                    </tr>
                                </thead>
                                <tbody id="entityList" class="divide-y divide-slate-100 dark:divide-slate-800">
                                    <% if (companies != null && !companies.isEmpty()) { 
                                        for (Company c : companies) {
                                            String letter = c.getName() != null && !c.getName().isEmpty() ? c.getName().substring(0, 1).toUpperCase() : "N";
                                            String category = c.getCompanyType();
                                            String compliance = c.getComplianceStatus();
                                            String badgeColor = "bg-emerald-100 text-emerald-700";
                                            String dotColor = "bg-emerald-500";
                                            
                                            if ("At Risk".equalsIgnoreCase(compliance)) {
                                                badgeColor = "bg-amber-100 text-amber-700";
                                                dotColor = "bg-amber-500";
                                            } else if ("Non-Compliant".equalsIgnoreCase(compliance)) {
                                                badgeColor = "bg-rose-100 text-rose-700";
                                                dotColor = "bg-rose-500";
                                            }
                                    %>
                                    <tr class="entity-row hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-all group" data-type="<%= category %>">
                                        <td class="px-8 py-6">
                                            <div class="flex items-center gap-4">
                                                <div class="h-10 w-10 flex items-center justify-center rounded-xl bg-primary/10 text-primary font-black border border-primary/5 group-hover:scale-110 transition-transform">
                                                    <%= letter %>
                                                </div>
                                                <div class="flex flex-col">
                                                    <span class="font-bold text-slate-900 dark:text-white group-hover:text-primary transition-colors entity-name"><%= c.getName() %></span>
                                                    <span class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mt-0.5"><%= c.getEmail() %></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <div class="flex flex-col">
                                                <span class="text-sm font-bold text-slate-600 dark:text-slate-400"><%= category %></span>
                                                <span class="text-[10px] font-bold text-primary tracking-tight mt-1">NIC-<%= c.getLicenseNumber() %></span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-6">
                                            <span class="inline-flex items-center gap-1.5 rounded-full <%= badgeColor %> px-2.5 py-1 text-xs font-black">
                                                <span class="h-1.5 w-1.5 rounded-full <%= dotColor %>"></span>
                                                <%= compliance %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="3" class="px-8 py-20 text-center">
                                            <div class="flex flex-col items-center gap-4">
                                                <span class="material-symbols-outlined text-6xl text-slate-200">business_center</span>
                                                <p class="text-slate-500 font-bold">No registered entities found in the registry.</p>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>

                                    <!-- Empty Result State -->
                                    <tr id="emptyState" class="hidden">
                                        <td colspan="3" class="px-8 py-20 text-center">
                                            <div class="flex flex-col items-center gap-4">
                                                <span class="material-symbols-outlined text-6xl text-slate-200">search_off</span>
                                                <p class="text-slate-500 font-bold">No entities match your search criteria.</p>
                                                <button onclick="resetFilters()" class="text-primary font-black text-xs uppercase tracking-widest hover:underline">Clear all filters</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="mt-12 p-8 rounded-3xl bg-amber-50 dark:bg-amber-900/10 border border-amber-100 dark:border-amber-900/30">
                            <div class="flex gap-6">
                                <span class="material-symbols-outlined text-amber-500 text-3xl">info</span>
                                <p class="text-sm font-bold text-amber-800 dark:text-amber-200">
                                    If you encounter an entity claiming to provide insurance products that is NOT listed here, please contact the Commission immediately to report unauthorized business.
                                </p>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <jsp:include page="common/public_footer.jsp" />
        </div>

        <script>
            let currentFilter = 'all';
            let searchTerm = '';

            const entityRows = document.querySelectorAll('.entity-row');
            const searchInput = document.getElementById('entitySearch');
            const emptyState = document.getElementById('emptyState');

            function filterEntities() {
                let visibleCount = 0;
                entityRows.forEach(row => {
                    const name = row.querySelector('.entity-name').innerText.toLowerCase();
                    const type = row.getAttribute('data-type');
                    
                    const matchesSearch = name.includes(searchTerm.toLowerCase());
                    let matchesFilter = currentFilter === 'all';
                    
                    if (currentFilter === 'Life') {
                        matchesFilter = (type === 'Life' || type.includes('Life &'));
                    } else if (currentFilter === 'Non-Life') {
                        matchesFilter = type.includes('Non-Life');
                    } else if (currentFilter === 'Broker') {
                        matchesFilter = type.includes('Broker');
                    }

                    if (matchesSearch && matchesFilter) {
                        row.classList.remove('hidden');
                        visibleCount++;
                    } else {
                        row.classList.add('hidden');
                    }
                });

                if (visibleCount === 0) {
                    emptyState.classList.remove('hidden');
                } else {
                    emptyState.classList.add('hidden');
                }
            }

            searchInput.addEventListener('input', (e) => {
                searchTerm = e.target.value;
                filterEntities();
            });

            function filterType(type, btn) {
                currentFilter = type;
                
                // Update Button UI
                document.querySelectorAll('.filter-btn').forEach(b => {
                    b.classList.remove('active', 'bg-primary', 'text-white', 'shadow-lg', 'shadow-primary/20');
                    b.classList.add('bg-slate-100', 'dark:bg-slate-800', 'text-slate-600', 'dark:text-slate-400');
                });
                
                btn.classList.add('active', 'bg-primary', 'text-white', 'shadow-lg', 'shadow-primary/20');
                btn.classList.remove('bg-slate-100', 'dark:bg-slate-800', 'text-slate-600', 'dark:text-slate-400', 'border-transparent');
                
                filterEntities();
            }

            function resetFilters() {
                searchInput.value = '';
                searchTerm = '';
                filterType('all', document.querySelector('.filter-btn[onclick*="all"]'));
            }
        </script>
    </body>
</html>
