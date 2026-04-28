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
                    List<Policy> myPolicies = policyDAO.getCustomerPolicies(userId);
                    
                    NotificationDAO noteDAO = new NotificationDAO();
                    List<Notification> notifications = noteDAO.getNotificationsByUserId(userId);
                    int unreadCount = noteDAO.getUnreadCount(userId);

                    if (myPolicies == null) {
                        myPolicies = new ArrayList<>();
                    }
                %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>Support - NIC Insurance</title>
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
                                        class="text-sm font-bold text-primary">Support</a>
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
                                <div class="text-center max-w-3xl mx-auto">
                                    <div class="h-16 w-16 bg-primary/10 text-primary flex items-center justify-center rounded-2xl mx-auto mb-6">
                                        <span class="material-symbols-outlined text-3xl">support_agent</span>
                                    </div>
                                    <h1 class="text-3xl lg:text-4xl font-black text-slate-950 tracking-tight">How can we help you today?</h1>
                                    <p class="text-slate-500 mt-4 font-medium text-sm lg:text-base">Search for answers in our help center or reach out to our support team directly. We are here 24/7 to assist you.</p>
                                    
                                    <div class="relative max-w-xl mx-auto mt-8">
                                        <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl">search</span>
                                        <input type="text" id="faqSearch" onkeyup="filterFaqs(this.value)" placeholder="Search for answers, e.g., 'How to file a claim'"
                                            class="w-full bg-white border border-slate-200 rounded-2xl pl-12 pr-4 py-4 text-sm focus:ring-2 focus:ring-primary shadow-sm outline-none transition-all">
                                    </div>
                                </div>

                                <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 lg:gap-16 pt-8">
                                    <!-- FAQ Section -->
                                    <div class="space-y-6">
                                        <h2 class="text-2xl font-black text-slate-950 flex items-center gap-2">
                                            <span class="material-symbols-outlined text-primary">quick_reference_all</span> 
                                            Frequently Asked Questions
                                        </h2>
                                        
                                        <div class="space-y-4">
                                            <!-- FAQ Item 1 -->
                                            <div class="faq-item bg-white border border-slate-100 rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer" onclick="toggleFaq(this)">
                                                <div class="faq-header flex justify-between items-center text-slate-900 font-bold mb-0 transition-colors">
                                                    <span>How do I file a new claim?</span>
                                                    <span class="faq-icon material-symbols-outlined text-slate-400 transition-colors">add_circle</span>
                                                </div>
                                                <p class="faq-content hidden text-sm font-medium text-slate-500 leading-relaxed pl-2 border-l-2 border-primary/20 mt-3 animate-in slide-in-from-top-2 duration-300">
                                                    To file a new claim, navigate to your Dashboard and click on "File a Claim". Ensure you have all necessary evidence ready to upload before starting the process.
                                                </p>
                                            </div>
                                            
                                            <!-- FAQ Item 2 -->
                                            <div class="faq-item bg-white border border-slate-100 rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer ring-1 ring-primary/10" onclick="toggleFaq(this)">
                                                <div class="faq-header flex justify-between items-center text-primary font-bold mb-0 transition-colors">
                                                    <span>What forms of payment do you accept?</span>
                                                    <span class="faq-icon material-symbols-outlined text-primary transition-colors">do_not_disturb_on</span>
                                                </div>
                                                <p class="faq-content text-sm font-medium text-slate-500 leading-relaxed pl-2 border-l-2 border-primary/20 mt-3 animate-in slide-in-from-top-2 duration-300">
                                                    We accept all major credit cards (Visa, MasterCard, American Express), bank transfers, and digital wallets like Apple Pay and Google Pay. Auto-pay can be set up in your payment settings.
                                                </p>
                                            </div>
                                            
                                            <!-- FAQ Item 3 -->
                                            <div class="faq-item bg-white border border-slate-100 rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer" onclick="toggleFaq(this)">
                                                <div class="faq-header flex justify-between items-center text-slate-900 font-bold mb-0 transition-colors">
                                                    <span>How long does the claims process take?</span>
                                                    <span class="faq-icon material-symbols-outlined text-slate-400 transition-colors">add_circle</span>
                                                </div>
                                                <p class="faq-content hidden text-sm font-medium text-slate-500 leading-relaxed pl-2 border-l-2 border-primary/20 mt-3 animate-in slide-in-from-top-2 duration-300">
                                                    Most claims are processed within 2-4 business days after all documentation is submitted. Complex claims may require additional investigation time.
                                                </p>
                                            </div>

                                            <!-- FAQ Item 4 (Hidden) -->
                                            <div class="faq-item hidden-faq hidden bg-white border border-slate-100 rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer" onclick="toggleFaq(this)">
                                                <div class="faq-header flex justify-between items-center text-slate-900 font-bold mb-0 transition-colors">
                                                    <span>How do I cancel my policy?</span>
                                                    <span class="faq-icon material-symbols-outlined text-slate-400 transition-colors">add_circle</span>
                                                </div>
                                                <p class="faq-content hidden text-sm font-medium text-slate-500 leading-relaxed pl-2 border-l-2 border-primary/20 mt-3 animate-in slide-in-from-top-2 duration-300">
                                                    You can request a cancellation by navigating to "My Coverage", selecting your policy, and clicking "Manage Plan". Follow the cancellation wizard to complete your request.
                                                </p>
                                            </div>

                                            <!-- FAQ Item 5 (Hidden) -->
                                            <div class="faq-item hidden-faq hidden bg-white border border-slate-100 rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow cursor-pointer" onclick="toggleFaq(this)">
                                                <div class="faq-header flex justify-between items-center text-slate-900 font-bold mb-0 transition-colors">
                                                    <span>How do I update my payment method?</span>
                                                    <span class="faq-icon material-symbols-outlined text-slate-400 transition-colors">add_circle</span>
                                                </div>
                                                <p class="faq-content hidden text-sm font-medium text-slate-500 leading-relaxed pl-2 border-l-2 border-primary/20 mt-3 animate-in slide-in-from-top-2 duration-300">
                                                    Go to "My Coverage", select the policy you want to update, click "Manage Plan", and choose "Billing Information". You can securely add a new card there.
                                                </p>
                                            </div>

                                            <button type="button" id="viewAllBtn" onclick="toggleAllFaqs()" class="text-primary font-bold text-sm flex items-center gap-1 hover:gap-2 transition-all mt-6">
                                                <span id="viewAllText">View all FAQs</span> <span class="material-symbols-outlined text-sm">arrow_right_alt</span>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Contact Form -->
                                    <div>
                                        <div class="bg-white border border-slate-100 rounded-[2.5rem] p-8 shadow-xl shadow-slate-200/50">
                                            <h2 class="text-2xl font-black text-slate-950 flex items-center gap-2 mb-6">
                                                <span class="material-symbols-outlined text-primary">mail</span> 
                                                Contact Us
                                            </h2>
                                            
                                            <form action="support_process.jsp" method="post" class="space-y-5">
                                                <% if ("success".equals(request.getParameter("msg"))) { %>
                                                <div class="bg-emerald-50 text-emerald-700 p-4 rounded-xl text-sm font-bold flex items-center gap-2 mb-4 border border-emerald-100">
                                                    <span class="material-symbols-outlined">check_circle</span>
                                                    Message sent successfully!
                                                </div>
                                                <% } %>
                                                <div class="grid grid-cols-2 gap-5">
                                                    <div class="space-y-1.5">
                                                        <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Name</label>
                                                        <input type="text" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all" value="<%= user.getFullName() %>" readonly>
                                                    </div>
                                                    <div class="space-y-1.5">
                                                        <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Email</label>
                                                        <input type="email" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all" value="<%= user.getEmail() %>" readonly>
                                                    </div>
                                                </div>
                                                
                                                <div class="space-y-1.5">
                                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Topic</label>
                                                    <select name="topic" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all appearance-none cursor-pointer">
                                                        <option value="Billing & Payments">Billing & Payments</option>
                                                        <option value="Policy Questions">Policy Questions</option>
                                                        <option value="Claims Assistance">Claims Assistance</option>
                                                        <option value="Technical Support">Technical Support</option>
                                                    </select>
                                                </div>

                                                <div class="space-y-1.5">
                                                    <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Message</label>
                                                    <textarea name="message" required rows="4" placeholder="How can we help you?" class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all resize-none"></textarea>
                                                </div>

                                                <button type="submit" class="w-full py-4 bg-primary text-white hover:bg-primary-dark rounded-2xl text-sm font-black transition-colors shadow-lg shadow-primary/20 flex items-center justify-center gap-2 mt-4">
                                                    Send Message <span class="material-symbols-outlined text-sm">send</span>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </main>
                                <script>
                                    function toggleFaq(element) {
                                        const isExpanded = element.classList.contains('ring-1');
                                        
                                        // Collapse all first
                                        document.querySelectorAll('.faq-item').forEach(item => {
                                            item.classList.remove('ring-1', 'ring-primary/10');
                                            item.querySelector('.faq-content').classList.add('hidden');
                                            item.querySelector('.faq-icon').innerText = 'add_circle';
                                            item.querySelector('.faq-icon').classList.remove('text-primary');
                                            item.querySelector('.faq-icon').classList.add('text-slate-400');
                                            
                                            const header = item.querySelector('.faq-header');
                                            header.classList.remove('text-primary');
                                            header.classList.add('text-slate-900');
                                        });

                                        // Expand clicked if it wasn't already expanded
                                        if (!isExpanded) {
                                            element.classList.add('ring-1', 'ring-primary/10');
                                            element.querySelector('.faq-content').classList.remove('hidden');
                                            element.querySelector('.faq-icon').innerText = 'do_not_disturb_on';
                                            element.querySelector('.faq-icon').classList.remove('text-slate-400');
                                            element.querySelector('.faq-icon').classList.add('text-primary');
                                            
                                            const header = element.querySelector('.faq-header');
                                            header.classList.remove('text-slate-900');
                                            header.classList.add('text-primary');
                                        }
                                    }

                                    function toggleAllFaqs() {
                                        const hiddenFaqs = document.querySelectorAll('.hidden-faq');
                                        if(hiddenFaqs.length === 0) return;
                                        
                                        const isShowing = !hiddenFaqs[0].classList.contains('hidden');
                                        hiddenFaqs.forEach(faq => {
                                            if (isShowing) { faq.classList.add('hidden'); }
                                            else { faq.classList.remove('hidden'); }
                                        });
                                        document.getElementById('viewAllText').innerText = isShowing ? 'View all FAQs' : 'View less FAQs';
                                    }

                                    function filterFaqs(query) {
                                        const q = query.toLowerCase();
                                        const faqs = document.querySelectorAll('.faq-item');
                                        
                                        faqs.forEach(faq => {
                                            const text = faq.innerText.toLowerCase();
                                            if (text.includes(q)) {
                                                faq.style.display = '';
                                                // When searching, we unhide it even if it's a "hidden-faq"
                                                if (q) faq.classList.remove('hidden'); 
                                            } else {
                                                faq.style.display = 'none';
                                            }
                                        });
                                        
                                        const btn = document.getElementById('viewAllBtn');
                                        if (q) {
                                            btn.style.display = 'none';
                                        } else {
                                            btn.style.display = 'flex';
                                            // Reset to whatever the button says
                                            const isShowing = document.getElementById('viewAllText').innerText === 'View less FAQs';
                                            document.querySelectorAll('.hidden-faq').forEach(faq => {
                                                if (!isShowing) faq.classList.add('hidden');
                                            });
                                        }
                                    }

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