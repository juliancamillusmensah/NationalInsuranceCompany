<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null) ? (String)sess.getAttribute("roleId") : null;
    Account currentUser = (sess != null) ? (Account)sess.getAttribute("user") : null;

    if (sess == null || currentUser == null || (!"ROLE_SUPERADMIN".equals(roleId) && !"ROLE_ADMIN".equals(roleId))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String companyId = request.getParameter("companyId");
    if (companyId == null || companyId.isEmpty()) {
        companyId = (String) sess.getAttribute("companyId");
    }

    // Security check: Company Admin can only checkout for their own company
    if ("ROLE_ADMIN".equals(roleId)) {
        String sessionCompanyId = (String) sess.getAttribute("companyId");
        if (companyId == null || !companyId.equals(sessionCompanyId)) {
            response.sendRedirect("Companyadmin.jsp?error=unauthorized");
            return;
        }
    }

    CompanyDAO companyDAO = new CompanyDAO();
    Company company = companyDAO.getCompanyById(companyId);

    if (company == null) {
        response.sendRedirect("auth_redirect.jsp");
        return;
    }

    // Determine Fee
    BigDecimal feeAmount = new BigDecimal("5000.00");
    String entityCategory = company.getCompanyType();
    if (entityCategory != null && entityCategory.toUpperCase().contains("BROKER")) {
        feeAmount = new BigDecimal("1000.00");
    }

    // Calculate new expiry (1 year from today, or 1 year from current expiry if not expired)
    java.time.LocalDate newExpiry = java.time.LocalDate.now().plusYears(1);
    String currentExpiryStr = company.getLicenseExpiry();
    if (currentExpiryStr != null && !currentExpiryStr.isEmpty()) {
        try {
            java.time.LocalDate currentExpiry = java.time.LocalDate.parse(currentExpiryStr);
            if (currentExpiry.isAfter(java.time.LocalDate.now())) {
                newExpiry = currentExpiry.plusYears(1);
            }
        } catch (Exception e) {}
    }

    // Fetch Bank Details (In-lined to bypass Java model limitations)
    String companyBank = "Not Set";
    String companyAccNum = "N/A";
    try (java.sql.Connection conn = com.insurance.util.DBConnection.getConnection();
         java.sql.PreparedStatement pstmt = conn.prepareStatement("SELECT bank_name, account_number FROM insurance_companies WHERE id = ?")) {
        pstmt.setString(1, companyId);
        try (java.sql.ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                companyBank = rs.getString("bank_name");
                companyAccNum = rs.getString("account_number");
                if (companyBank == null || companyBank.isEmpty()) companyBank = "Not Set";
                if (companyAccNum == null || companyAccNum.isEmpty()) companyAccNum = "N/A";
            }
        }
    } catch (Exception e) {}

    // Fetch NIC Settlement Details
    SystemDAO systemDAO = new SystemDAO();
    String nicBank = systemDAO.getSystemSetting("nic_settlement_bank");
    String nicAccName = systemDAO.getSystemSetting("nic_settlement_account");
    String nicAccNum = systemDAO.getSystemSetting("nic_settlement_number");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Regulatory Billing | License Renewal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
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
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(10px); }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
</head>
<body class="bg-background-light text-slate-900 min-h-screen antialiased flex flex-col">
    <jsp:include page="common/header.jsp" />

    <main class="flex-1 p-6 lg:p-12 max-w-5xl mx-auto w-full">
        <div class="mb-10 flex items-center justify-between">
            <div>
                <a href="<%= "ROLE_ADMIN".equals(roleId) ? "Companyadmin.jsp" : "superadmin_companies.jsp" %>" class="inline-flex items-center text-xs font-bold text-slate-400 hover:text-primary transition-colors gap-2 mb-4 group">
                    <span class="material-symbols-outlined text-sm group-hover:-translate-x-1 transition-transform">arrow_back</span>
                    Back to Dashboard
                </a>
                <h1 class="text-4xl font-black text-slate-950 tracking-tight">Regulatory Billing</h1>
                <p class="text-slate-500 font-medium mt-1">Review and settle your institutional license renewal fee.</p>
            </div>
            <div class="hidden md:block">
                <div class="px-5 py-3 bg-white rounded-2xl border border-slate-100 shadow-sm flex items-center gap-3">
                    <div class="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
                    <span class="text-[10px] font-black uppercase tracking-widest text-slate-500">Secure Billing Channel</span>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
            <!-- Invoice Details -->
            <div class="lg:col-span-2 space-y-8">
                <div class="bg-white rounded-[3rem] border border-slate-100 shadow-sm p-8 md:p-12 relative overflow-hidden">
                    <div class="absolute top-0 right-0 p-12 opacity-[0.03] pointer-events-none">
                        <span class="material-symbols-outlined text-[12rem]">account_balance</span>
                    </div>

                    <div class="flex items-center gap-4 mb-10 pb-6 border-b border-slate-50">
                        <div class="p-3 bg-primary/10 text-primary rounded-2xl">
                            <span class="material-symbols-outlined">receipt_long</span>
                        </div>
                        <div>
                            <h3 class="font-black text-slate-950">Billing Summary</h3>
                            <p class="text-xs font-bold text-slate-400">Institutional Renewal Assessment</p>
                        </div>
                    </div>

                    <div class="space-y-8">
                        <div>
                            <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest block mb-1.5">Registered Entity</label>
                            <p class="text-xl font-bold text-slate-900"><%= company.getName() %></p>
                            <div class="flex items-center gap-3 mt-2">
                                <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[9px] font-black uppercase tracking-tighter"><%= company.getCompanyType() %></span>
                                <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[9px] font-black uppercase tracking-tighter">ID: <%= company.getId() %></span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div>
                                <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest block mb-1.5">Current Expiry</label>
                                <div class="flex items-center gap-2 text-slate-700 font-bold">
                                    <span class="material-symbols-outlined text-amber-500 text-sm">event</span>
                                    <%= company.getLicenseExpiry() %>
                                </div>
                            </div>
                            <div>
                                <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest block mb-1.5">Updated Validity</label>
                                <div class="flex items-center gap-2 text-emerald-600 font-bold">
                                    <span class="material-symbols-outlined text-sm">verified</span>
                                    <%= newExpiry %>
                                </div>
                            </div>
                        </div>

                        <div class="pt-8 border-t border-slate-50">
                            <h4 class="text-xs font-black text-slate-950 uppercase tracking-widest mb-6">Fee Breakdown</h4>
                            <div class="space-y-4">
                                <div class="flex justify-between items-center text-sm font-medium">
                                    <span class="text-slate-500">Institutional License Renewal Fee</span>
                                    <span class="text-slate-950 font-bold">GH₵<%= String.format("%,.2f", feeAmount) %></span>
                                </div>
                                <div class="flex justify-between items-center text-sm font-medium">
                                    <span class="text-slate-500">Regulatory Processing Tax</span>
                                    <span class="text-slate-950 font-bold">GH₵0.00</span>
                                </div>
                                <div class="flex justify-between items-center pt-4 mt-4 border-t-2 border-slate-50">
                                    <span class="text-lg font-black text-slate-950 uppercase italic tracking-tighter">Total Payable</span>
                                    <span class="text-3xl font-black text-primary">GH₵<%= String.format("%,.2f", feeAmount) %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Compliance Declaration -->
                <div class="bg-amber-50 rounded-[2rem] border border-amber-100 p-8 flex gap-6">
                    <div class="p-3 bg-amber-200/50 text-amber-700 rounded-2xl self-start">
                        <span class="material-symbols-outlined">gavel</span>
                    </div>
                    <div>
                        <h4 class="font-bold text-amber-900">Regulatory Declaration</h4>
                        <p class="text-sm text-amber-800/80 mt-1 leading-relaxed">
                            By proceeding, you acknowledge that the entity remains in good standing and all quarterly filings have been accurately submitted to the National Insurance Commission.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Checkout Action -->
            <div class="lg:col-span-1">
                <div class="sticky top-12 bg-slate-950 rounded-[3rem] p-8 md:p-10 text-white shadow-2xl shadow-slate-200">
                    <h3 class="text-xl font-black mb-6">Settle Fee</h3>
                    
                    <form action="renew_license_process.jsp" method="POST" class="space-y-6">
                        <input type="hidden" name="companyId" value="<%= company.getId() %>">
                        <input type="hidden" name="licenseExpiry" value="<%= newExpiry %>">
                        
                        <div class="space-y-4 mb-6">
                            <div class="p-4 bg-white/5 rounded-2xl border border-white/10 flex items-center gap-3">
                                <div class="h-10 w-10 bg-[#0AA699]/20 rounded-xl flex items-center justify-center shrink-0">
                                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M12 2L2 7l10 5 10-5-10-5z" fill="#0AA699"/>
                                        <path d="M2 17l10 5 10-5M2 12l10 5 10-5" stroke="#0AA699" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <p class="text-sm font-bold text-white">Paystack</p>
                                    <p class="text-[10px] text-white/50 font-medium">Card, Mobile Money & Bank Transfer</p>
                                </div>
                            </div>
                            <p class="text-[10px] text-white/40 font-bold text-center uppercase tracking-widest">Secure Redirect to Paystack</p>
                        </div>
                        
                        <button type="submit" class="w-full py-5 bg-primary hover:bg-primary-dark rounded-2xl text-sm font-black uppercase tracking-widest shadow-xl shadow-primary/20 transition-all flex items-center justify-center gap-3">
                            Pay Fee with Paystack
                            <span class="material-symbols-outlined text-sm">arrow_forward</span>
                        </button>
                    </form>

                    <div class="mt-8 pt-8 border-t border-white/10 flex flex-col items-center gap-4">
                        <div class="flex items-center gap-1.5">
                            <span class="material-symbols-outlined text-emerald-400 text-xs">shield_lock</span>
                            <span class="text-[9px] font-black uppercase opacity-60">Secured by NIC Protocol-V3</span>
                        </div>
                        <img src="https://lh3.googleusercontent.com/aida-public/ALi77S85S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5S5" alt="Bank Logos" class="h-4 grayscale invert opacity-50" onerror="this.style.display='none'">
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="common/footer.jsp" />
</body>
</html>
