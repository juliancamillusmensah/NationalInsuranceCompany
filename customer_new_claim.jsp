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
    Account user = (Account) sess.getAttribute("user");
    PolicyDAO policyDAO = new PolicyDAO();
    List<Policy> myPolicies = policyDAO.getCustomerPolicies(userId);
    
    // Filter for Active policies only
    List<Policy> activePolicies = new ArrayList<>();
    for(Policy p : myPolicies) {
        if("Active".equalsIgnoreCase(p.getStatus())) {
            activePolicies.add(p);
        }
    }

    NotificationDAO noteDAO = new NotificationDAO();
    request.setAttribute("notifications", noteDAO.getNotificationsByUserId(userId));
    request.setAttribute("unreadNotifications", noteDAO.getUnreadCount(userId));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>File a New Claim - NIC Insurance</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        "primary": "#1152d4",
                        "background-light": "#f8fafc",
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
</head>
<body class="bg-background-light min-h-screen text-slate-900">
    <div class="flex flex-col lg:flex-row min-h-screen">
        <!-- Sidebar Navigation -->
        <jsp:include page="common/sidebar.jsp" />

        <div class="flex-1 flex flex-col min-h-screen">
            <!-- Header -->
            <jsp:include page="common/header.jsp" />

            <main class="flex-1 p-8 lg:p-12">
                <div class="mb-12">
                    <h1 class="text-sm font-black text-slate-400 uppercase tracking-[0.2em] mb-2">Customer Dashboard</h1>
                    <h2 class="text-3xl font-black text-slate-950">Claim Notification</h2>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                    <!-- Form Section -->
                    <div class="lg:col-span-8 space-y-12">
                        <div class="bg-white rounded-[3rem] border border-slate-100 shadow-sm overflow-hidden">
                            <div class="p-10 border-b border-slate-50">
                                <h3 class="text-2xl font-black text-slate-950">Claim Invitation</h3>
                                <p class="text-slate-500 font-bold text-sm mt-3 leading-relaxed">Submit your claim details. NIC guidelines require claims to be acknowledged within 2 working days.</p>
                            </div>

                            <form action="SubmitClaimServlet" method="post" enctype="multipart/form-data" class="p-10 space-y-8">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                    <div class="space-y-3">
                                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Select Policy</label>
                                        <div class="relative">
                                            <select name="policyId" required class="w-full bg-slate-50 border-none rounded-2xl p-5 text-sm font-black focus:ring-4 focus:ring-primary/10 transition-all appearance-none">
                                                <option value="" disabled selected>Select from active policies</option>
                                                <% if (activePolicies.isEmpty()) { %>
                                                    <option value="" disabled>No active policies found</option>
                                                <% } else { %>
                                                    <% for (Policy p : activePolicies) { %>
                                                        <option value="<%= p.getId() %>"><%= p.getPolicyName() %></option>
                                                    <% } %>
                                                <% } %>
                                            </select>
                                            <span class="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 pointer-events-none">expand_more</span>
                                        </div>
                                    </div>

                                    <div class="space-y-3">
                                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Incident Date</label>
                                        <input type="date" name="incidentDate" required class="w-full bg-slate-50 border-none rounded-2xl p-5 text-sm font-black focus:ring-4 focus:ring-primary/10 transition-all">
                                    </div>
                                </div>

                                <div class="space-y-3">
                                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Estimated Claim Amount (GHS)</label>
                                    <div class="relative">
                                        <input type="number" step="0.01" name="claimAmount" required placeholder="0.00" class="w-full bg-slate-50 border-none rounded-2xl p-5 text-sm font-black focus:ring-4 focus:ring-primary/10 transition-all placeholder:text-slate-300">
                                        <span class="absolute right-5 top-1/2 -translate-y-1/2 text-[10px] font-black text-slate-300 uppercase">GH&#8373;</span>
                                    </div>
                                </div>

                                <div class="space-y-3">
                                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Description of Incident</label>
                                    <textarea name="description" rows="5" required placeholder="Provide a detailed account of what happened..." class="w-full bg-slate-50 border-none rounded-3xl p-6 text-sm font-black focus:ring-4 focus:ring-primary/10 transition-all placeholder:text-slate-300"></textarea>
                                </div>

                                <div class="space-y-3 pt-4 border-t border-slate-100">
                                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 flex items-center gap-2">
                                        <span class="material-symbols-outlined text-sm">upload_file</span> Supporting Evidence (Optional)
                                    </label>
                                    <div class="relative group">
                                        <input type="file" name="evidence" accept=".pdf,.png,.jpg,.jpeg,.doc,.docx" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10" onchange="document.getElementById('fileName').innerText = this.files[0] ? this.files[0].name : 'Browse files or drag & drop'">
                                        <div class="w-full bg-slate-50 border-2 border-dashed border-slate-200 group-hover:border-primary/50 group-hover:bg-primary/5 rounded-3xl p-8 flex flex-col items-center justify-center transition-all text-center">
                                            <span class="material-symbols-outlined text-4xl text-slate-300 group-hover:text-primary mb-3 transition-colors">cloud_upload</span>
                                            <p id="fileName" class="text-sm font-bold text-slate-900">Browse files or drag & drop</p>
                                            <p class="text-[10px] font-bold text-slate-400 uppercase mt-2">Max limit: 10MB</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="pt-6">
                                    <button type="submit" <%= activePolicies.isEmpty() ? "disabled" : "" %> class="w-full py-5 bg-primary text-white rounded-2xl text-sm font-black hover:bg-primary/90 shadow-2xl shadow-primary/30 transition-all disabled:opacity-50 disabled:cursor-not-allowed transform hover:-translate-y-1 active:translate-y-0">
                                        Submit Notification to Insurer
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Regulatory Notice -->
                        <div class="bg-indigo-50/50 rounded-[2.5rem] p-8 flex gap-6">
                            <div class="bg-indigo-100 p-3 rounded-2xl h-fit">
                                <span class="material-symbols-outlined text-indigo-600">info</span>
                            </div>
                            <div class="space-y-2">
                                <p class="text-sm font-black text-indigo-900">Your Rights as a Policyholder</p>
                                <p class="text-xs text-indigo-800 leading-relaxed font-bold opacity-80">
                                    Under NIC guidelines, insurers must acknowledge your claim within 48 hours. If you do not receive a response, you are entitled to escalate the matter directly to the National Insurance Commission.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar Assets -->
                    <div class="lg:col-span-4 space-y-10">
                        <!-- Checklist Card -->
                        <div class="bg-white p-10 rounded-[3rem] border border-slate-100 shadow-sm space-y-8">
                            <h4 class="text-[11px] font-black text-slate-950 uppercase tracking-[0.2em]">Required Documents</h4>
                            <ul class="space-y-6">
                                <li class="flex items-center gap-4 group">
                                    <div class="w-6 h-6 rounded-full border-2 border-primary flex items-center justify-center bg-primary text-white shadow-lg shadow-primary/20">
                                        <span class="material-symbols-outlined text-sm font-black">check</span>
                                    </div>
                                    <span class="text-xs font-black text-slate-800">Completed Claim Form</span>
                                </li>
                                <li class="flex items-center gap-4 group text-slate-400">
                                    <div class="w-6 h-6 rounded-full border-2 border-primary flex items-center justify-center bg-primary text-white shadow-lg shadow-primary/20">
                                        <span class="material-symbols-outlined text-sm font-black">check</span>
                                    </div>
                                    <span class="text-xs font-black text-slate-800">Police Report (for Motor/Theft)</span>
                                </li>
                                <li class="flex items-center gap-4 group">
                                    <div class="w-6 h-6 rounded-full border-2 border-slate-200 flex items-center justify-center transition-colors group-hover:border-primary"></div>
                                    <span class="text-xs font-black text-slate-500">Medical Report (for Personal)</span>
                                </li>
                                <li class="flex items-center gap-4 group">
                                    <div class="w-6 h-6 rounded-full border-2 border-slate-200 flex items-center justify-center transition-colors group-hover:border-primary"></div>
                                    <span class="text-xs font-black text-slate-500">Repair Estimates or Valuation</span>
                                </li>
                            </ul>
                            <p class="text-[10px] text-slate-300 font-bold italic pt-6 border-t border-slate-50">
                                * Submit all available documents within 30 days of the incident for faster processing.
                            </p>
                        </div>

                        <!-- SLA Card -->
                        <div class="bg-primary p-10 rounded-[3rem] text-white shadow-2xl shadow-primary/40 space-y-8">
                            <h4 class="text-[11px] font-black uppercase tracking-[0.2em] opacity-60">SLA Guarantees</h4>
                            <div class="space-y-6">
                                <div class="flex justify-between items-end border-b border-white/10 pb-4">
                                    <div>
                                        <p class="text-[9px] font-black uppercase opacity-60 mb-1">Acknowledgment</p>
                                        <p class="text-lg font-black">2 Working Days</p>
                                    </div>
                                    <span class="material-symbols-outlined opacity-40">mms</span>
                                </div>
                                <div class="flex justify-between items-end border-b border-white/10 pb-4">
                                    <div>
                                        <p class="text-[9px] font-black uppercase opacity-60 mb-1">Settlement Stage</p>
                                        <p class="text-lg font-black">4 Weeks Max</p>
                                    </div>
                                    <span class="material-symbols-outlined opacity-40">flag</span>
                                </div>
                                <div class="flex justify-between items-end">
                                    <div>
                                        <p class="text-[9px] font-black uppercase opacity-60 mb-1">Payment Process</p>
                                        <p class="text-lg font-black">48 Hours</p>
                                    </div>
                                    <span class="material-symbols-outlined opacity-40">bolt</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            
            <jsp:include page="common/footer.jsp" />
        </div>
    </div>
</body>
</html>
