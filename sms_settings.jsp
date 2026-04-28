<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
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
    String apiKey = dao.getSystemSetting("sms_api_key");
    if (apiKey == null) apiKey = "";

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>SMS Settings - NIC Portal</title>
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
            <h1 class="text-3xl font-black text-slate-900 tracking-tight mt-4">SMS Settings</h1>
            <p class="text-slate-500 mt-1 font-medium">Configure SMS gateway for notification alerts and OTPs.</p>
        </div>

        <% if ("saved".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">SMS settings saved successfully.</span>
        </div>
        <% } %>
        <% if ("test_success".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">Test SMS sent successfully! Check your phone.</span>
        </div>
        <% } %>
        <% if ("test_failed".equals(errorMsg)) { %>
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-red-500">error</span>
            <span class="font-medium">Test SMS failed. Check your API key and phone number.</span>
        </div>
        <% } %>
        <% if ("quota_exceeded".equals(errorMsg)) { %>
        <div class="bg-amber-50 border border-amber-200 text-amber-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-amber-500">warning</span>
            <span class="font-medium">Free quota exceeded (1 SMS/day with public key). Try again tomorrow or upgrade your key.</span>
        </div>
        <% } %>

        <!-- Setup Guide -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">info</span>
                Quick Setup Guide
            </h2>
            <ol class="text-sm text-slate-600 space-y-2 list-decimal list-inside">
                <li><strong>Zero-config testing:</strong> Use key <code class="bg-slate-100 px-1.5 py-0.5 rounded text-xs font-mono">textbelt</code> for 1 free SMS/day — no signup needed.</li>
                <li><strong>For more volume:</strong> Get a paid API key at <a href="https://textbelt.com/purchase" target="_blank" class="text-primary hover:underline font-medium">textbelt.com/purchase</a> (supports 250+ countries).</li>
                <li><strong>Ghana production:</strong> Sign up at <a href="https://termii.com" target="_blank" class="text-primary hover:underline font-medium">termii.com</a> for MTN/Vodafone/AirtelTigo support.</li>
            </ol>
            <p class="text-xs text-slate-400 mt-3">Phone numbers should be in E.164 format: <code class="bg-slate-100 px-1 rounded text-xs font-mono">+233241234567</code></p>
        </div>

        <!-- Settings Form -->
        <form action="sms_settings_process.jsp" method="POST" class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-6 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">settings</span>
                Configuration
            </h2>

            <div class="mb-6">
                <label class="block text-sm font-bold text-slate-700 mb-2">SMS API Key</label>
                <input type="text" name="sms_api_key" value="<%= apiKey %>" 
                    class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm font-mono"
                    placeholder="textbelt" />
                <p class="text-xs text-slate-400 mt-1">Use <code class="bg-slate-100 px-1 rounded text-xs font-mono">textbelt</code> for 1 free SMS/day, or enter your paid key for unlimited.</p>
            </div>

            <button type="submit" class="w-full bg-primary text-white font-bold py-3 px-6 rounded-xl hover:bg-primary/90 transition">
                Save SMS Settings
            </button>
        </form>

        <!-- Test SMS -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">sms</span>
                Test SMS
            </h2>
            <p class="text-sm text-slate-500 mb-4">Send a test message to verify your configuration. Uses 1 SMS from your quota.</p>
            <form action="sms_test_process.jsp" method="POST" class="flex gap-3">
                <input type="tel" name="test_phone" required
                    class="flex-1 px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                    placeholder="+233241234567" />
                <button type="submit" class="bg-emerald-500 text-white font-bold py-3 px-6 rounded-xl hover:bg-emerald-600 transition whitespace-nowrap">
                    Send Test
                </button>
            </form>
        </div>
    </div>
</body>
</html>
