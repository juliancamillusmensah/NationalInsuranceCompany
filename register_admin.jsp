<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    String token = request.getParameter("token");
    if (token == null || token.isEmpty()) {
        response.sendRedirect("allloginpage.jsp?error=invalid_invitation");
        return;
    }
    SystemDAO systemDAO = new SystemDAO();
    AdminInvitation invite = systemDAO.getInvitationByToken(token);
    if (invite == null || invite.isUsed()) {
        response.sendRedirect("allloginpage.jsp?error=invalid_invitation_or_used");
        return;
    }
    /* Check expiration */
    if (invite.getExpiresAt().before(new java.util.Date())) {
        response.sendRedirect("allloginpage.jsp?error=invitation_expired");
        return;
    }
    String invitedRoleDisplay = invite.getInvitedRole();
    if ("companyadmin".equals(invitedRoleDisplay))
        invitedRoleDisplay = "Company Administrator";
    else if ("support".equals(invitedRoleDisplay))
        invitedRoleDisplay = "Customer Support Agent";
    else if ("auditor".equals(invitedRoleDisplay))
        invitedRoleDisplay = "Financial Auditor";
%>

                <!DOCTYPE html>
                <html class="light" lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                    <title>Admin Activation | NIC</title>
                    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap"
                        rel="stylesheet" />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                        rel="stylesheet" />
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
                                    fontFamily: { "display": ["Inter"] },
                                    borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                                },
                            },
                        }
                    </script>
                    <style>
                        body {
                            font-family: 'Inter', sans-serif;
                        }

                        .bg-pattern {
                            background-color: #1152d4;
                            background-image: radial-gradient(circle at 2px 2px, rgba(255, 255, 255, 0.15) 1px, transparent 0);
                            background-size: 24px 24px;
                        }
                    </style>
                </head>

                <body
                    class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 antialiased min-h-screen">
                    <div class="flex min-h-screen w-full flex-col lg:flex-row">
                        <!-- Left Panel -->
                        <div
                            class="hidden lg:flex lg:w-1/3 bg-primary text-white p-12 flex-col justify-between relative overflow-hidden bg-pattern shrink-0">
                            <div class="z-10">
                                <div class="flex items-center gap-3 mb-12">
                                    <div class="bg-white text-primary p-2 rounded-lg shadow-lg">
                                        <span class="material-symbols-outlined text-3xl font-bold">shield</span>
                                    </div>
                                    <h1 class="text-2xl font-black tracking-tight">NIC</h1>
                                </div>
                                <h2 class="text-5xl font-extrabold leading-tight mb-6">Welcome to the Team.</h2>
                                <p class="text-primary-100 text-lg opacity-90 leading-relaxed">Secure your
                                    administrative access and help us redefine insurance for the digital age.</p>
                            </div>
                            <div class="z-10">
                                <div class="text-xs opacity-70">© 2024 NIC Inc. Operations Suite.</div>
                            </div>
                            <div class="absolute -bottom-24 -right-24 h-96 w-96 bg-white/10 rounded-full blur-3xl">
                            </div>
                        </div>

                        <!-- Right Side -->
                        <div
                            class="flex-1 flex flex-col items-center justify-center p-6 sm:p-12 lg:p-20 bg-white dark:bg-slate-900 relative">
                            <div class="w-full max-w-[480px] relative z-10">
                                <div class="mb-10 text-center lg:text-left">
                                    <h3
                                        class="text-3xl lg:text-4xl font-black text-slate-900 dark:text-white mb-2 tracking-tight">
                                        Activate Admin Portal</h3>
                                    <p class="text-slate-500 dark:text-slate-400 font-medium">Invited as <span
                                            class="text-primary font-bold">
                                            <%= invite.getEmail() %>
                                        </span></p>
                                    <div
                                        class="mt-4 inline-flex items-center gap-2 px-4 py-2 bg-slate-50 dark:bg-slate-800 rounded-full border border-slate-100 dark:border-slate-700">
                                        <span
                                            class="material-symbols-outlined text-primary text-lg">verified_user</span>
                                        <span
                                            class="text-xs font-bold text-slate-600 dark:text-slate-300 uppercase tracking-widest">
                                            <%= invitedRoleDisplay %> Access
                                        </span>
                                    </div>
                                </div>

                                <% if (request.getParameter("error") !=null) { %>
                                    <div
                                        class="mb-6 p-4 bg-red-50 dark:bg-red-900/10 border border-red-100 dark:border-red-900/20 rounded-xl flex items-center gap-3 text-red-600 dark:text-red-400 text-sm font-semibold">
                                        <span class="material-symbols-outlined">error</span>
                                        <%= "passwords_mismatch" .equals(request.getParameter("error"))
                                            ? "Passwords do not match." : "Activation failed. Please try again." %>
                                    </div>
                                    <% } %>

                                        <form action="register-admin" method="POST" class="space-y-6">
                                            <input type="hidden" name="token" value="<%= token %>">

                                            <div class="space-y-4">
                                                <div class="flex flex-col gap-1.5">
                                                    <label
                                                        class="text-sm font-semibold text-slate-700 dark:text-slate-300">Full
                                                        Name</label>
                                                    <div class="relative">
                                                        <span
                                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">person</span>
                                                        <input name="full_name"
                                                            class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                            placeholder="Administrator Name" type="text" required />
                                                    </div>
                                                </div>

                                                <div class="flex flex-col gap-1.5">
                                                    <label
                                                        class="text-sm font-semibold text-slate-700 dark:text-slate-300">Create
                                                        Password</label>
                                                    <div class="relative">
                                                        <span
                                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">key</span>
                                                        <input name="password"
                                                            class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                            placeholder="Secure Password" type="password" required />
                                                    </div>
                                                </div>

                                                <div class="flex flex-col gap-1.5">
                                                    <label
                                                        class="text-sm font-semibold text-slate-700 dark:text-slate-300">Confirm
                                                        Password</label>
                                                    <div class="relative">
                                                        <span
                                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">lock_reset</span>
                                                        <input name="confirm_password"
                                                            class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                            placeholder="Repeat Password" type="password" required />
                                                    </div>
                                                </div>
                                            </div>

                                            <button
                                                class="w-full bg-primary hover:bg-blue-700 text-white font-bold py-4 px-6 rounded-lg shadow-lg shadow-primary/20 transition-all transform hover:-translate-y-0.5 active:translate-y-0 flex items-center justify-center gap-2"
                                                type="submit">
                                                Activate Account
                                                <span class="material-symbols-outlined text-lg">verified</span>
                                            </button>
                                        </form>
                            </div>
                        </div>
                    </div>
                </body>

                </html>