<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.PaystackService" %>
<% 
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    String roleId = (String) sess.getAttribute("roleId");
    if (!"ROLE_SYSTEM_CREATOR".equals(roleId) && !"ROLE_SUPERADMIN".equals(roleId)) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    SystemDAO dao = new SystemDAO();
    String secretKey = dao.getSystemSetting("paystack_secret_key");
    String publicKey = dao.getSystemSetting("paystack_public_key");
    if (secretKey == null) secretKey = "";
    if (publicKey == null) publicKey = "";

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Paystack Settings - NIC Portal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
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
</head>
<body class="bg-background-light text-slate-900 font-display min-h-screen">
    <div class="max-w-2xl mx-auto p-6 lg:p-10">
        <div class="mb-8">
            <a href="Systemcreator.jsp" class="text-primary hover:underline text-sm font-medium">&larr; Back to Dashboard</a>
            <h1 class="text-3xl font-black text-slate-900 tracking-tight mt-4">Paystack Settings</h1>
            <p class="text-slate-500 mt-1 font-medium">Configure Paystack payment gateway for policy enrollments and license renewals.</p>
        </div>

        <% if ("saved".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">Paystack settings saved successfully.</span>
        </div>
        <% } %>
        <% if ("test_success".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">Paystack is reachable and your keys are valid!</span>
        </div>
        <% } %>
        <% if ("test_failed".equals(errorMsg)) { %>
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-red-500">error</span>
            <span class="font-medium">Paystack connection test failed. Check your secret key.</span>
        </div>
        <% } %>

        <!-- Setup Guide -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">info</span>
                Quick Setup Guide
            </h2>
            <ol class="text-sm text-slate-600 space-y-2 list-decimal list-inside">
                <li>Sign up at <a href="https://paystack.com" target="_blank" class="text-primary hover:underline font-medium">paystack.com</a></li>
                <li>Go to Settings &rarr; API Keys in your Paystack dashboard</li>
                <li>Copy your <strong>Secret Key</strong> (sk_test_... for test mode, sk_live_... for live)</li>
                <li>Copy your <strong>Public Key</strong> (pk_test_... or pk_live_...)</li>
                <li>Enter both keys below and save</li>
            </ol>
            <p class="text-xs text-slate-400 mt-3">Paystack charges 1.5% + GHS 1 per transaction in Ghana.</p>
        </div>

        <!-- Settings Form -->
        <form action="paystack_settings_process.jsp" method="POST" class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-6 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">settings</span>
                Configuration
            </h2>

            <div class="mb-6">
                <label class="block text-sm font-bold text-slate-700 mb-2">Paystack Secret Key</label>
                <input type="password" name="secret_key" value="<%= secretKey %>" 
                    class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                    placeholder="sk_test_xxxxxxxxxxxxxxxxxxxxxxxxx" />
                <p class="text-xs text-slate-400 mt-1">Found in Paystack dashboard &rarr; Settings &rarr; API Keys. Keep this secret!</p>
            </div>

            <div class="mb-6">
                <label class="block text-sm font-bold text-slate-700 mb-2">Paystack Public Key (optional)</label>
                <input type="text" name="public_key" value="<%= publicKey %>" 
                    class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                    placeholder="pk_test_xxxxxxxxxxxxxxxxxxxxxxxxx" />
                <p class="text-xs text-slate-400 mt-1">Used for inline/popup JS payments. Required only if you want Paystack inline checkout on the frontend.</p>
            </div>

            <button type="submit" class="w-full bg-primary text-white font-bold py-3 px-6 rounded-xl hover:bg-primary/90 transition">
                Save Paystack Settings
            </button>
        </form>

        <!-- Test Connection -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">network_check</span>
                Test Connection
            </h2>
            <p class="text-sm text-slate-500 mb-4">Verify your Paystack configuration by initializing a test transaction (GHS 1.00).</p>
            <form action="paystack_test_process.jsp" method="POST" class="flex gap-3">
                <input type="email" name="test_email" required
                    class="flex-1 px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                    placeholder="your@email.com" />
                <button type="submit" class="bg-emerald-500 text-white font-bold py-3 px-6 rounded-xl hover:bg-emerald-600 transition whitespace-nowrap">
                    Test Paystack
                </button>
            </form>
        </div>
    </div>
</body>
</html>
