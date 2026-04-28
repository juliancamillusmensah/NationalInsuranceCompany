<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    AccountDAO accountDAO = new AccountDAO();
    List<Account> pendingUsers = accountDAO.getPendingKYCAccounts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Global KYC Verification - NIC Ghana</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#059669", "background-light": "#f8fafc" },
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
<body class="bg-background-light text-slate-800 antialiased min-h-screen">
    <div class="flex flex-col xl:flex-row min-h-screen">
        <jsp:include page="common/sidebar.jsp" />

        <main class="flex-1 flex flex-col min-h-screen bg-slate-50/30">
            <jsp:include page="common/header.jsp" />

            <div class="flex-1 p-8 lg:p-12 xl:p-16 max-w-[1600px] mx-auto w-full space-y-12">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div>
                        <h2 class="text-4xl font-black text-slate-900 tracking-tight">Identity Verification Queue</h2>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-[0.3em] mt-3 flex items-center gap-2">
                             System-Wide Regulatory Compliance <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        </p>
                    </div>
                    <div class="bg-white px-8 py-5 rounded-3xl border border-slate-200 shadow-sm flex items-center gap-6">
                        <div class="w-14 h-14 rounded-2xl bg-primary/5 flex items-center justify-center text-primary shadow-inner">
                            <span class="material-symbols-outlined text-3xl" style="font-variation-settings: 'FILL' 1">how_to_reg</span>
                        </div>
                        <div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Awaiting NIC Review</p>
                            <p class="text-3xl font-black text-slate-900 leading-none mt-1"><%= pendingUsers.size() %></p>
                        </div>
                    </div>
                </div>

                <% if ("success".equals(request.getParameter("kycUpdate"))) { %>
                    <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-2xl flex items-center gap-3 text-emerald-600 font-bold text-sm animate-in fade-in slide-in-from-top-4">
                        <span class="material-symbols-outlined">verified</span>
                        User identity verification has been updated successfully.
                    </div>
                <% } %>

                <div class="bg-white rounded-[3rem] border border-slate-200 shadow-xl shadow-slate-200/50 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="bg-slate-50/50 border-b border-slate-100">
                                    <th class="px-10 py-7 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Customer Profile</th>
                                    <th class="px-10 py-7 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Document Type</th>
                                    <th class="px-10 py-7 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Submission Date</th>
                                    <th class="px-10 py-7 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-50">
                                <% if (pendingUsers != null && !pendingUsers.isEmpty()) { 
                                    for (Account u : pendingUsers) { %>
                                    <tr class="hover:bg-slate-50/50 transition-colors group">
                                        <td class="px-10 py-8">
                                            <div class="flex items-center gap-4">
                                                <div class="h-12 w-12 rounded-2xl bg-slate-100 overflow-hidden border-2 border-transparent group-hover:border-primary transition-all">
                                                    <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=<%= u.getFullName() %>" class="h-full w-full object-cover">
                                                </div>
                                                <div>
                                                    <p class="text-base font-black text-slate-900 leading-none"><%= u.getFullName() %></p>
                                                    <p class="text-xs text-slate-400 font-bold mt-1.5"><%= u.getEmail() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-10 py-8">
                                            <span class="inline-flex items-center px-4 py-1.5 bg-slate-50 text-slate-600 rounded-full text-[10px] font-black uppercase tracking-widest border border-slate-200">
                                                <%= u.getKycDocumentType() %>
                                            </span>
                                        </td>
                                        <td class="px-10 py-8">
                                            <p class="text-xs font-bold text-slate-500"><%= u.getUpdatedAt() %></p>
                                        </td>
                                        <td class="px-10 py-8 text-center">
                                            <button onclick="openKYCModal('<%= u.getId() %>', '<%= u.getFullName() %>', '<%= u.getKycDocumentPath() %>', '<%= u.getKycPortraitPath() %>')" 
                                                class="px-6 py-2.5 bg-primary text-white text-[10px] font-black uppercase tracking-widest rounded-xl hover:bg-primary-dark shadow-lg shadow-primary/20 transition-all active:scale-95">
                                                Review Artifacts
                                            </button>
                                        </td>
                                    </tr>
                                <% } } else { %>
                                    <tr>
                                        <td colspan="4" class="px-10 py-32 text-center">
                                            <div class="max-w-sm mx-auto">
                                                <div class="w-20 h-20 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-6">
                                                    <span class="material-symbols-outlined text-emerald-400 text-4xl">check_circle</span>
                                                </div>
                                                <h4 class="text-xl font-black text-slate-900">Queue is empty</h4>
                                                <p class="text-sm text-slate-400 font-medium mt-3">All global identity verification requests have been processed.</p>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <jsp:include page="common/footer.jsp" />
        </main>
    </div>

    <!-- KYC Review Modal -->
    <div id="kycModal" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4 sm:p-6 md:p-10 lg:p-20">
        <div class="absolute inset-0 bg-slate-950/80 backdrop-blur-md transition-opacity" onclick="closeKYCModal()"></div>
        
        <div class="relative w-full max-w-6xl max-h-full bg-white rounded-3xl md:rounded-[4rem] shadow-2xl flex flex-col overflow-hidden animate-in zoom-in-95 duration-300">
            <!-- Modal Header -->
            <div class="px-6 py-6 md:px-12 md:py-10 border-b border-slate-100 flex items-center justify-between shrink-0 bg-slate-50/50">
                <div>
                    <h3 class="text-xl md:text-3xl font-black text-slate-900 tracking-tight leading-tight">Regulatory Evidence Audit</h3>
                    <p id="modalCustomerName" class="text-[10px] md:text-sm font-bold text-slate-400 mt-1 md:mt-2 uppercase tracking-widest"></p>
                </div>
                <button onclick="closeKYCModal()" class="h-10 w-10 md:h-14 md:w-14 flex items-center justify-center rounded-xl md:rounded-2xl bg-white text-slate-400 hover:text-rose-600 shadow-sm border border-slate-100 transition-all">
                    <span class="material-symbols-outlined text-2xl md:text-3xl">close</span>
                </button>
            </div>
            
            <!-- Modal Body -->
            <div class="flex-1 overflow-y-auto p-6 md:p-12 custom-scrollbar">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8 md:gap-12">
                    <!-- Identity Document Section -->
                    <div class="space-y-4 md:space-y-6 flex flex-col">
                        <div class="flex items-center justify-between px-2">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">National Identity Document</p>
                            <a id="modalIDLink" href="#" target="_blank" class="text-[10px] font-black text-primary uppercase hover:underline">Full Resolution</a>
                        </div>
                        <div class="h-[250px] sm:h-[350px] md:h-[450px] bg-slate-100 rounded-2xl md:rounded-[3rem] overflow-hidden flex items-center justify-center relative group border-4 border-white shadow-inner">
                            <img id="modalIDCard" class="w-full h-full object-contain" src="" alt="ID Card">
                        </div>
                    </div>
                    
                    <!-- Portrait Section -->
                    <div class="space-y-4 md:space-y-6 flex flex-col">
                        <div class="flex items-center justify-between px-2">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Verification Portrait</p>
                            <a id="modalPortraitLink" href="#" target="_blank" class="text-[10px] font-black text-primary uppercase hover:underline">Full Resolution</a>
                        </div>
                        <div class="h-[250px] sm:h-[350px] md:h-[450px] bg-slate-100 rounded-2xl md:rounded-[3rem] overflow-hidden flex items-center justify-center relative group border-4 border-white shadow-inner">
                            <img id="modalPortrait" class="w-full h-full object-contain" src="" alt="Portrait Photo">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="p-6 md:p-12 bg-slate-900 border-t border-white/5 flex flex-col lg:flex-row items-center justify-between gap-6 md:gap-8 shrink-0">
                <div class="flex items-start gap-4 max-w-xl self-start lg:self-center">
                    <div class="bg-primary/20 p-2.5 rounded-xl text-primary mt-1 shrink-0 hidden sm:block">
                        <span class="material-symbols-outlined text-sm">policy</span>
                    </div>
                    <p class="text-[10px] md:text-xs font-bold text-slate-400 leading-relaxed">
                        <span class="text-white block mb-1 uppercase tracking-widest text-[10px]">Regulatory Notice</span>
                        By approving this identity, you confirm that the provided documentation matches the portraits and meets the national insurance compliance standards of NIC Ghana.
                    </p>
                </div>
                <div class="flex items-center gap-4 w-full lg:w-auto">
                    <form action="companyadmin_verify_kyc_process.jsp" method="post" class="flex flex-col sm:flex-row items-center gap-4 w-full">
                        <input type="hidden" name="userId" id="modalUserId">
                        <input type="hidden" name="redirect" value="superadmin_kyc.jsp">
                        <button type="submit" name="status" value="Rejected" class="w-full sm:w-auto px-8 md:px-12 py-3 md:py-4 border-2 border-white/10 text-white rounded-xl md:rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-rose-600/20 hover:border-rose-600/30 transition-all">Reject Claim</button>
                        <button type="submit" name="status" value="Verified" class="w-full sm:w-auto px-8 md:px-12 py-3 md:py-4 bg-primary text-white rounded-xl md:rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-emerald-500 shadow-2xl shadow-emerald-500/20 transition-all">Authorize Identity</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openKYCModal(userId, name, idPath, portraitPath) {
            document.getElementById('modalUserId').value = userId;
            document.getElementById('modalCustomerName').innerText = "Reviewing Customer: " + name;
            
            const idImg = "DisplayImage?type=kyc&path=" + idPath;
            const portraitImg = "DisplayImage?type=kyc&path=" + portraitPath;
            
            document.getElementById('modalIDCard').src = idImg;
            document.getElementById('modalIDLink').href = idImg;
            
            document.getElementById('modalPortrait').src = portraitImg;
            document.getElementById('modalPortraitLink').href = portraitImg;
            
            document.getElementById('kycModal').classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }

        function closeKYCModal() {
            document.getElementById('kycModal').classList.add('hidden');
            document.body.style.overflow = 'auto';
        }
    </script>
</body>
</html>
