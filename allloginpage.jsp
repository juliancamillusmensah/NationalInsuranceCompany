<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Login | NIC</title>
        <!-- DEBUG_PROBE_v3_AUTHENTICATION_FIX -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap"
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
        </style>
    </head>

    <body
        class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display min-h-screen flex items-center justify-center p-4">
        <div style="background-color: #ffffff; border: 1px solid #e2e8f0;"
            class="w-full max-w-[1600px] min-h-[90vh] my-4 md:my-0 bg-white dark:bg-slate-900 rounded-3xl overflow-hidden shadow-2xl flex flex-col md:flex-row border border-slate-200 dark:border-slate-800">
            <div class="relative w-full md:w-1/2 min-h-[400px] md:min-h-full bg-slate-900">
                <div class="absolute inset-0 bg-cover bg-center opacity-80"
                    style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuC5UNks6C15d1eX5YmHy992vnlL_YLSX--gkzbwP02ZUgZRhY34L0ynChOIgZhIrY4-bg1wXDfjOX7o4fnVFuyDWJsMg_TQUxMPbCFCH0joFqtyQkBEJaE4JB0RtZpGtJqz9M-CnT81YtjBaMWgWfenpkebVUMZ_3_xXMMNVN8QXyIpyl10GKmihHWI_Z8th9j_XL-tn0IoOfojRSwXv8vlsG0Gt5Akrkggxq9p3FySreztRM1DNrEwOaMG_z_UVk2enQldl4Hbf3s');">
                </div>
                <div class="absolute inset-0 bg-gradient-to-t from-slate-900/90 to-slate-900/30"></div>
                <div
                    class="relative z-10 h-full flex flex-col justify-between p-8 md:p-12 lg:p-16 text-white min-h-[400px]">
                    <div class="flex items-center gap-3">
                        <div
                            class="flex h-10 w-10 items-center justify-center rounded-lg bg-white/10 backdrop-blur-sm border border-white/20 text-white">
                            <span class="material-symbols-outlined text-2xl">shield_with_heart</span>
                        </div>
                        <span class="text-xl font-bold tracking-tight">NIC</span>
                    </div>
                    <div class="space-y-6">
                        <h1 class="text-3xl md:text-4xl lg:text-5xl font-bold leading-tight">
                            Securing Growth.<br />
                            <span class="text-blue-400">Protecting Futures.</span>
                        </h1>
                        <p class="text-slate-300 text-lg max-w-md leading-relaxed">
                            Access the unified infrastructure powering the next generation of global insurance.
                        </p>
                        <div class="flex items-center gap-4 pt-4">
                            <div class="flex -space-x-3">
                                <div class="h-10 w-10 rounded-full border-2 border-slate-900 bg-slate-700"></div>
                                <div class="h-10 w-10 rounded-full border-2 border-slate-900 bg-slate-600"></div>
                                <div
                                    class="h-10 w-10 rounded-full border-2 border-slate-900 bg-slate-500 flex items-center justify-center text-xs font-medium">
                                    +2k</div>
                            </div>
                            <div class="text-sm font-medium text-slate-300">
                                Trusted by industry leaders worldwide
                            </div>
                        </div>
                    </div>
                    <div class="flex justify-between items-end text-xs text-slate-400 font-medium">
                        <p>© 2024 NIC Platform</p>
                        <div class="flex gap-4">
                            <a class="hover:text-white transition-colors" href="#">Privacy</a>
                            <a class="hover:text-white transition-colors" href="#">Terms</a>
                        </div>
                    </div>
                </div>
            </div>
            <div
                class="w-full md:w-1/2 flex items-center justify-center p-8 md:p-12 lg:p-16 bg-white dark:bg-slate-900">
                <div class="w-full max-w-md space-y-8">
                    <div class="flex items-center justify-between mb-4">
                        <a href="allhomepage.jsp"
                            class="inline-flex items-center gap-1 text-sm font-medium text-slate-500 hover:text-primary transition-colors">
                            <span class="material-symbols-outlined text-lg">arrow_back</span>
                            Back to Home
                        </a>
                    </div>
                    <div class="text-center md:text-left">
                        <h2 class="text-2xl md:text-3xl font-bold tracking-tight text-slate-900 dark:text-white">Welcome
                            back</h2>
                        <p class="mt-2 text-sm text-slate-600 dark:text-slate-400">
                            Please enter your credentials to access the secure portal.
                        </p>
                    </div>

                    <% if (request.getParameter("error") !=null) { %>
                        <div class="p-4 mb-4 text-sm text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 flex items-center gap-2"
                            role="alert">
                            <span class="material-symbols-outlined text-xl">error</span>
                            <span class="font-medium">Authentication failed!</span> Please check your credentials and
                            try again.
                        </div>
                        <% } %>

                            <form action="<%= request.getContextPath() %>/login" class="space-y-6" method="POST">
                                <div>
                                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300"
                                        for="email">Email address</label>
                                    <div class="relative mt-2">
                                        <div
                                            class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="material-symbols-outlined text-slate-400 text-xl">mail</span>
                                        </div>
                                        <input autocomplete="email"
                                            class="block w-full rounded-lg border-0 py-3 pl-10 text-slate-900 ring-1 ring-inset ring-slate-300 placeholder:text-slate-400 focus:ring-2 focus:ring-inset focus:ring-primary sm:text-sm sm:leading-6 dark:bg-slate-800 dark:text-white dark:ring-slate-700 dark:placeholder:text-slate-500"
                                            id="email" name="email" placeholder="name@company.com" required=""
                                            type="email" />
                                    </div>
                                </div>
                                <div>
                                    <div class="flex items-center justify-between">
                                        <label class="block text-sm font-medium text-slate-700 dark:text-slate-300"
                                            for="password">Password</label>
                                        <div class="text-sm">
                                            <a class="font-medium text-primary hover:text-primary-dark" href="#">Forgot
                                                password?</a>
                                        </div>
                                    </div>
                                    <div class="relative mt-2">
                                        <div
                                            class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                                            <span class="material-symbols-outlined text-slate-400 text-xl">lock</span>
                                        </div>
                                        <input autocomplete="current-password"
                                            class="block w-full rounded-lg border-0 py-3 pl-10 text-slate-900 ring-1 ring-inset ring-slate-300 placeholder:text-slate-400 focus:ring-2 focus:ring-inset focus:ring-primary sm:text-sm sm:leading-6 dark:bg-slate-800 dark:text-white dark:ring-slate-700 dark:placeholder:text-slate-500"
                                            id="password" name="password" placeholder="••••••••" required=""
                                            type="password" />
                                    </div>
                                </div>
                                <div>
                                    <button
                                        class="flex w-full justify-center rounded-lg bg-primary px-3 py-3 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-primary-dark focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary transition-all"
                                        type="submit">
                                        Sign In
                                    </button>
                                </div>
                            </form>
                            <div class="relative">
                                <div aria-hidden="true" class="absolute inset-0 flex items-center">
                                    <div class="w-full border-t border-slate-200 dark:border-slate-800"></div>
                                </div>
                                <div class="relative flex justify-center text-sm font-medium leading-6">
                                    <span class="bg-white px-6 text-slate-500 dark:bg-slate-900 dark:text-slate-400">Or
                                        continue with</span>
                                </div>
                            </div>
                            <div>
                                <a class="flex w-full items-center justify-center gap-3 rounded-lg border border-slate-200 bg-white px-3 py-3 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-300 transition-all dark:bg-slate-800 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-700"
                                    href="#">
                                    <span class="material-symbols-outlined text-xl">key</span>
                                    <span class="text-sm font-semibold">Single Sign-On (SSO)</span>
                                </a>
                            </div>

                            <div class="text-center pt-4">
                                <p class="text-sm text-slate-600 dark:text-slate-400">
                                    New to NIC?
                                    <a href="registercustomer.jsp"
                                        class="font-bold text-primary hover:underline ml-1">Create an account</a>
                                </p>
                            </div>
                            <p class="text-center text-xs text-slate-500 dark:text-slate-500 mt-8">
                                By signing in, you agree to our <a class="font-medium text-primary hover:underline"
                                    href="#">Terms of Service</a> and <a
                                    class="font-medium text-primary hover:underline" href="#">Privacy Policy</a>.
                                <br />Protected by reCAPTCHA.
                            </p>
                </div>
            </div>
        </div>

    </body>

    </html>