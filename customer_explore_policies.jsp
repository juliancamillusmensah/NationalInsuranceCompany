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
                    String userId = (String) sess.getAttribute("userId");
                    AccountDAO accountDAO = new AccountDAO();
                    PolicyDAO policyDAO = new PolicyDAO();
                    TransactionDAO transactionDAO = new TransactionDAO();
                    Account user = (Account) sess.getAttribute("user");
                    List<Policy> allPolicies = policyDAO.getAllActivePolicies();

                    NotificationDAO noteDAO = new NotificationDAO();
                    List<Notification> notifications = noteDAO.getNotificationsByUserId(userId);
                    int unreadCount = noteDAO.getUnreadCount(userId);

                    if (allPolicies == null) {
                        allPolicies = new ArrayList<>();
                    }
                %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>Explore Policies - NIC Insurance</title>
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
                                class="bg-white border-b border-slate-100 h-auto lg:h-20 flex flex-col lg:flex-row lg:items-center px-6 lg:px-10 py-4 lg:py-0 sticky top-0 z-50 shadow-sm gap-4">
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
                                        class="text-sm font-bold text-primary">Explore
                                        Policies</a>
                                    <a href="customer_support.jsp"
                                        class="text-sm font-semibold text-slate-500 hover:text-primary transition-colors">Support</a>
                                </nav>

                                <div class="ml-auto flex items-center justify-between lg:justify-end gap-6 w-full lg:w-auto">
                                    <form action="customer_explore_policies.jsp" method="get" class="relative w-full lg:w-72" onsubmit="return false;">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                        <input type="text" id="policySearchInput" name="q" placeholder="Search policies..." value="${param.q}"
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
                                                        <% for (Notification note : notifications) {
                                                            String noteReadClass = note.isRead() ? "opacity-60" : "bg-primary/5 hover:bg-primary/10";
                                                            String noteColorClass = "Success".equals(note.getType()) ? "bg-emerald-100 text-emerald-600" : "bg-blue-100 text-blue-600";
                                                            String noteIcon = "Success".equals(note.getType()) ? "check_circle" : "info";
                                                        %>
                                                            <a href="mark_notification_read.jsp?id=<%= note.getId() %>" class="block p-3 rounded-xl transition-colors <%= noteReadClass %>">
                                                                <div class="flex gap-3">
                                                                    <div class="h-8 w-8 rounded-lg flex items-center justify-center shrink-0 <%= noteColorClass %>">
                                                                        <span class="material-symbols-outlined text-sm"><%= noteIcon %></span>
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
                                            class="h-10 w-10 rounded-full overflow-hidden border-2 border-slate-100 shadow-sm cursor-pointer hover:border-primary transition-all">
                                            <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= user.getFullName() %>" alt="Avatar"
                                                class="h-full w-full object-cover">
                                        </a>
                                        <a href="${pageContext.request.contextPath}/logout.jsp" class="p-2 text-slate-400 hover:text-red-500 transition-colors" title="Sign Out">
                                            <span class="material-symbols-outlined text-2xl">logout</span>
                                        </a>
                                    </div>
                                </div>
                            </header>

                            <main class="max-w-7xl mx-auto p-6 lg:p-10 space-y-10 lg:space-y-12">
                                <!-- Header Section -->
                                <div>
                                    <h1 class="text-3xl lg:text-4xl font-black text-slate-950 tracking-tight">Explore Policies</h1>
                                    <p class="text-slate-500 mt-2 font-medium text-sm lg:text-base">Discover comprehensive insurance plans designed for your unique needs.</p>
                                </div>

                                <!-- Filter Tabs -->
                                <div class="flex items-center justify-between border-b border-slate-100 pb-1 overflow-x-auto">
                                    <div class="flex gap-10 whitespace-nowrap min-w-max pr-6" id="filterTabs">
                                        <button class="filter-btn text-sm font-bold text-primary border-b-2 border-primary pb-3 -mb-1" data-filter="all">All Plans</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="auto">Auto</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="home">Home</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="life">Life</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="health">Health</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="travel">Travel</button>
                                        <button class="filter-btn text-sm font-semibold text-slate-400 pb-3 hover:text-slate-600 transition-colors" data-filter="general">General</button>
                                    </div>
                                </div>

                                <!-- All Policies Grid -->
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                                    <% if (allPolicies.isEmpty()) { %>
                                        <div class="col-span-full py-12 text-center">
                                            <span class="material-symbols-outlined text-6xl text-slate-300 mb-4">inventory_2</span>
                                            <h3 class="text-xl font-bold text-slate-900">No Policies Found</h3>
                                            <p class="text-slate-500 mt-2">Check back later for new insurance offerings.</p>
                                        </div>
                                    <% } else { %>
                                        <% for (Policy p : allPolicies) { 
                                            String type = (p.getPolicyType() != null ? p.getPolicyType() : "General").toLowerCase();
                                            String icon = type.contains("auto") ? "directions_car" : (type.contains("home") ? "home" : (type.contains("health") ? "medical_services" : (type.contains("life") ? "vital_signs" : (type.contains("travel") ? "flight" : "shield" )))); 
                                            
                                            String defaultImage = "https://images.unsplash.com/photo-1606836591695-4d58a73eba1e?q=80&w=800"; // General
                                            if (type.contains("auto")) defaultImage = "https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800";
                                            else if (type.contains("home")) defaultImage = "https://images.unsplash.com/photo-1518780664697-55e3ad937233?q=80&w=800";
                                            else if (type.contains("health")) defaultImage = "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?q=80&w=800";
                                            else if (type.contains("life")) defaultImage = "https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=800";
                                            else if (type.contains("travel")) defaultImage = "https://images.unsplash.com/photo-1530521954074-e64f6810b32d?q=80&w=800";
                                            
                                            String customImage = p.getImageUrl();
                                            String imagePath = (customImage != null && !customImage.trim().isEmpty()) ? customImage : defaultImage;
                                            String category = type;
                                        %>
                                            <div class="policy-card group bg-white rounded-[2.5rem] border border-slate-100 overflow-hidden hover:shadow-2xl transition-all duration-500 hover:-translate-y-2 flex flex-col h-full" data-category="<%= category %>">
                                                <div class="h-44 bg-slate-100 overflow-hidden relative shrink-0">
                                                    <img src="<%= imagePath %>" alt="<%= p.getPolicyName() %>"
                                                        onerror="this.onerror=null; this.src='<%= defaultImage %>';"
                                                        class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                                    <div class="absolute top-4 right-4 h-10 w-10 bg-white/90 backdrop-blur rounded-2xl flex items-center justify-center text-primary shadow-sm">
                                                        <span class="material-symbols-outlined"><%= icon %></span>
                                                    </div>
                                                </div>
                                                <div class="p-6 flex flex-col flex-1">
                                                    <div class="flex-1">
                                                        <h5 class="text-xl font-black text-slate-900 leading-tight"><%= p.getPolicyName() %></h5>
                                                        <p class="text-xs text-slate-500 font-medium mt-2 line-clamp-2"><%= p.getDescription() != null ? p.getDescription() : "Comprehensive coverage plan designed to protect what matters most." %></p>
                                                    </div>
                                                    
                                                    <div class="mt-6 pt-6 border-t border-slate-100 space-y-4">
                                                        <div class="flex items-center gap-3">
                                                            <div class="p-2 bg-slate-50 rounded-lg text-slate-400">
                                                                <span class="material-symbols-outlined text-sm">schedule</span>
                                                            </div>
                                                            <div>
                                                                <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider mb-0.5">Duration</p>
                                                                <p class="text-sm font-black text-slate-900"><%= p.getCoverageDuration() %></p>
                                                            </div>
                                                        </div>
                                                        <div class="flex justify-between items-end pt-2">
                                                            <div>
                                                                <p class="text-[10px] uppercase font-bold text-slate-400 tracking-wider mb-0.5">Premium</p>
                                                                <span class="text-primary font-black text-2xl">GH₵<%= p.getPremiumAmount() %><span
                                                                        class="text-xs font-bold text-primary/60">/mo</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="mt-6 flex flex-col gap-3">
                                                        <a href="customer_policy_details.jsp?id=<%= p.getId() %>" class="w-full py-3 border-2 border-primary/20 text-primary rounded-2xl text-xs font-black text-center hover:bg-primary/5 transition-all">
                                                            View Details
                                                        </a>
                                                        <a href="customer_enrollment_wizard.jsp?id=<%= p.getId() %>"
                                                            class="w-full py-4 bg-primary text-white hover:bg-primary-dark rounded-2xl text-sm font-black transition-colors shadow-lg shadow-primary/20 flex items-center justify-center gap-2">
                                                            Get Covered <span class="material-symbols-outlined text-sm">arrow_forward</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>
                                    <% } %>
                                </div>

                                <!-- Multi-step enrollment wizard moves the checkout to a dedicated page -->
                            </div>
                        </main>
                            <script>

                                document.addEventListener("DOMContentLoaded", function() {
                                    const searchInput = document.getElementById("policySearchInput");
                                    const policyCards = document.querySelectorAll(".policy-card");
                                    const filterBtns = document.querySelectorAll(".filter-btn");
                                    let currentFilter = "all";

                                    function filterPolicies() {
                                        const query = searchInput.value.toLowerCase();
                                        policyCards.forEach(card => {
                                            const title = card.querySelector("h5").innerText.toLowerCase();
                                            const desc = card.querySelector("p").innerText.toLowerCase();
                                            const category = card.getAttribute("data-category");
                                            
                                            const matchesSearch = title.includes(query) || desc.includes(query);
                                            const matchesFilter = currentFilter === "all" || category === currentFilter;

                                            if (matchesSearch && matchesFilter) {
                                                card.style.display = "flex";
                                            } else {
                                                card.style.display = "none";
                                            }
                                        });
                                    }

                                    searchInput.addEventListener("input", filterPolicies);

                                    filterBtns.forEach(btn => {
                                        btn.addEventListener("click", function() {
                                            // Update active tab styling
                                            filterBtns.forEach(b => {
                                                b.classList.remove("text-primary", "border-b-2", "border-primary", "font-bold");
                                                b.classList.add("text-slate-400", "font-semibold");
                                            });
                                            this.classList.remove("text-slate-400", "font-semibold");
                                            this.classList.add("text-primary", "border-b-2", "border-primary", "font-bold");

                                            currentFilter = this.getAttribute("data-filter");
                                            filterPolicies();
                                        });
                                    });

                                    // Initial filtering if there's a parameter in URL
                                    if(searchInput.value) {
                                        filterPolicies();
                                    }
                                });
                            </script>
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