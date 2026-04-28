<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.insurance.model.Account" %>
        <% 
            Account user = (Account) session.getAttribute("user"); 
            if (user == null) {
                response.sendRedirect("allloginpage.jsp"); 
                return; 
            } 
            
            String redirectUrl = "allloginpage.jsp?error=unauthorized"; 
            String roleId = user.getRoleId();
            
            if (roleId != null) {
                if (roleId.contains("SYSTEM_CREATOR")) redirectUrl = "Systemcreator.jsp";
                else if (roleId.contains("SUPERADMIN")) redirectUrl = "Superadmin.jsp";
                else if (roleId.contains("ADMIN")) redirectUrl = "Companyadmin.jsp";
                else if (roleId.contains("SUPPORT")) redirectUrl = "companyadmin_claims.jsp";
                else if (roleId.contains("AUDITOR")) redirectUrl = "companyadmin_transactions.jsp";
                else if (roleId.contains("CUSTOMER")) redirectUrl = "Customerportal.jsp";
                else redirectUrl = "Customerportal.jsp"; // Ultimate safe fallback
            }
        %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>NIC Platform | Secure Redirection</title>
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
                                    "primary-dark": "#0a3aa6",
                                    "primary-light": "#60a5fa",
                                    "background-light": "#f6f6f8",
                                    "background-dark": "#101622",
                                },
                                fontFamily: {
                                    "display": ["Inter", "sans-serif"]
                                },
                                borderRadius: {
                                    "DEFAULT": "0.25rem",
                                    "lg": "0.5rem",
                                    "xl": "0.75rem",
                                    "full": "9999px"
                                },
                                animation: {
                                    'spin-slow': 'spin 3s linear infinite',
                                    'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                                    'ping-slow': 'ping 2s cubic-bezier(0, 0, 0.2, 1) infinite',
                                }
                            },
                        },
                    }
                </script>
                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                    }

                    .loader-ring {
                        display: inline-block;
                        position: relative;
                        width: 80px;
                        height: 80px;
                    }

                    .loader-ring div {
                        box-sizing: border-box;
                        display: block;
                        position: absolute;
                        width: 64px;
                        height: 64px;
                        margin: 8px;
                        border: 4px solid #1152d4;
                        border-radius: 50%;
                        animation: loader-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
                        border-color: #1152d4 transparent transparent transparent;
                    }

                    .loader-ring div:nth-child(1) {
                        animation-delay: -0.45s;
                    }

                    .loader-ring div:nth-child(2) {
                        animation-delay: -0.3s;
                    }

                    .loader-ring div:nth-child(3) {
                        animation-delay: -0.15s;
                    }

                    @keyframes loader-ring {
                        0% {
                            transform: rotate(0deg);
                        }

                        100% {
                            transform: rotate(360deg);
                        }
                    }

                    .fade-in-up {
                        animation: fadeInUp 0.8s ease-out forwards;
                    }

                    @keyframes fadeInUp {
                        from {
                            opacity: 1;
                            transform: translateY(10px);
                        }
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }
                </style>
                <script>
                    setTimeout(function () {
                        window.location.href = "<%= redirectUrl %>";
                    }, 1500);
                </script>
                <meta http-equiv="refresh" content="5;url=<%= redirectUrl %>">
            </head>

            <body
                class="bg-background-dark text-slate-100 font-display min-h-screen flex items-center justify-center p-4">
                <div
                    class="relative w-full max-w-[1600px] min-h-[90vh] py-12 lg:py-0 bg-slate-900 rounded-3xl overflow-hidden shadow-2xl flex flex-col items-center justify-center border border-slate-800">
                    <div class="absolute inset-0 bg-cover bg-center opacity-20 pointer-events-none"
                        style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuC5UNks6C15d1eX5YmHy992vnlL_YLSX--gkzbwP02ZUgZRhY34L0ynChOIgZhIrY4-bg1wXDfjOX7o4fnVFuyDWJsMg_TQUxMPbCFCH0joFqtyQkBEJaE4JB0RtZpGtJqz9M-CnT81YtjBaMWgWfenpkebVUMZ_3_xXMMNVN8QXyIpyl10GKmihHWI_Z8th9j_XL-tn0IoOfojRSwXv8vlsG0Gt5Akrkggxq9p3FySreztRM1DNrEwOaMG_z_UVk2enQldl4Hbf3s'); filter: grayscale(100%);">
                    </div>
                    <div
                        class="absolute inset-0 bg-gradient-to-br from-slate-900 via-slate-900/95 to-primary-dark/20 pointer-events-none">
                    </div>
                    <div class="relative z-10 flex flex-col items-center justify-center space-y-10 fade-in-up">
                        <div class="flex items-center gap-3 mb-4">
                            <div
                                class="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/20 backdrop-blur-md border border-primary/30 text-primary-light shadow-[0_0_15px_rgba(17,82,212,0.3)]">
                                <span class="material-symbols-outlined text-3xl">shield_with_heart</span>
                            </div>
                            <span class="text-2xl font-bold tracking-tight text-white">NIC</span>
                        </div>
                        <div class="relative flex items-center justify-center py-8">
                            <div
                                class="absolute w-32 h-32 rounded-full border border-primary/10 animate-[spin_8s_linear_infinite]">
                            </div>
                            <div
                                class="absolute w-40 h-40 rounded-full border border-primary/5 animate-[spin_12s_linear_infinite_reverse]">
                            </div>
                            <div class="absolute w-24 h-24 bg-primary/5 rounded-full blur-xl animate-pulse"></div>
                            <div class="loader-ring">
                                <div></div>
                                <div></div>
                                <div></div>
                                <div></div>
                            </div>
                        </div>
                        <div class="text-center space-y-2 max-w-sm">
                            <h2 class="text-2xl font-semibold text-white tracking-wide">Authenticating...</h2>
                            <p class="text-slate-400 text-sm animate-pulse">Redirecting to your dashboard</p>
                            <div class="w-64 h-1 bg-slate-800 rounded-full mt-6 mx-auto overflow-hidden">
                                <div class="h-full bg-primary animate-[width_2s_ease-in-out_infinite]"
                                    style="width: 30%"></div>
                            </div>
                        </div>
                    </div>
                    <div class="absolute bottom-12 z-10 flex flex-col items-center gap-2 text-slate-500">
                        <div
                            class="flex items-center gap-2 px-4 py-2 bg-slate-900/50 rounded-full border border-slate-800 backdrop-blur-sm">
                            <span class="material-symbols-outlined text-green-500 text-sm">lock</span>
                            <span class="text-xs font-medium tracking-wide uppercase">256-Bit Secure Connection</span>
                        </div>
                        <p class="text-[10px] opacity-60">Verified by NIC Security Protocol</p>
                    </div>
                </div>

            </body>

            </html>