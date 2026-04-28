<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="com.insurance.util.EmailService" %>
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
    String apiKey = dao.getSystemSetting("email_api_key");
    String fromAddress = dao.getSystemSetting("email_from_address");
    String emailMode = dao.getSystemSetting("email_mode");
    // SMTP settings
    String smtpHost = dao.getSystemSetting("smtp_host");
    String smtpPort = dao.getSystemSetting("smtp_port");
    String smtpUser = dao.getSystemSetting("smtp_username");
    String smtpPass = dao.getSystemSetting("smtp_password");
    String smtpFrom = dao.getSystemSetting("smtp_from");
    String smtpSSL = dao.getSystemSetting("smtp_ssl");
    
    if (apiKey == null) apiKey = "";
    if (fromAddress == null) fromAddress = "NIC <onboarding@resend.dev>";
    if (emailMode == null) emailMode = "resend";
    if (smtpHost == null) smtpHost = "";
    if (smtpPort == null) smtpPort = "587";
    if (smtpUser == null) smtpUser = "";
    if (smtpPass == null) smtpPass = "";
    if (smtpFrom == null) smtpFrom = "";
    if (smtpSSL == null) smtpSSL = "true";

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Email Settings - NIC Portal</title>
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
            <h1 class="text-3xl font-black text-slate-900 tracking-tight mt-4">Email Settings</h1>
            <p class="text-slate-500 mt-1 font-medium">Configure email sending via Resend API or SMTP (Gmail, Outlook, etc.) for notifications and invitations.</p>
        </div>

        <% if ("saved".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">Email settings saved successfully.</span>
        </div>
        <% } %>
        <% if ("test_sent".equals(successMsg)) { %>
        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-emerald-500">check_circle</span>
            <span class="font-medium">Test email sent! Check your inbox.</span>
        </div>
        <% } %>
        <% if ("test_failed".equals(errorMsg)) { 
            String detailMsg = request.getParameter("msg");
        %>
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-start gap-2">
            <span class="material-symbols-outlined text-red-500 mt-0.5">error</span>
            <div>
                <span class="font-medium">Test email failed.</span>
                <% if (detailMsg != null && !detailMsg.isEmpty()) { %>
                <p class="text-sm mt-1 text-red-600"><%= detailMsg %></p>
                <% } else { %>
                <p class="text-sm mt-1 text-red-600">Check your API key/sender address (Resend) or SMTP settings.</p>
                <% } %>
            </div>
        </div>
        <% } %>
        <% if ("no_api_key".equals(errorMsg)) { %>
        <div class="bg-amber-50 border border-amber-200 text-amber-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            <span class="material-symbols-outlined text-amber-500">warning</span>
            <span class="font-medium">Cannot send test email without an API key.</span>
        </div>
        <% } %>

        <!-- Setup Guide -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">info</span>
                Quick Setup Guide
            </h2>
            <div class="space-y-4">
                <div class="bg-blue-50 border border-blue-200 rounded-xl p-4">
                    <h3 class="font-bold text-blue-800 mb-2">Option 1: Resend API (Easiest)</h3>
                    <ol class="text-sm text-blue-700 space-y-1 list-decimal list-inside">
                        <li>Sign up at <a href="https://resend.com" target="_blank" class="underline font-medium">resend.com</a> (free: 3,000 emails/month)</li>
                        <li>Get your API key from the Resend dashboard</li>
                        <li>Verify your sender domain (or use <code class="bg-blue-100 px-1 rounded">onboarding@resend.dev</code> for testing)</li>
                        <li><strong>Note:</strong> Free tier only sends to your own email address</li>
                    </ol>
                </div>
                <div class="bg-emerald-50 border border-emerald-200 rounded-xl p-4">
                    <h3 class="font-bold text-emerald-800 mb-2">Option 2: SMTP / Gmail (No API Key)</h3>
                    <ol class="text-sm text-emerald-700 space-y-1 list-decimal list-inside">
                        <li>Use your Gmail, Outlook, or any SMTP server</li>
                        <li>For Gmail: Enable 2FA and create an <a href="https://myaccount.google.com/apppasswords" target="_blank" class="underline font-medium">App Password</a></li>
                        <li>Enter SMTP settings below and select "SMTP Mode"</li>
                        <li><strong>Benefit:</strong> Send to any email address without domain verification</li>
                    </ol>
                </div>
            </div>
        </div>

        <!-- Settings Form -->
        <form action="email_settings_process.jsp" method="POST" class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8 mb-6">
            <h2 class="text-lg font-bold text-slate-900 mb-6 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">settings</span>
                Configuration
            </h2>

            <!-- Email Mode Toggle -->
            <div class="mb-6">
                <label class="block text-sm font-bold text-slate-700 mb-2">Email Sending Mode</label>
                <div class="flex gap-4">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="radio" name="email_mode" value="resend" <%= "resend".equals(emailMode) ? "checked" : "" %> 
                            class="w-4 h-4 text-primary" onchange="toggleMode()">
                        <span class="text-sm font-medium">Resend API</span>
                    </label>
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="radio" name="email_mode" value="smtp" <%= "smtp".equals(emailMode) ? "checked" : "" %> 
                            class="w-4 h-4 text-primary" onchange="toggleMode()">
                        <span class="text-sm font-medium">SMTP (Gmail/Outlook)</span>
                    </label>
                </div>
            </div>

            <!-- Resend API Section -->
            <div id="resend-section" class="space-y-6 <%= "smtp".equals(emailMode) ? "hidden" : "" %>">
                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Resend API Key</label>
                    <input type="password" name="api_key" value="<%= apiKey %>" 
                        class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                        placeholder="re_xxxxxxxxxxxxxxxx" />
                    <p class="text-xs text-slate-400 mt-1">Found in your Resend dashboard &rarr; API Keys</p>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">Sender Email Address (Resend)</label>
                    <input type="text" name="from_address" value="<%= fromAddress %>" 
                        class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                        placeholder="NIC &lt;onboarding@resend.dev&gt;" />
                    <p class="text-xs text-slate-400 mt-1">For testing: <code class="bg-slate-100 px-1.5 py-0.5 rounded">NIC &lt;onboarding@resend.dev&gt;</code></p>
                </div>
            </div>

            <!-- SMTP Section -->
            <div id="smtp-section" class="space-y-6 <%= "resend".equals(emailMode) ? "hidden" : "" %>">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">SMTP Host</label>
                        <input type="text" name="smtp_host" value="<%= smtpHost %>" 
                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                            placeholder="smtp.gmail.com" />
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-slate-700 mb-2">SMTP Port</label>
                        <input type="text" name="smtp_port" value="<%= smtpPort %>" 
                            class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                            placeholder="587" />
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">SMTP Username</label>
                    <input type="text" name="smtp_username" value="<%= smtpUser %>" 
                        class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                        placeholder="your.email@gmail.com" />
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">SMTP Password / App Password</label>
                    <input type="password" name="smtp_password" value="<%= smtpPass %>" 
                        class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                        placeholder="your-app-password" />
                    <p class="text-xs text-slate-400 mt-1">For Gmail, use an <a href="https://myaccount.google.com/apppasswords" target="_blank" class="text-primary hover:underline">App Password</a> (not your regular password)</p>
                </div>

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2">From Email Address</label>
                    <input type="text" name="smtp_from" value="<%= smtpFrom %>" 
                        class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                        placeholder="NIC &lt;your.email@gmail.com&gt;" />
                    <p class="text-xs text-slate-400 mt-1">Usually same as SMTP username. Format: <code class="bg-slate-100 px-1 rounded">Name &lt;email@example.com&gt;</code></p>
                </div>

                <div class="flex items-center gap-2">
                    <input type="checkbox" name="smtp_ssl" value="true" <%= "true".equals(smtpSSL) ? "checked" : "" %> 
                        class="w-4 h-4 text-primary rounded" id="smtp_ssl"/>
                    <label for="smtp_ssl" class="text-sm font-medium text-slate-700 cursor-pointer">Enable TLS/SSL (recommended for Gmail)</label>
                </div>

                <div class="bg-amber-50 border border-amber-200 rounded-lg p-3">
                    <p class="text-xs text-amber-800"><strong>Gmail Setup:</strong></p>
                    <ul class="text-xs text-amber-700 list-disc list-inside mt-1">
                        <li>Host: <code>smtp.gmail.com</code>, Port: <code>587</code></li>
                        <li>Enable TLS/SSL checkbox</li>
                        <li>Use App Password from <a href="https://myaccount.google.com/apppasswords" target="_blank" class="underline">Google Account</a></li>
                    </ul>
                </div>
            </div>

            <button type="submit" class="w-full bg-primary text-white font-bold py-3 px-6 rounded-xl hover:bg-primary/90 transition mt-6">
                Save Email Settings
            </button>
        </form>

        <script>
            function toggleMode() {
                const mode = document.querySelector('input[name="email_mode"]:checked').value;
                document.getElementById('resend-section').classList.toggle('hidden', mode === 'smtp');
                document.getElementById('smtp-section').classList.toggle('hidden', mode === 'resend');
            }
        </script>

        <!-- Test Email -->
        <div class="bg-white rounded-3xl border border-slate-100 shadow-sm p-6 lg:p-8">
            <h2 class="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                <span class="material-symbols-outlined text-primary">send</span>
                Send Test Email
            </h2>
            <p class="text-sm text-slate-500 mb-4">Verify your email configuration by sending a test message.</p>
            <form action="email_test_process.jsp" method="POST" class="flex gap-3">
                <input type="email" name="test_email" required
                    class="flex-1 px-4 py-3 rounded-xl border border-slate-200 focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition text-sm"
                    placeholder="your@email.com" />
                <button type="submit" class="bg-emerald-500 text-white font-bold py-3 px-6 rounded-xl hover:bg-emerald-600 transition whitespace-nowrap">
                    Send Test
                </button>
            </form>
        </div>
    </div>
</body>
</html>
