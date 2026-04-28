<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.insurance.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
    // ─── Real-Time Query ───────────────────────────────────────────────
    String query      = request.getParameter("plate");
    String errorMsg   = null;

    // Result fields
    String resInsuredItem   = null;
    String resPolicyName    = null;
    String resPolicyType    = null;
    String resPolicyStatus  = null;
    String resStartDate     = null;
    String resEndDate       = null;
    String resInsurerName   = null;
    String resHolderName    = null;
    String resCoverageDur   = null;
    boolean searched        = (query != null && !query.trim().isEmpty());

    if (searched) {
        String cleanQuery = query.trim().toUpperCase();
        // Search customer_policies by insured_item (vehicle reg), join policy + insurer + account
        String sql = "SELECT cp.insured_item, cp.policy_status, cp.start_date, cp.end_date, " +
                     "p.policy_name, p.policy_type, p.coverage_duration, " +
                     "a.full_name AS holder_name, " +
                     "ic.company_name AS insurer_name " +
                     "FROM customer_policies cp " +
                     "JOIN policies p ON cp.policy_id = p.id " +
                     "JOIN Account a ON cp.user_id = a.id " +
                     "LEFT JOIN insurance_companies ic ON p.insurance_company_id = ic.id " +
                     "WHERE UPPER(cp.insured_item) LIKE ? " +
                     "AND (LOWER(p.policy_type) LIKE '%auto%' " +
                     "  OR LOWER(p.policy_type) LIKE '%motor%' " +
                     "  OR LOWER(p.policy_name) LIKE '%motor%' " +
                     "  OR LOWER(p.policy_name) LIKE '%auto%' " +
                     "  OR LOWER(p.policy_name) LIKE '%vehicle%') " +
                     "ORDER BY CASE cp.policy_status WHEN 'active' THEN 1 ELSE 2 END, cp.end_date DESC " +
                     "LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + cleanQuery + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    resInsuredItem  = rs.getString("insured_item");
                    resPolicyName   = rs.getString("policy_name");
                    resPolicyType   = rs.getString("policy_type");
                    resPolicyStatus = rs.getString("policy_status");
                    resStartDate    = rs.getString("start_date");
                    resEndDate      = rs.getString("end_date");
                    resCoverageDur  = rs.getString("coverage_duration");
                    resHolderName   = rs.getString("holder_name");
                    resInsurerName  = rs.getString("insurer_name");
                    // Trim dates to 10 chars
                    if (resStartDate != null && resStartDate.length() > 10) resStartDate = resStartDate.substring(0, 10);
                    if (resEndDate   != null && resEndDate.length()   > 10) resEndDate   = resEndDate.substring(0, 10);
                }
            }
        } catch (Exception e) {
            errorMsg = "Database error: " + e.getMessage();
        }
    }

    boolean found   = (resInsuredItem != null);
    boolean active  = found && "active".equalsIgnoreCase(resPolicyStatus);
    boolean expired = found && "expired".equalsIgnoreCase(resPolicyStatus);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Motor Insurance Verification | NIC Ghana</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f6f6f8" },
                    fontFamily: { "display": ["Inter","sans-serif"] }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24; vertical-align:middle; }
        @keyframes pulse-ring {
            0%   { box-shadow: 0 0 0 0 rgba(16,185,129,0.4); }
            70%  { box-shadow: 0 0 0 12px rgba(16,185,129,0); }
            100% { box-shadow: 0 0 0 0 rgba(16,185,129,0); }
        }
        .pulse-green { animation: pulse-ring 2s infinite; }
        @keyframes pulse-red {
            0%   { box-shadow: 0 0 0 0 rgba(239,68,68,0.4); }
            70%  { box-shadow: 0 0 0 12px rgba(239,68,68,0); }
            100% { box-shadow: 0 0 0 0 rgba(239,68,68,0); }
        }
        .pulse-red { animation: pulse-red 2s infinite; }
        @keyframes fadeSlideUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .result-card { animation: fadeSlideUp 0.4s ease; }
        .plate-char { letter-spacing: 0.2em; }
    </style>
</head>
<body class="bg-background-light min-h-screen">

    <%-- Header --%>
    <jsp:include page="common/public_header.jsp" />

    <main class="max-w-3xl mx-auto px-4 py-12 lg:py-20 space-y-10">

        <%-- Page Title --%>
        <div class="text-center space-y-3">
            <div class="inline-flex items-center justify-center h-16 w-16 bg-emerald-100 rounded-[1.5rem] mb-2">
                <span class="material-symbols-outlined text-emerald-600 text-3xl">directions_car</span>
            </div>
            <h1 class="text-3xl lg:text-4xl font-black text-slate-950 tracking-tight">
                Motor Insurance Verification
            </h1>
            <p class="text-slate-500 font-medium max-w-lg mx-auto text-sm lg:text-base">
                Enter a vehicle registration number to instantly verify if it has valid motor insurance coverage registered with the NIC Motor Insurance Database.
            </p>
        </div>

        <%-- Search Form --%>
        <form method="GET" action="nic_motor_verify.jsp" class="bg-white rounded-[2.5rem] border border-slate-100 shadow-xl p-6 lg:p-8">
            <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest block mb-3">
                Vehicle Registration Number / Insured Item
            </label>
            <div class="flex gap-3">
                <div class="flex-1 relative">
                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">pin</span>
                    <input
                        id="plateInput"
                        type="text"
                        name="plate"
                        value="<%= query != null ? query.replace("\"","&quot;") : "" %>"
                        placeholder="e.g. GR-1234-21 or Toyota Corolla"
                        maxlength="60"
                        autocomplete="off"
                        class="w-full pl-11 pr-4 py-4 lg:py-5 bg-slate-50 border-none rounded-2xl text-sm font-bold text-slate-900 placeholder-slate-400 focus:ring-4 focus:ring-primary/10 transition-all uppercase"
                        oninput="this.value=this.value.toUpperCase()"
                    />
                </div>
                <button type="submit"
                    class="px-6 lg:px-8 py-4 lg:py-5 bg-primary text-white rounded-2xl font-black text-sm shadow-lg shadow-primary/20 hover:bg-primary/90 hover:scale-[1.02] active:scale-95 transition-all flex items-center gap-2 whitespace-nowrap">
                    <span class="material-symbols-outlined text-sm">search</span>
                    <span class="hidden sm:inline">Verify Now</span>
                </button>
            </div>
            <p class="text-[10px] text-slate-400 font-medium mt-3 px-1">
                <span class="material-symbols-outlined text-[12px]">lock</span>
                This is a read-only query. No personal data is stored from this search.
            </p>
        </form>

        <%-- Error --%>
        <% if (errorMsg != null) { %>
        <div class="bg-red-50 border border-red-200 text-red-800 rounded-2xl px-6 py-4 flex items-center gap-3">
            <span class="material-symbols-outlined text-red-500">error</span>
            <p class="text-sm font-bold"><%= errorMsg %></p>
        </div>
        <% } %>

        <%-- Results --%>
        <% if (searched && errorMsg == null) { %>
        <div class="result-card">

            <% if (!found) { %>
            <%-- NOT FOUND --%>
            <div class="bg-white rounded-[2.5rem] border border-red-100 shadow-xl overflow-hidden">
                <div class="bg-red-50 p-8 flex items-center gap-5 border-b border-red-100">
                    <div class="h-14 w-14 bg-red-100 rounded-2xl flex items-center justify-center pulse-red shrink-0">
                        <span class="material-symbols-outlined text-red-600 text-2xl">gpp_bad</span>
                    </div>
                    <div>
                        <p class="text-[10px] font-black text-red-500 uppercase tracking-widest mb-1">Verification Result</p>
                        <h2 class="text-2xl font-black text-slate-950">Not Found</h2>
                    </div>
                </div>
                <div class="p-8 space-y-5">
                    <div class="bg-red-50 rounded-2xl p-5 border border-red-100">
                        <p class="font-black text-slate-900 mb-1">No Active Motor Insurance Found</p>
                        <p class="text-sm text-slate-600">
                            The vehicle "<span class="font-bold text-red-700"><%= query.trim().toUpperCase() %></span>"
                            is not found in the NIC Motor Insurance Database. This may mean:
                        </p>
                        <ul class="mt-3 space-y-1.5 text-sm text-slate-600">
                            <li class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">chevron_right</span>The vehicle has no registered motor insurance</li>
                            <li class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">chevron_right</span>The registration number was entered incorrectly</li>
                            <li class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">chevron_right</span>The policy was not registered through NIC-licensed channels</li>
                        </ul>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-3">
                        <a href="nic_acts_regulations.jsp"
                           class="flex-1 flex items-center justify-center gap-2 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">
                            <span class="material-symbols-outlined text-sm">arrow_back</span> Back to Regulations
                        </a>
                        <a href="mailto:info@nic.gov.gh?subject=Motor%20Insurance%20Query&body=Vehicle%20Registration%3A%20<%= query.trim().toUpperCase() %>"
                           class="flex-1 flex items-center justify-center gap-2 py-4 bg-red-600 text-white rounded-2xl text-sm font-black hover:bg-red-700 shadow-lg shadow-red-200 transition-all">
                            <span class="material-symbols-outlined text-sm">mail</span> Report to NIC
                        </a>
                    </div>
                </div>
            </div>

            <% } else if (active) { %>
            <%-- ACTIVE / VERIFIED --%>
            <div class="bg-white rounded-[2.5rem] border border-emerald-100 shadow-xl overflow-hidden">
                <div class="bg-emerald-50 p-8 flex items-center gap-5 border-b border-emerald-100">
                    <div class="h-14 w-14 bg-emerald-100 rounded-2xl flex items-center justify-center pulse-green shrink-0">
                        <span class="material-symbols-outlined text-emerald-600 text-2xl">verified</span>
                    </div>
                    <div>
                        <p class="text-[10px] font-black text-emerald-600 uppercase tracking-widest mb-1">Verification Result</p>
                        <h2 class="text-2xl font-black text-slate-950">Insurance Verified ✓</h2>
                        <p class="text-sm text-emerald-700 font-medium mt-0.5">This vehicle has active, valid motor insurance coverage.</p>
                    </div>
                </div>
                <div class="p-8 space-y-6">
                    <%-- Plate Badge --%>
                    <div class="bg-slate-900 rounded-2xl p-5 flex items-center justify-between">
                        <div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Registered Vehicle / Item</p>
                            <p class="text-xl font-black text-white plate-char"><%= resInsuredItem %></p>
                        </div>
                        <div class="h-10 w-10 bg-emerald-500 rounded-full flex items-center justify-center">
                            <span class="material-symbols-outlined text-white text-lg">check</span>
                        </div>
                    </div>

                    <%-- Details Grid --%>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Policy</p>
                            <p class="font-black text-slate-900 text-sm"><%= resPolicyName != null ? resPolicyName : "N/A" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Type</p>
                            <p class="font-black text-slate-900 text-sm"><%= resPolicyType != null ? resPolicyType : "Motor" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Coverage Start</p>
                            <p class="font-black text-slate-900 text-sm"><%= resStartDate != null ? resStartDate : "—" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Coverage Expires</p>
                            <p class="font-black text-emerald-700 text-sm"><%= resEndDate != null ? resEndDate : "—" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Insurer</p>
                            <p class="font-black text-slate-900 text-sm"><%= resInsurerName != null ? resInsurerName : "NIC-Licensed Insurer" %></p>
                        </div>
                        <div class="bg-emerald-50 rounded-2xl p-4 border border-emerald-100">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Status</p>
                            <p class="font-black text-emerald-700 text-sm flex items-center gap-1">
                                <span class="h-2 w-2 bg-emerald-500 rounded-full inline-block"></span> Active &amp; Valid
                            </p>
                        </div>
                    </div>

                    <div class="bg-emerald-50 border border-emerald-100 rounded-2xl p-5 flex gap-3">
                        <span class="material-symbols-outlined text-emerald-500 shrink-0 mt-0.5">shield</span>
                        <p class="text-xs text-emerald-800 leading-relaxed">
                            This vehicle's insurance has been verified against the NIC Motor Insurance Database.
                            Data was retrieved in real-time as of <strong><%= new java.util.Date() %></strong>.
                        </p>
                    </div>
                    <a href="nic_motor_verify.jsp" class="flex items-center justify-center gap-2 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all w-full">
                        <span class="material-symbols-outlined text-sm">refresh</span> Verify Another Vehicle
                    </a>
                </div>
            </div>

            <% } else { %>
            <%-- FOUND BUT EXPIRED / CANCELLED --%>
            <div class="bg-white rounded-[2.5rem] border border-amber-100 shadow-xl overflow-hidden">
                <div class="bg-amber-50 p-8 flex items-center gap-5 border-b border-amber-100">
                    <div class="h-14 w-14 bg-amber-100 rounded-2xl flex items-center justify-center shrink-0">
                        <span class="material-symbols-outlined text-amber-600 text-2xl">gpp_maybe</span>
                    </div>
                    <div>
                        <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-1">Verification Result</p>
                        <h2 class="text-2xl font-black text-slate-950">Coverage <%= resPolicyStatus != null ? resPolicyStatus.substring(0,1).toUpperCase() + resPolicyStatus.substring(1) : "Inactive" %></h2>
                        <p class="text-sm text-amber-700 font-medium mt-0.5">This vehicle's policy is no longer active.</p>
                    </div>
                </div>
                <div class="p-8 space-y-6">
                    <div class="bg-slate-900 rounded-2xl p-5 flex items-center justify-between">
                        <div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Registered Vehicle / Item</p>
                            <p class="text-xl font-black text-white plate-char"><%= resInsuredItem %></p>
                        </div>
                        <div class="h-10 w-10 bg-amber-500 rounded-full flex items-center justify-center">
                            <span class="material-symbols-outlined text-white text-lg">warning</span>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Policy</p>
                            <p class="font-black text-slate-900 text-sm"><%= resPolicyName != null ? resPolicyName : "N/A" %></p>
                        </div>
                        <div class="bg-amber-50 rounded-2xl p-4 border border-amber-100">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Status</p>
                            <p class="font-black text-amber-700 text-sm"><%= resPolicyStatus != null ? resPolicyStatus.toUpperCase() : "INACTIVE" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Last Start Date</p>
                            <p class="font-black text-slate-900 text-sm"><%= resStartDate != null ? resStartDate : "—" %></p>
                        </div>
                        <div class="bg-red-50 rounded-2xl p-4 border border-red-100">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Expired On</p>
                            <p class="font-black text-red-700 text-sm"><%= resEndDate != null ? resEndDate : "—" %></p>
                        </div>
                        <div class="bg-slate-50 rounded-2xl p-4 col-span-2">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Last Known Insurer</p>
                            <p class="font-black text-slate-900 text-sm"><%= resInsurerName != null ? resInsurerName : "NIC-Licensed Insurer" %></p>
                        </div>
                    </div>
                    <div class="bg-amber-50 border border-amber-100 rounded-2xl p-5 flex gap-3">
                        <span class="material-symbols-outlined text-amber-500 shrink-0 mt-0.5">warning</span>
                        <p class="text-xs text-amber-800 leading-relaxed">
                            This vehicle's insurance has <strong>lapsed or been cancelled</strong>. Operating a vehicle without valid insurance is illegal under Ghana's Motor Traffic and Transport Act. Please renew coverage immediately.
                        </p>
                    </div>
                    <a href="nic_motor_verify.jsp" class="flex items-center justify-center gap-2 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all w-full">
                        <span class="material-symbols-outlined text-sm">refresh</span> Verify Another Vehicle
                    </a>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>

        <%-- How it Works (shown only when not searching) --%>
        <% if (!searched) { %>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <div class="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-6 text-center space-y-3">
                <div class="h-12 w-12 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto">
                    <span class="material-symbols-outlined text-primary">pin</span>
                </div>
                <p class="font-black text-slate-900 text-sm">Enter Plate / Item</p>
                <p class="text-xs text-slate-500">Type the vehicle registration number or insured item name above.</p>
            </div>
            <div class="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-6 text-center space-y-3">
                <div class="h-12 w-12 bg-primary/10 rounded-2xl flex items-center justify-center mx-auto">
                    <span class="material-symbols-outlined text-primary">database</span>
                </div>
                <p class="font-black text-slate-900 text-sm">Live Database Query</p>
                <p class="text-xs text-slate-500">We query the NIC Motor Insurance Database in real time.</p>
            </div>
            <div class="bg-white rounded-[2rem] border border-slate-100 shadow-sm p-6 text-center space-y-3">
                <div class="h-12 w-12 bg-emerald-100 rounded-2xl flex items-center justify-center mx-auto">
                    <span class="material-symbols-outlined text-emerald-600">verified</span>
                </div>
                <p class="font-black text-slate-900 text-sm">Instant Result</p>
                <p class="text-xs text-slate-500">See the policy status, insurer, and coverage dates instantly.</p>
            </div>
        </div>
        <% } %>

        <div class="text-center">
            <a href="nic_acts_regulations.jsp" class="inline-flex items-center gap-2 text-sm font-bold text-slate-400 hover:text-primary transition-colors">
                <span class="material-symbols-outlined text-sm">arrow_back</span> Back to Acts &amp; Regulations
            </a>
        </div>
    </main>

    <jsp:include page="common/public_footer.jsp" />
</body>
</html>
