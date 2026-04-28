<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html class="light" lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Join NIC | Secure Your Future</title>
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
                            "background-light": "#f6f6f8",
                            "background-dark": "#101622",
                        },
                        fontFamily: {
                            "display": ["Inter"]
                        },
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
            <!-- Left Panel: Branding & Art -->
            <div
                class="hidden lg:flex lg:w-1/3 bg-primary text-white p-12 flex-col justify-between relative overflow-hidden bg-pattern shrink-0">
                <div class="z-10">
                    <div class="flex items-center gap-3 mb-12">
                        <div class="bg-white text-primary p-2 rounded-lg shadow-lg">
                            <span class="material-symbols-outlined text-3xl font-bold">shield</span>
                        </div>
                        <h1 class="text-2xl font-black tracking-tight">NIC</h1>
                    </div>
                    <h2 class="text-5xl font-extrabold leading-tight mb-6">Secure Your Future with NIC.</h2>
                    <p class="text-primary-100 text-lg opacity-90 leading-relaxed">Join thousands of protected
                        customers. It only takes a minute to get started with our comprehensive coverage plans.</p>
                </div>
                <div class="z-10">
                    <div class="flex items-center gap-4 mb-8">
                        <div class="flex -space-x-3">
                            <img class="h-10 w-10 rounded-full border-2 border-primary object-cover"
                                src="https://api.dicebear.com/7.x/avataaars/svg?seed=Felix" alt="U1" />
                            <img class="h-10 w-10 rounded-full border-2 border-primary object-cover"
                                src="https://api.dicebear.com/7.x/avataaars/svg?seed=Anya" alt="U2" />
                            <img class="h-10 w-10 rounded-full border-2 border-primary object-cover"
                                src="https://api.dicebear.com/7.x/avataaars/svg?seed=Milo" alt="U3" />
                        </div>
                        <p class="text-sm font-medium">Over 50k+ Trust Us</p>
                    </div>
                    <div class="text-xs opacity-70">
                        © 2024 NIC Inc. All rights reserved.
                    </div>
                </div>
                <div class="absolute -bottom-24 -right-24 h-96 w-96 bg-white/10 rounded-full blur-3xl"></div>
            </div>

            <!-- Right Side: Registration Form -->
            <div
                class="flex-1 flex flex-col items-center justify-center p-6 sm:p-12 lg:p-20 bg-white dark:bg-slate-900 relative">
                <div class="w-full max-w-[520px] relative z-10">
                    <div class="flex lg:hidden items-center justify-between mb-8">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-primary text-4xl">shield</span>
                            <h1 class="text-2xl font-black text-slate-900 dark:text-white uppercase tracking-tighter">
                                NIC</h1>
                        </div>
                        <a href="allloginpage.jsp" class="text-sm font-bold text-primary hover:underline">Log In</a>
                    </div>
                    <div class="flex items-center justify-between mb-4">
                        <a href="allhomepage.jsp"
                            class="inline-flex items-center gap-1 text-sm font-medium text-slate-500 hover:text-primary transition-colors">
                            <span class="material-symbols-outlined text-lg">arrow_back</span>
                            Back to Home
                        </a>
                        <a href="allloginpage.jsp"
                            class="hidden lg:inline-flex text-sm font-bold text-primary hover:underline">Log In</a>
                    </div>
                    <div class="mb-10">
                        <h3 class="text-3xl lg:text-4xl font-black text-slate-900 dark:text-white mb-2 tracking-tight">
                            Create your account</h3>
                        <p class="text-slate-500 dark:text-slate-400 font-medium">Enter your details to get started with
                            your
                            protection plan.</p>
                    </div>

                    <% if (request.getParameter("error") !=null) { %>
                        <div
                            class="mb-6 p-4 bg-red-50 dark:bg-red-900/10 border border-red-100 dark:border-red-900/20 rounded-xl flex items-center gap-3 text-red-600 dark:text-red-400 text-sm font-semibold">
                            <span class="material-symbols-outlined">error</span>
                            <%= "passwords_mismatch" .equals(request.getParameter("error")) ? "Passwords do not match."
                                : "Registration failed. Please try again." %>
                        </div>
                        <% } %>

                            <form action="<%= request.getContextPath() %>/register" method="POST" class="space-y-6">
                                <div class="space-y-4">
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-sm font-semibold text-slate-700 dark:text-slate-300">Full
                                            Name</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">person</span>
                                            <input name="full_name"
                                                class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                placeholder="John Doe" type="text" required />
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <div class="flex flex-col gap-1.5">
                                            <label
                                                class="text-sm font-semibold text-slate-700 dark:text-slate-300">Email
                                                Address</label>
                                            <div class="relative">
                                                <span
                                                    class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">mail</span>
                                                <input name="email"
                                                    class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                    placeholder="john@example.com" type="email" required />
                                            </div>
                                        </div>
                                        <div class="flex flex-col gap-1.5">
                                            <label
                                                class="text-sm font-semibold text-slate-700 dark:text-slate-300">Phone
                                                Number</label>
                                            <div class="relative">
                                                <span
                                                    class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">call</span>
                                                <input name="phone"
                                                    class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                    placeholder="(555) 000-0000" type="tel" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-y-4 pt-4 border-t border-slate-100 dark:border-slate-800">
                                    <div class="flex items-center gap-2 mb-2">
                                        <span class="material-symbols-outlined text-primary text-sm">lock</span>
                                        <span class="text-xs font-bold uppercase tracking-wider text-slate-400">Security
                                            Details</span>
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-sm font-semibold text-slate-700 dark:text-slate-300">Create
                                            Password</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">key</span>
                                            <input name="password"
                                                class="w-full pl-10 pr-12 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                placeholder="Min. 8 characters" type="password" required />
                                        </div>
                                    </div>
                                    <div class="flex flex-col gap-1.5">
                                        <label class="text-sm font-semibold text-slate-700 dark:text-slate-300">Confirm
                                            Password</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xl">lock_reset</span>
                                            <input name="confirm_password"
                                                class="w-full pl-10 pr-4 py-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all text-slate-900 dark:text-white"
                                                placeholder="Repeat your password" type="password" required />
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <input class="mt-1 h-4 w-4 rounded border-slate-300 text-primary focus:ring-primary"
                                        id="terms" type="checkbox" required />
                                    <label class="text-sm text-slate-500 dark:text-slate-400 leading-tight" for="terms">
                                        I agree to the <a class="text-primary hover:underline font-medium"
                                            href="#">Terms of Service</a> and <a
                                            class="text-primary hover:underline font-medium" href="#">Privacy
                                            Policy</a>.
                                    </label>
                                </div>
                                <button
                                    class="w-full bg-primary hover:bg-blue-700 text-white font-bold py-4 px-6 rounded-lg shadow-lg shadow-primary/20 transition-all transform hover:-translate-y-0.5 active:translate-y-0 flex items-center justify-center gap-2"
                                    type="submit">
                                    Create My Account
                                    <span class="material-symbols-outlined text-lg">arrow_forward</span>
                                </button>
                                <p class="text-center text-slate-600 dark:text-slate-400 text-sm mt-6">
                                    Already have an account?
                                    <a class="text-primary font-bold hover:underline ml-1" href="allloginpage.jsp">Log
                                        in
                                        here</a>
                                </p>
                            </form>
                </div>
            </div>
        </div>
    </body>

    </html>