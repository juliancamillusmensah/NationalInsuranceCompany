<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>NIC Ghana | National Insurance Commission Official Portal</title>
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
                            "display": ["Inter", "sans-serif"]
                        },
                    },
                },
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        </style>
    </head>

    <body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
        <div class="relative flex min-h-screen flex-col">
            <jsp:include page="common/public_header.jsp" />

            <main class="flex-grow">
                <section class="relative overflow-hidden pt-12 lg:pt-20 pb-20 lg:pb-32">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="grid grid-cols-1 gap-12 lg:grid-cols-2 lg:items-center">
                            <div class="z-10 flex flex-col gap-8">
                                <div class="inline-flex items-center gap-2 rounded-full bg-primary/10 px-3 py-1 text-sm font-medium text-primary w-fit">
                                    <span class="relative flex h-2 w-2">
                                        <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-primary opacity-75"></span>
                                        <span class="relative inline-flex h-2 w-2 rounded-full bg-primary"></span>
                                    </span>
                                    Professionalism & Compliance
                                </div>
                                <h1 class="text-4xl font-black leading-tight tracking-tight text-slate-900 dark:text-white sm:text-5xl lg:text-7xl">
                                    Regulating for <span class="text-primary italic">Safety & Soundness.</span>
                                </h1>
                                <p class="text-lg leading-relaxed text-slate-600 dark:text-slate-400 max-w-xl">
                                    Official portal of the National Insurance Commission (NIC) Ghana. Empowering the industry through effective supervision and policyholder protection under <b>Insurance Act 2021 (Act 1061).</b>
                                </p>
                                <div class="flex flex-wrap gap-4">
                                    <a href="allloginpage.jsp"
                                        class="rounded-xl bg-primary px-8 py-4 text-base font-bold text-white shadow-lg shadow-primary/25 hover:bg-primary/90 transition-all flex items-center gap-2 group">
                                        Access Portal
                                        <span class="material-symbols-outlined group-hover:translate-x-1 transition-transform">arrow_forward</span>
                                    </a>
                                    <a href="public_publications.jsp"
                                        class="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-8 py-4 text-base font-bold text-slate-900 dark:text-white hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                                        View Publications
                                    </a>
                                </div>
                            </div>
                            <div class="relative">
                                <div class="aspect-square w-full rounded-[4rem] bg-slate-200 dark:bg-slate-800 bg-cover bg-center shadow-2xl border-8 border-white dark:border-slate-900"
                                    style="background-image: url('nic_ghana_hero_1776075271111.png');">
                                </div>
                                <div class="absolute -bottom-6 -left-6 rounded-[2rem] bg-white dark:bg-slate-900 p-8 shadow-2xl border border-slate-100 dark:border-slate-800 hidden md:block">
                                    <div class="flex items-center gap-4">
                                        <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-primary text-white">
                                            <span class="material-symbols-outlined">verified</span>
                                        </div>
                                        <div>
                                            <p class="text-sm font-black text-slate-900 dark:text-white">ACT 1061</p>
                                            <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest">Industry Standard</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="bg-slate-50 dark:bg-slate-900/50 py-24">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="mb-20 text-center max-w-4xl mx-auto">
                            <h2 class="text-4xl font-black tracking-tight text-slate-900 dark:text-white sm:text-5xl">Ghana's Unified Insurance Ecosystem</h2>
                            <p class="mt-6 text-xl text-slate-600 dark:text-slate-400 leading-relaxed">The NIC Ghana portal connects every market stakeholder through a secure, regulatory-first infrastructure. From licensing to claims, we ensure transparency and trust in every transaction.</p>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-10">
                            <!-- Insurers & Reinsurers -->
                            <div class="flex flex-col rounded-[3rem] bg-white dark:bg-slate-900 overflow-hidden shadow-2xl shadow-slate-200/50 border border-slate-100 group">
                                <div class="h-64 bg-cover bg-center group-hover:scale-105 transition-transform duration-700"
                                    style="background-image: url('stakeholder_insurers_1776075295179.png');">
                                </div>
                                <div class="p-10">
                                    <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-blue-100 text-blue-600 mb-6">
                                        <span class="material-symbols-outlined text-2xl">corporate_fare</span>
                                    </div>
                                    <h3 class="text-2xl font-black text-slate-900 dark:text-white">Insurers & Reinsurers</h3>
                                    <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                                        Empowering regulated entities with tools for solvency monitoring, quarterly reporting, and automated license renewals under the 2021 Act.
                                    </p>
                                    <ul class="mt-8 space-y-4 text-sm font-bold text-slate-900 dark:text-slate-300">
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary">check_circle</span> Solvency & Financial Filing</li>
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary">check_circle</span> Regulatory Fee Settlement</li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Intermediaries -->
                            <div class="flex flex-col rounded-[3rem] bg-white dark:bg-slate-900 overflow-hidden shadow-2xl shadow-slate-200/50 border border-slate-100 group">
                                <div class="h-64 bg-cover bg-center group-hover:scale-105 transition-transform duration-700"
                                    style="background-image: url('stakeholder_intermediaries_1776075317576.png');">
                                </div>
                                <div class="p-10">
                                    <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-indigo-100 text-indigo-600 mb-6">
                                        <span class="material-symbols-outlined text-2xl">handshake</span>
                                    </div>
                                    <h3 class="text-2xl font-black text-slate-900 dark:text-white">Market Intermediaries</h3>
                                    <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                                        Standardizing conduct for brokers, agents, and adjusters. Access licensing registries and professional training requirements.
                                    </p>
                                    <ul class="mt-8 space-y-4 text-sm font-bold text-slate-900 dark:text-slate-300">
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary">check_circle</span> Licensing Portal for Brokers</li>
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-primary">check_circle</span> Professional Conduct Monitoring</li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Policyholders -->
                            <div class="flex flex-col rounded-[3rem] bg-white dark:bg-slate-900 overflow-hidden shadow-2xl shadow-slate-200/50 border border-slate-100 group">
                                <div class="h-64 bg-cover bg-center group-hover:scale-105 transition-transform duration-700"
                                    style="background-image: url('stakeholder_policyholders_1776075336756.png');">
                                </div>
                                <div class="p-10">
                                    <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-100 text-emerald-600 mb-6">
                                        <span class="material-symbols-outlined text-2xl">family_restroom</span>
                                    </div>
                                    <h3 class="text-2xl font-black text-slate-900 dark:text-white">Public & Policyholders</h3>
                                    <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                                        Our core priority. Access the Motor Insurance Database (MID), file grievances, and learn about the Motor Compensation Fund.
                                    </p>
                                    <ul class="mt-8 space-y-4 text-sm font-bold text-slate-900 dark:text-slate-300">
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-emerald-500">check_circle</span> Grievances & Complaints Pathway</li>
                                        <li class="flex items-center gap-3"><span class="material-symbols-outlined text-emerald-500">check_circle</span> Motor Insurance Verification</li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Regulation -->
                            <div class="flex flex-col rounded-[3rem] bg-primary p-10 shadow-2xl shadow-primary/30 text-white relative overflow-hidden group">
                                <div class="absolute -right-10 -bottom-10 opacity-10 group-hover:rotate-12 transition-transform duration-700">
                                    <span class="material-symbols-outlined text-[15rem]">policy</span>
                                </div>
                                <div class="relative z-10 flex flex-col h-full">
                                    <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/20 backdrop-blur-md text-white mb-6">
                                        <span class="material-symbols-outlined text-3xl">admin_panel_settings</span>
                                    </div>
                                    <h3 class="text-3xl font-black">Commission Supervision</h3>
                                    <p class="mt-4 text-white/80 leading-relaxed text-lg">
                                        Full market oversight for NIC Ghana staff. Manage licensing boards, conduct field audits, and monitor market-wide solvency from a unified hub.
                                    </p>
                                    <div class="mt-auto pt-10">
                                        <a href="allloginpage.jsp" class="inline-flex items-center gap-3 bg-white text-primary px-8 py-4 rounded-2xl font-black hover:bg-slate-50 transition-colors">
                                            NIC Staff Login
                                            <span class="material-symbols-outlined">chevron_right</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <section class="py-24">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="grid grid-cols-1 gap-16 lg:grid-cols-2 lg:items-center">
                            <div>
                                <h2 class="text-4xl font-black tracking-tight text-slate-900 dark:text-white sm:text-5xl">
                                    Statutory Excellence. Regulatory Precision.
                                </h2>
                                <p class="mt-6 text-xl text-slate-600 dark:text-slate-400 leading-relaxed">
                                    Built to ensure the safety and soundness of the industry, our platform facilitates high-volume monitoring and actionable intelligence for the Commission.
                                </p>
                                <div class="mt-12 space-y-10">
                                    <div class="flex gap-6">
                                        <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                                            <span class="material-symbols-outlined text-2xl">security</span>
                                        </div>
                                        <div>
                                            <h4 class="text-xl font-black text-slate-900 dark:text-white">IAIS Core Standards</h4>
                                            <p class="mt-2 text-slate-600 dark:text-slate-400">Strict adherence to the International Association of Insurance Supervisors principles for global-standard oversight.</p>
                                        </div>
                                    </div>
                                    <div class="flex gap-6">
                                        <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                                            <span class="material-symbols-outlined text-2xl">database</span>
                                        </div>
                                        <div>
                                            <h4 class="text-xl font-black text-slate-900 dark:text-white">Motor Insurance Database</h4>
                                            <p class="mt-2 text-slate-600 dark:text-slate-400">Integrated MID verification ensuring that every vehicle on Ghana's roads is covered by a valid policy.</p>
                                        </div>
                                    </div>
                                    <div class="flex gap-6">
                                        <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                                            <span class="material-symbols-outlined text-2xl">account_balance_wallet</span>
                                        </div>
                                        <div>
                                            <h4 class="text-xl font-black text-slate-900 dark:text-white">Statutory Fund Oversight</h4>
                                            <p class="mt-2 text-slate-600 dark:text-slate-400">Real-time monitoring of the Motor Compensation Fund and other statutory reserves to protect the vulnerable.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="relative">
                                <div class="grid grid-cols-2 gap-6 ring-1 ring-slate-200 dark:ring-slate-800 p-6 rounded-[3rem] bg-white dark:bg-slate-900 shadow-2xl">
                                    <div class="aspect-[4/5] rounded-[2rem] bg-slate-200 dark:bg-slate-800 bg-cover bg-center mt-12 shadow-lg"
                                        style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCdcTTNP3T4lJIeqN5C8e3tiKgoupHi27PeDLvfWnw-BT6Crao5gpHjLQhDiUZy15_U8syfCG8ZgaImeGUGvxEu2UsD2k67Qwx55yBpRfSCebgiJVnnqlZMX54kdnYdytTUaIOkSWdAvd4WRnOgnn0w6733WyoPv5ZKlFctYVHDmjznwRPilreS8SSL8t8gIBi7EXl2PGyFdfOSWXoG1weCbd2ZlJtEe3eC3eeh7xL00x-os3dU_oGj8Px-d6c86GIBJr-x1Cgpu2c');">
                                    </div>
                                    <div class="aspect-[4/5] rounded-[2rem] bg-slate-200 dark:bg-slate-800 bg-cover bg-center shadow-lg"
                                        style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuDXJ9feEGts83g1Z-JdFPI8wojSskjEtIgQaiF6YllwAnq8KIH438Yf-tdG3n1jJ-Vi1dQE0jIsNDMDs_ZjdhbrgiRjyTi1cqDFU8cij5x9kapXdRVlLzd-2fuIvHO_6K0NOHcNdUlpNODN3vKdsIDMPO-A9FtYIkO_GB85pXbZsYojagxpp_8ijhFOs6kmsxe6KfISuMkVBJH6uEO_NrmrU1n-ecfs3JbiQYtZuOIMgfD_1xIdE2-z87sw68CDW_omqTIJ2LgfF0Y');">
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