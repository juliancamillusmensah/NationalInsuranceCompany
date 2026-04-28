<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.model.Account" %>
<%
    String currentRole = (String) session.getAttribute("roleId");
    String activePage = request.getRequestURI();
    boolean isAdmin = "ROLE_ADMIN".equals(currentRole) || "ROLE_COMPANY_ADMIN".equals(currentRole);
    boolean isSuper = "ROLE_SUPERADMIN".equals(currentRole);
%>
<aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-72 bg-white border-r border-slate-100 flex flex-col shrink-0 transform -translate-x-full xl:translate-x-0 xl:static transition-transform duration-300 ease-in-out">
    <div class="px-8 py-8 flex items-center justify-between">
        <% if (isAdmin || isSuper) { %>
            <div class="flex items-center gap-4">
                <div class="bg-white p-3 rounded-2xl text-primary shadow-xl shadow-slate-200/50">
                    <span class="material-symbols-outlined text-3xl" style="font-variation-settings: 'FILL' 1">security</span>
                </div>
                <div class="flex flex-col">
                    <span class="text-xl font-black tracking-tight text-slate-950">Admin Portal</span>
                    <span class="text-[10px] font-black text-primary uppercase tracking-[0.2em] mt-0.5">Operations v2.4</span>
                </div>
            </div>
        <% } else { %>
            <div class="flex items-center gap-4">
                <div class="bg-primary p-3 rounded-2xl text-white shadow-xl shadow-primary/20">
                    <span class="material-symbols-outlined text-3xl" style="font-variation-settings: 'FILL' 1">security</span>
                </div>
                <span class="text-xl font-black tracking-tight text-slate-950">NIC Ghana</span>
            </div>
        <% } %>
        <button onclick="document.getElementById('sidebar').classList.add('-translate-x-full')" class="xl:hidden p-2 text-slate-400 hover:bg-slate-50 transition-colors rounded-xl">
            <span class="material-symbols-outlined">close</span>
        </button>
    </div>

    <nav class="flex-1 px-4 mt-4 space-y-1 overflow-y-auto">
        <% if (isSuper) { %>
            <a href="Superadmin.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("Superadmin.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">grid_view</span>
                <span class="text-sm">Global Overview</span>
            </a>
            <a href="superadmin_companies.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("superadmin_companies.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">corporate_fare</span>
                <span class="text-sm">Regulated Entities</span>
            </a>
            <a href="superadmin_policies.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("superadmin_policies.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">verified_user</span>
                <span class="text-sm">Policy Registry</span>
            </a>
            <a href="superadmin_reports.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("superadmin_reports.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">analytics</span>
                <span class="text-sm">Market Reports</span>
            </a>
            <a href="superadmin_kyc.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("superadmin_kyc.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">how_to_reg</span>
                <span class="text-sm">KYC Verification</span>
            </a>
            <div class="pt-4">
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest px-4 mb-1">Integrations</p>
                <a href="email_settings.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("email_settings.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                    <span class="material-symbols-outlined text-2xl">mail</span>
                    <span class="text-sm">Email Settings</span>
                </a>
                <a href="paystack_settings.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("paystack_settings.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                    <span class="material-symbols-outlined text-2xl">credit_card</span>
                    <span class="text-sm">Paystack Settings</span>
                </a>
                <a href="sms_settings.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("sms_settings.jsp") ? "bg-primary/5 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                    <span class="material-symbols-outlined text-2xl">sms</span>
                    <span class="text-sm">SMS Settings</span>
                </a>
            </div>
        <% } else if (isAdmin) { %>
            <a href="Companyadmin.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("Companyadmin.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">grid_view</span>
                <span class="text-sm">Overview</span>
            </a>
            <a href="companyadmin_policies.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_policies.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">verified_user</span>
                <span class="text-sm">Policies</span>
            </a>
            <a href="companyadmin_subscribers.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_subscribers.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">groups</span>
                <span class="text-sm">Subscribers</span>
            </a>
            <a href="companyadmin_claims.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_claims.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">gavel</span>
                <span class="text-sm">Claims</span>
            </a>
            <a href="companyadmin_settings.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_settings.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">person_add</span>
                <span class="text-sm">Admin Settings</span>
            </a>
            <a href="companyadmin_activities.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_activities.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">history</span>
                <span class="text-sm">Activity Log</span>
            </a>
            <a href="companyadmin_transactions.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_transactions.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">payments</span>
                <span class="text-sm">Transactions</span>
            </a>
            <a href="companyadmin_filing.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("companyadmin_filing.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">finance_mode</span>
                <span class="text-sm">Market Filing</span>
            </a>
        <% } else { %>
            <a href="Customerportal.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("Customerportal.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">home</span>
                <span class="text-sm">Home</span>
            </a>
            <a href="customer_explore_policies.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("customer_explore_policies.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">explore</span>
                <span class="text-sm">Explore Policies</span>
            </a>
            <a href="customer_new_claim.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("customer_new_claim.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">add</span>
                <span class="text-sm">File a Claim</span>
            </a>
            <a href="customer_profile.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("customer_profile.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">account_balance_wallet</span>
                <span class="text-sm">My Portfolio</span>
            </a>
            <a href="customer_support.jsp" class="flex items-center gap-4 px-4 py-3.5 <%= activePage.contains("customer_support.jsp") ? "bg-primary/10 text-primary" : "text-slate-500 hover:bg-slate-50" %> rounded-2xl transition-all font-bold group">
                <span class="material-symbols-outlined text-2xl">support_agent</span>
                <span class="text-sm">NIC Support</span>
            </a>
        <% } %>
    </nav>

    <div class="p-8 mt-auto border-t border-slate-50">
        <a href="logout.jsp" class="flex items-center gap-4 px-4 py-3 w-full text-slate-500 hover:bg-slate-50 rounded-2xl transition-all font-bold">
            <span class="material-symbols-outlined text-2xl">logout</span>
            <span class="text-sm">Sign Out</span>
        </a>
    </div>
</aside>
