<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null && sess.getAttribute("roleId") != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || (!"ROLE_ADMIN".equals(roleId) && !"ROLE_COMPANY_ADMIN".equals(roleId) && !"ROLE_SUPPORT".equals(roleId))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    PolicyDAO policyDAO = new PolicyDAO();
    String companyId = (String) sess.getAttribute("companyId");
    
    List<Policy> enrollments = policyDAO.getEnrolledSubscribers(companyId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Company Admin - Enrolled Subscribers</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f6f6f8" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
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

            <div class="flex-1 p-6 lg:p-10 xl:p-14 space-y-10 xl:space-y-14 text-slate-900">
                <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-8 mb-8">
                    <div>
                        <h2 class="text-3xl xl:text-4xl font-black text-slate-950">Active Subscribers</h2>
                        <p class="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em] mt-2">Enrollment & Documentation Audit</p>
                    </div>
                    <div class="flex items-center gap-3 self-start xl:self-auto">
                        <div class="bg-white px-8 py-6 rounded-[2rem] border border-slate-100 shadow-sm flex items-center gap-6 shrink-0">
                            <div class="w-12 h-12 rounded-2xl bg-primary/5 flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined text-3xl" style="font-variation-settings: 'FILL' 1">groups</span>
                            </div>
                            <div>
                                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Total Enrolled</p>
                                <p class="text-2xl font-black text-slate-950"><%= enrollments.size() %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="space-y-6">
                    <!-- Mobile View: Cards (Visible on screens < 1280px) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 xl:hidden">
                        <% if (enrollments != null && !enrollments.isEmpty()) { 
                            for (Policy e : enrollments) { 
                                boolean isActive = "active".equalsIgnoreCase(e.getPolicyStatus());
                        %>
                        <div class="bg-white p-6 rounded-[2.5rem] border border-slate-100 shadow-sm space-y-4">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="h-10 w-10 rounded-full bg-primary/5 flex items-center justify-center text-primary font-black text-xs">
                                        <%= e.getCustomerName().substring(0, 1) %>
                                    </div>
                                    <div>
                                        <p class="text-sm font-black text-slate-950"><%= e.getCustomerName() %></p>
                                        <p class="text-[10px] text-slate-400 font-bold"><%= e.getCustomerEmail() %></p>
                                    </div>
                                </div>
                                <span class="px-3 py-1 <%= isActive ? "bg-emerald-50 text-emerald-600" : "bg-red-50 text-red-600" %> rounded-full text-[9px] font-black uppercase tracking-tight">
                                    <%= e.getPolicyStatus() %>
                                </span>
                            </div>

                            <div class="pt-4 border-t border-slate-50 space-y-4">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest">Enrolled Policy</p>
                                        <p class="text-sm font-black text-slate-950"><%= e.getPolicyName() %></p>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest">Type</p>
                                        <p class="text-[10px] text-primary font-black uppercase"><%= e.getPolicyType() %></p>
                                    </div>
                                </div>

                                <div class="bg-slate-50 rounded-2xl p-4 border border-slate-100">
                                    <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mb-1">Insured Item</p>
                                    <p class="text-xs font-bold text-slate-700"><%= e.getInsuredItem() != null ? e.getInsuredItem() : "Not Specified" %></p>
                                </div>

                                <div class="flex justify-between items-end">
                                    <div class="flex flex-col">
                                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Tenure</span>
                                        <span class="text-xs font-bold text-slate-900 mt-1">Start: <%= e.getStartDate() %></span>
                                        <span class="text-[10px] text-slate-400 font-bold italic">End: <%= e.getEndDate() %></span>
                                    </div>
                                    <% if (e.getDocumentPath() != null && !e.getDocumentPath().trim().isEmpty()) { %>
                                        <a href="${pageContext.request.contextPath}/<%= e.getDocumentPath() %>" target="_blank" 
                                           class="inline-flex items-center gap-2 bg-emerald-50 text-emerald-600 px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-emerald-100 transition-colors border border-emerald-100 shadow-sm">
                                            <span class="material-symbols-outlined text-sm">description</span> View
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% } } else { %>
                            <div class="bg-white p-16 rounded-[3rem] border border-slate-100 text-center">
                                <span class="material-symbols-outlined text-slate-200 text-5xl">group_off</span>
                                <h4 class="text-lg font-black text-slate-900 mt-4">No subscribers found</h4>
                            </div>
                        <% } %>
                    </div>

                    <!-- Desktop View: Table (Visible on screens >= 1280px) -->
                    <div class="hidden xl:block bg-white rounded-[3rem] border border-slate-100 shadow-sm overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left min-w-[1000px]">
                                <thead>
                                    <tr class="bg-slate-50/50 border-b border-slate-100">
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Customer</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest text-center">Identity</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Enrolled Policy</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Insured Item</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Tenure</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest">Documentation</th>
                                        <th class="px-8 py-6 text-[10px] font-black text-slate-400 uppercase tracking-widest text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                                    <% if (enrollments != null && !enrollments.isEmpty()) { 
                                        for (Policy e : enrollments) { 
                                            boolean isActive = "active".equalsIgnoreCase(e.getPolicyStatus());
                                    %>
                                    <tr class="hover:bg-slate-50/50 transition-colors group">
                                        <td class="px-8 py-8">
                                            <div class="flex items-center gap-3">
                                                <div class="h-10 w-10 rounded-full bg-primary/5 flex items-center justify-center text-primary font-black text-xs">
                                                    <%= e.getCustomerName().substring(0, 1) %>
                                                </div>
                                                <div>
                                                    <p class="text-sm font-black text-slate-950"><%= e.getCustomerName() %></p>
                                                    <p class="text-[10px] text-slate-400 font-bold mt-0.5"><%= e.getCustomerEmail() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-8 py-8 text-center">
                                            <% 
                                                String kyc = e.getKycStatus() != null ? e.getKycStatus() : "Not Started";
                                                String kycBadge = "bg-slate-50 text-slate-400 border-slate-200";
                                                if ("Verified".equalsIgnoreCase(kyc)) kycBadge = "bg-emerald-50 text-emerald-600 border-emerald-100";
                                                else if ("Pending".equalsIgnoreCase(kyc)) kycBadge = "bg-amber-50 text-amber-600 border-amber-100 animate-pulse";
                                                else if ("Rejected".equalsIgnoreCase(kyc)) kycBadge = "bg-red-50 text-red-600 border-red-100";
                                            %>
                                                <span class="inline-flex items-center px-4 py-1 <%= kycBadge %> border rounded-full text-[9px] font-black uppercase tracking-tight">
                                                    <%= kyc %>
                                                </span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-8">
                                            <div>
                                                <p class="text-sm font-black text-slate-950"><%= e.getPolicyName() %></p>
                                                <p class="text-[10px] text-primary font-bold uppercase tracking-widest mt-0.5"><%= e.getPolicyType() %></p>
                                            </div>
                                        </td>
                                        <td class="px-8 py-8">
                                            <div class="bg-slate-50 rounded-xl px-4 py-3 border border-slate-100 inline-block">
                                                <p class="text-xs font-bold text-slate-700"><%= e.getInsuredItem() != null ? e.getInsuredItem() : "Not Specified" %></p>
                                            </div>
                                        </td>
                                        <td class="px-8 py-8">
                                            <div class="flex flex-col">
                                                <span class="text-xs font-bold text-slate-900">Start: <%= e.getStartDate() %></span>
                                                <span class="text-[10px] text-slate-400 font-bold italic mt-0.5">End: <%= e.getEndDate() %></span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-8">
                                            <% if (e.getDocumentPath() != null && !e.getDocumentPath().trim().isEmpty()) { %>
                                                <a href="${pageContext.request.contextPath}/<%= e.getDocumentPath() %>" target="_blank" 
                                                   class="inline-flex items-center gap-2 bg-emerald-50 text-emerald-600 px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-emerald-100 transition-colors border border-emerald-100">
                                                    <span class="material-symbols-outlined text-sm">description</span>
                                                    View Docs
                                                </a>
                                            <% } else { %>
                                                <span class="text-xs font-bold text-slate-300 italic">No files provided</span>
                                            <% } %>
                                        </td>
                                        <td class="px-8 py-8 text-center">
                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 <%= isActive ? "bg-emerald-50 text-emerald-600 border-emerald-100" : "bg-red-50 text-red-600 border-red-100" %> border rounded-full text-[9px] font-black uppercase tracking-tight">
                                                <%= e.getPolicyStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="6" class="px-10 py-32 text-center">
                                            <div class="flex flex-col items-center">
                                                <div class="h-20 w-20 bg-slate-50 flex items-center justify-center rounded-3xl mb-6">
                                                    <span class="material-symbols-outlined text-slate-200 text-5xl">group_off</span>
                                                </div>
                                                <h4 class="text-lg font-black text-slate-900">No subscribers found</h4>
                                                <p class="text-sm text-slate-400 font-medium mt-2">New enrollments via the wizard will appear here.</p>
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
</body>
</html>
