<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.insurance.util.DBConnection" %>
<%@ page import="com.insurance.dao.PublicationDAO" %>
<%@ page import="com.insurance.model.Publication" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // ═══════════════════════════════════════════════
    // REAL-TIME STATS: Company counts by type
    // ═══════════════════════════════════════════════
    int countNonLife = 0, countLife = 0, countReinsurer = 0, countBroker = 0, countTotal = 0;
    int totalPolicies = 0, activePolicies = 0, totalCustomers = 0;

    // Market share leaders
    String nonLifeLeader = "—", lifeLeader = "—";
    double nonLifePct = 0, lifePct = 0;
    int nonLifeLeaderPolicies = 0, lifeLeaderPolicies = 0;

    // Top companies list for market share bar
    List<String> topNonLifeNames  = new ArrayList<>();
    List<Integer> topNonLifeCounts = new ArrayList<>();
    List<String> topLifeNames     = new ArrayList<>();
    List<Integer> topLifeCounts   = new ArrayList<>();
    List<Publication> performanceReports = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {

        // ── Company counts by type ──────────────────
        String typeSql = "SELECT company_type, COUNT(*) as cnt FROM insurance_companies GROUP BY company_type";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(typeSql)) {
            while (rs.next()) {
                String t = rs.getString("company_type");
                int c = rs.getInt("cnt");
                countTotal += c;
                if (t == null) continue;
                String tl = t.toLowerCase();
                if      (tl.contains("non-life") || tl.contains("nonlife") || tl.contains("general")) countNonLife += c;
                else if (tl.contains("life"))       countLife += c;
                else if (tl.contains("reinsur"))    countReinsurer += c;
                else if (tl.contains("broker"))     countBroker += c;
            }
        }

        // ── Total & Active Policies ─────────────────
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM customer_policies")) {
            if (rs.next()) totalPolicies = rs.getInt(1);
        }
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM customer_policies WHERE policy_status='active'")) {
            if (rs.next()) activePolicies = rs.getInt(1);
        }
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Account WHERE role='customer'")) {
            if (rs.next()) totalCustomers = rs.getInt(1);
        }

        // ── Market Share: Top Non-Life by policy count ──
        String nonLifeSql =
            "SELECT ic.company_name, COUNT(cp.id) AS cnt " +
            "FROM insurance_companies ic " +
            "JOIN policies p ON p.insurance_company_id = ic.id " +
            "JOIN customer_policies cp ON cp.policy_id = p.id " +
            "WHERE LOWER(ic.company_type) NOT LIKE '%life%' " +
            "  AND LOWER(ic.company_type) NOT LIKE '%broker%' " +
            "  AND LOWER(ic.company_type) NOT LIKE '%reinsur%' " +
            "GROUP BY ic.id ORDER BY cnt DESC LIMIT 5";
        int nonLifeTotal = 0;
        List<Integer> nonLifeRaw = new ArrayList<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(nonLifeSql)) {
            while (rs.next()) {
                topNonLifeNames.add(rs.getString("company_name"));
                int c = rs.getInt("cnt");
                topNonLifeCounts.add(c);
                nonLifeRaw.add(c);
                nonLifeTotal += c;
            }
        }
        if (!topNonLifeNames.isEmpty()) {
            nonLifeLeader = topNonLifeNames.get(0);
            nonLifeLeaderPolicies = topNonLifeCounts.get(0);
            nonLifePct = (nonLifeTotal > 0) ? (nonLifeLeaderPolicies * 100.0 / nonLifeTotal) : 0;
        }

        // ── Market Share: Top Life by policy count ──
        String lifeSql =
            "SELECT ic.company_name, COUNT(cp.id) AS cnt " +
            "FROM insurance_companies ic " +
            "JOIN policies p ON p.insurance_company_id = ic.id " +
            "JOIN customer_policies cp ON cp.policy_id = p.id " +
            "WHERE LOWER(ic.company_type) LIKE '%life%' " +
            "GROUP BY ic.id ORDER BY cnt DESC LIMIT 5";
        int lifeTotal = 0;
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(lifeSql)) {
            while (rs.next()) {
                topLifeNames.add(rs.getString("company_name"));
                int c = rs.getInt("cnt");
                topLifeCounts.add(c);
                lifeTotal += c;
            }
        }
        if (!topLifeNames.isEmpty()) {
            lifeLeader = topLifeNames.get(0);
            lifeLeaderPolicies = topLifeCounts.get(0);
            lifePct = (lifeTotal > 0) ? (lifeLeaderPolicies * 100.0 / lifeTotal) : 0;
        }

    // Fetch Performance Reports
    PublicationDAO pubDAO = new PublicationDAO();
    performanceReports = pubDAO.getPublicationsByCategory("Quarterly Market Report");
    performanceReports.addAll(pubDAO.getPublicationsByCategory("Annual Report"));
    // Sort by year desc
    performanceReports.sort((p1, p2) -> {
        String y1 = p1.getYear() != null ? p1.getYear() : "0";
        String y2 = p2.getYear() != null ? p2.getYear() : "0";
        return y2.compareTo(y1);
    });

    } catch (Exception e) {
        // fail silently — stats default to 0
    }

    // Format percentages
    String nonLifePctStr = String.format("%.1f", nonLifePct);
    String lifePctStr    = String.format("%.1f", lifePct);
    int nonLifeBarWidth  = (int) Math.min(nonLifePct, 100);
    int lifeBarWidth     = (int) Math.min(lifePct, 100);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Industry Data | NIC Ghana</title>
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
                    fontFamily: { "display": ["Inter","sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        @keyframes countUp { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }
        .stat-num { animation: countUp 0.6s ease both; }
        .bar-fill  { transition: width 1.2s cubic-bezier(.4,0,.2,1); }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
<div class="relative flex min-h-screen flex-col">
    <jsp:include page="common/public_header.jsp" />

    <main class="flex-grow">

        <!-- Hero -->
        <section class="bg-white dark:bg-slate-900 pt-16 pb-24">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="max-w-3xl">
                    <div class="inline-flex items-center gap-2 bg-emerald-100 text-emerald-700 text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-full mb-4">
                        <span class="h-1.5 w-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                        Live Data — Updated in Real Time
                    </div>
                    <h1 class="text-4xl font-black tracking-tight text-primary sm:text-6xl">
                        Industry <span class="italic text-slate-900 dark:text-white">Data.</span>
                    </h1>
                    <p class="mt-6 text-xl text-slate-600 dark:text-slate-400 leading-relaxed">
                        Transparency through data. Market statistics, registered entity distributions,
                        and quarterly performance reports from the Ghana insurance sector — pulled live from the NIC database.
                    </p>
                </div>
            </div>
        </section>

        <!-- Stats & Data -->
        <section class="py-24">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">

                <!-- ── Insurer Type Counts ─────────────────────── -->
                <div class="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="p-8 rounded-3xl bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 text-center">
                        <p class="text-5xl font-black text-primary stat-num"><%= countNonLife %></p>
                        <p class="mt-2 text-sm font-bold text-slate-500 uppercase tracking-widest">Non-Life Insurers</p>
                    </div>
                    <div class="p-8 rounded-3xl bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 text-center">
                        <p class="text-5xl font-black text-emerald-500 stat-num"><%= countLife %></p>
                        <p class="mt-2 text-sm font-bold text-slate-500 uppercase tracking-widest">Life Insurers</p>
                    </div>
                    <div class="p-8 rounded-3xl bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 text-center">
                        <p class="text-5xl font-black text-indigo-500 stat-num"><%= countReinsurer %></p>
                        <p class="mt-2 text-sm font-bold text-slate-500 uppercase tracking-widest">Reinsurers</p>
                    </div>
                    <div class="p-8 rounded-3xl bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 text-center">
                        <p class="text-5xl font-black text-amber-500 stat-num"><%= countBroker > 0 ? countBroker : countTotal - countNonLife - countLife - countReinsurer %></p>
                        <p class="mt-2 text-sm font-bold text-slate-500 uppercase tracking-widest">Insurance Brokers</p>
                    </div>
                </div>

                <!-- ── Operational Stats ──────────────────────── -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-20">
                    <div class="p-6 rounded-2xl bg-primary/5 border border-primary/10 flex items-center gap-4">
                        <div class="h-12 w-12 bg-primary/10 rounded-2xl flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-primary">policy</span>
                        </div>
                        <div>
                            <p class="text-2xl font-black text-primary"><%= totalPolicies %></p>
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-widest mt-0.5">Total Policies Issued</p>
                        </div>
                    </div>
                    <div class="p-6 rounded-2xl bg-emerald-50 border border-emerald-100 flex items-center gap-4">
                        <div class="h-12 w-12 bg-emerald-100 rounded-2xl flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-emerald-600">verified</span>
                        </div>
                        <div>
                            <p class="text-2xl font-black text-emerald-700"><%= activePolicies %></p>
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-widest mt-0.5">Active Policies</p>
                        </div>
                    </div>
                    <div class="p-6 rounded-2xl bg-amber-50 border border-amber-100 flex items-center gap-4">
                        <div class="h-12 w-12 bg-amber-100 rounded-2xl flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-amber-600">group</span>
                        </div>
                        <div>
                            <p class="text-2xl font-black text-amber-700"><%= totalCustomers %></p>
                            <p class="text-xs font-bold text-slate-500 uppercase tracking-widest mt-0.5">Registered Customers</p>
                        </div>
                    </div>
                </div>

                <!-- ── Bottom Grid: Reports + Market Share ─────── -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">

                    <!-- Performance Reports -->
                    <div class="lg:col-span-2 space-y-8">
                        <h2 class="text-3xl font-black">Performance Reports</h2>
                        <div class="overflow-hidden rounded-[2rem] border border-slate-200 dark:border-slate-800">
                            <table class="w-full text-left bg-white dark:bg-slate-900">
                                <thead>
                                    <tr class="border-b border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/50">
                                        <th class="px-6 py-4 text-xs font-black text-slate-500 uppercase">Period</th>
                                        <th class="px-6 py-4 text-xs font-black text-slate-500 uppercase">Report Name</th>
                                        <th class="px-6 py-4 text-xs font-black text-slate-500 uppercase text-right">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 dark:divide-slate-800">
                                    <% if (!performanceReports.isEmpty()) { 
                                        for (Publication report : performanceReports) {
                                    %>
                                    <tr class="hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                                        <td class="px-6 py-4 font-bold text-primary"><%= report.getYear() %></td>
                                        <td class="px-6 py-4 font-medium"><%= report.getTitle() %></td>
                                        <td class="px-6 py-4 text-right">
                                            <% if (report.getFileUrl() != null && !report.getFileUrl().isEmpty()) { %>
                                                <a href="<%= report.getFileUrl() %>" target="_blank"
                                                   title="View Report" class="inline-flex items-center justify-center p-2 rounded-xl bg-primary/5 text-primary hover:bg-primary hover:text-white transition-all">
                                                    <span class="material-symbols-outlined text-xl">visibility</span>
                                                </a>
                                            <% } else { %>
                                                <a href="mailto:info@nic.gov.gh?subject=Report%20Request%3A%20<%= report.getTitle() %>"
                                                   title="Request Full Report" class="inline-flex items-center justify-center p-2 rounded-xl bg-slate-50 text-slate-400 hover:bg-primary hover:text-white transition-all">
                                                    <span class="material-symbols-outlined text-xl">mail</span>
                                                </a>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="3" class="px-6 py-12 text-center text-slate-400 font-medium italic">
                                            No performance reports currently published for this period.
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <!-- Registered Entity Breakdown -->
                        <h2 class="text-3xl font-black pt-4">Registered Entities</h2>
                        <div class="bg-white dark:bg-slate-900 rounded-[2rem] border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-6 space-y-5">
                                <%
                                    int[][] breakdown = {
                                        {countNonLife, 100},
                                        {countLife,    100},
                                        {countReinsurer, 100},
                                        {countBroker,  100}
                                    };
                                    String[] bLabels = {"Non-Life Insurers","Life Insurers","Reinsurers","Brokers"};
                                    String[] bColors = {"bg-primary","bg-emerald-500","bg-indigo-500","bg-amber-500"};
                                    int maxCount = Math.max(countNonLife, Math.max(countLife, Math.max(countReinsurer, countBroker)));
                                    if (maxCount == 0) maxCount = 1;
                                    int[] bCounts = {countNonLife, countLife, countReinsurer, countBroker};
                                    for (int i = 0; i < bLabels.length; i++) {
                                        int barW = (int)(bCounts[i] * 100.0 / maxCount);
                                %>
                                <div>
                                    <div class="flex justify-between text-sm font-bold text-slate-700 mb-1.5">
                                        <span><%= bLabels[i] %></span>
                                        <span class="text-slate-900"><%= bCounts[i] %></span>
                                    </div>
                                    <div class="h-2.5 bg-slate-100 rounded-full overflow-hidden">
                                        <div class="h-full <%= bColors[i] %> bar-fill rounded-full" style="width:<%= barW %>%"></div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Market Share -->
                    <div class="space-y-8">
                        <h2 class="text-3xl font-black">Market Share</h2>
                        <div class="p-8 rounded-[2.5rem] bg-slate-900 text-white relative overflow-hidden group">
                            <div class="relative z-10 space-y-8">

                                <!-- Non-Life Leader -->
                                <div>
                                    <p class="text-[10px] font-black uppercase text-white/50 tracking-widest mb-2">Market Leader (Non-Life)</p>
                                    <% if (!"—".equals(nonLifeLeader)) { %>
                                    <h4 class="text-xl font-black leading-tight"><%= nonLifeLeader %></h4>
                                    <p class="text-xs text-white/50 mt-0.5 font-medium"><%= nonLifeLeaderPolicies %> active policies</p>
                                    <div class="mt-4 flex items-center gap-3">
                                        <div class="flex-grow h-2 bg-white/20 rounded-full overflow-hidden">
                                            <div class="h-full bg-emerald-500 bar-fill rounded-full" style="width:<%= nonLifeBarWidth %>%"></div>
                                        </div>
                                        <span class="text-xs font-black opacity-80 shrink-0"><%= nonLifePctStr %>%</span>
                                    </div>
                                    <% } else { %>
                                    <p class="text-sm text-white/40 italic">No non-life data yet</p>
                                    <% } %>
                                </div>

                                <div class="border-t border-white/10"></div>

                                <!-- Life Leader -->
                                <div>
                                    <p class="text-[10px] font-black uppercase text-white/50 tracking-widest mb-2">Market Leader (Life)</p>
                                    <% if (!"—".equals(lifeLeader)) { %>
                                    <h4 class="text-xl font-black leading-tight"><%= lifeLeader %></h4>
                                    <p class="text-xs text-white/50 mt-0.5 font-medium"><%= lifeLeaderPolicies %> active policies</p>
                                    <div class="mt-4 flex items-center gap-3">
                                        <div class="flex-grow h-2 bg-white/20 rounded-full overflow-hidden">
                                            <div class="h-full bg-blue-500 bar-fill rounded-full" style="width:<%= lifeBarWidth %>%"></div>
                                        </div>
                                        <span class="text-xs font-black opacity-80 shrink-0"><%= lifePctStr %>%</span>
                                    </div>
                                    <% } else { %>
                                    <p class="text-sm text-white/40 italic">No life data yet</p>
                                    <% } %>
                                </div>

                                <!-- Top 3 Non-Life -->
                                <% if (topNonLifeNames.size() > 1) { %>
                                <div class="border-t border-white/10 pt-6">
                                    <p class="text-[10px] font-black uppercase text-white/50 tracking-widest mb-4">Top Non-Life Insurers</p>
                                    <div class="space-y-3">
                                    <% for (int i = 0; i < Math.min(3, topNonLifeNames.size()); i++) {
                                        int w = (nonLifeLeaderPolicies > 0) ? (int)(topNonLifeCounts.get(i) * 100.0 / nonLifeLeaderPolicies) : 0;
                                    %>
                                        <div>
                                            <div class="flex justify-between text-xs mb-1">
                                                <span class="font-bold text-white/80 truncate max-w-[160px]"><%= topNonLifeNames.get(i) %></span>
                                                <span class="text-white/50"><%= topNonLifeCounts.get(i) %></span>
                                            </div>
                                            <div class="h-1.5 bg-white/10 rounded-full overflow-hidden">
                                                <div class="h-full bg-emerald-400/70 bar-fill rounded-full" style="width:<%= w %>%"></div>
                                            </div>
                                        </div>
                                    <% } %>
                                    </div>
                                </div>
                                <% } %>

                            </div>
                            <div class="absolute -right-10 -bottom-10 opacity-10 group-hover:scale-110 transition-transform duration-700">
                                <span class="material-symbols-outlined text-[10rem]">pie_chart</span>
                            </div>
                        </div>

                        <!-- Last Updated -->
                        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-100 p-5 flex items-center gap-3">
                            <span class="material-symbols-outlined text-emerald-500 text-lg">update</span>
                            <div>
                                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-0.5">Data Freshness</p>
                                <p class="text-xs font-bold text-slate-700">Live — queried <%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(new java.util.Date()) %> UTC</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="common/public_footer.jsp" />
</div>
</body>
</html>
