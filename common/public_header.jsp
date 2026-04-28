<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPath = request.getRequestURI();
    String activeClass = "text-primary dark:text-primary underline underline-offset-8 decoration-2";
    String inactiveClass = "text-slate-600 hover:text-primary dark:text-slate-400 dark:hover:text-primary";
%>
<header class="sticky top-0 z-50 w-full border-b border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-background-dark/80 backdrop-blur-md">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 lg:h-20 items-center justify-between">
            <div class="flex items-center gap-3">
                <a href="allhomepage.jsp" class="flex items-center gap-3 group">
                    <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-white shadow-lg shadow-primary/20 group-hover:scale-110 transition-transform">
                        <span class="material-symbols-outlined text-2xl" style="font-variation-settings: 'FILL' 1">gavel</span>
                    </div>
                    <div class="flex flex-col">
                        <span class="text-xl font-black tracking-tight text-slate-900 dark:text-white leading-none">NIC GHANA</span>
                        <span class="text-[8px] font-black text-primary uppercase tracking-[0.2em] mt-1">Regulatory Portal</span>
                    </div>
                </a>
            </div>

            <!-- Desktop Nav -->
            <nav class="hidden lg:flex items-center gap-10">
                <a class="text-sm font-bold transition-colors <%= currentPath.contains("nic_acts_regulations.jsp") ? activeClass : inactiveClass %>" href="nic_acts_regulations.jsp">Acts & Regulations</a>
                <a class="text-sm font-bold transition-colors <%= currentPath.contains("nic_industry_data.jsp") ? activeClass : inactiveClass %>" href="nic_industry_data.jsp">Industry Data</a>
                <a class="text-sm font-bold transition-colors <%= currentPath.contains("public_publications.jsp") ? activeClass : inactiveClass %>" href="public_publications.jsp">Publications</a>
                <a class="text-sm font-bold transition-colors <%= currentPath.contains("nic_about_commission.jsp") ? activeClass : inactiveClass %>" href="nic_about_commission.jsp">About Commission</a>
            </nav>

            <div class="flex items-center gap-3 lg:gap-4">
                <a href="registercustomer.jsp"
                    class="hidden sm:inline-flex items-center justify-center gap-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-6 py-2.5 text-sm font-bold text-slate-900 dark:text-white hover:bg-slate-50 dark:hover:bg-slate-800 transition-all shadow-sm">
                    <span>Join Now</span>
                </a>
                <a href="allloginpage.jsp"
                    class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-2.5 text-sm font-bold text-white hover:bg-primary/90 transition-all shadow-lg shadow-primary/20 hover:scale-105 active:scale-95">
                    <span>Sign In</span>
                    <span class="material-symbols-outlined text-sm">login</span>
                </a>
                
                <!-- Mobile Menu Button -->
                <button onclick="document.getElementById('mobileMenu').classList.toggle('hidden')" class="lg:hidden p-2 text-slate-600 dark:text-slate-400">
                    <span class="material-symbols-outlined">menu</span>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Mobile Menu -->
    <div id="mobileMenu" class="hidden lg:hidden bg-white dark:bg-background-dark border-b border-slate-200 dark:border-slate-800 p-6 space-y-4 animate-in slide-in-from-top-4 duration-300">
        <a class="block text-sm font-bold <%= currentPath.contains("nic_acts_regulations.jsp") ? activeClass : inactiveClass %>" href="nic_acts_regulations.jsp">Acts & Regulations</a>
        <a class="block text-sm font-bold <%= currentPath.contains("nic_industry_data.jsp") ? activeClass : inactiveClass %>" href="nic_industry_data.jsp">Industry Data</a>
        <a class="block text-sm font-bold <%= currentPath.contains("public_publications.jsp") ? activeClass : inactiveClass %>" href="public_publications.jsp">Publications</a>
        <a class="block text-sm font-bold <%= currentPath.contains("nic_about_commission.jsp") ? activeClass : inactiveClass %>" href="nic_about_commission.jsp">About Commission</a>
        <div class="pt-4 flex flex-col gap-3">
            <a href="registercustomer.jsp" class="w-full py-3 text-center rounded-xl bg-slate-100 dark:bg-slate-800 text-sm font-bold">Join Now</a>
            <a href="allloginpage.jsp" class="w-full py-3 text-center rounded-xl bg-primary text-white text-sm font-bold">Sign In</a>
        </div>
    </div>
</header>
