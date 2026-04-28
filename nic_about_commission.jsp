<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>About Commission | NIC Ghana</title>
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
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        @keyframes fadeUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        .board-card { animation: fadeUp 0.5s ease both; }
        .board-card:nth-child(1) { animation-delay:.05s }
        .board-card:nth-child(2) { animation-delay:.1s }
        .board-card:nth-child(3) { animation-delay:.15s }
        .board-card:nth-child(4) { animation-delay:.2s }
        .board-card:nth-child(5) { animation-delay:.25s }
        .board-card:nth-child(6) { animation-delay:.3s }
        .board-card:nth-child(7) { animation-delay:.35s }
        .avatar-ring { box-shadow: 0 0 0 4px #fff, 0 0 0 6px #e2e8f0; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
<div class="relative flex min-h-screen flex-col">
    <jsp:include page="common/public_header.jsp" />

    <main class="flex-grow">

        <!-- ── Hero: Mission & Vision ───────────────────────── -->
        <section class="bg-slate-900 text-white py-24 relative overflow-hidden">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
                <div class="max-w-3xl">
                    <h1 class="text-4xl font-black tracking-tight sm:text-6xl mb-8">
                        Our Mission &amp; <span class="text-primary italic">Vision.</span>
                    </h1>
                    <div class="space-y-12">
                        <div>
                            <h3 class="text-xs font-black uppercase tracking-[0.3em] text-primary mb-3">The Mission</h3>
                            <p class="text-2xl font-bold leading-relaxed opacity-90">
                                "To protect the interest of policyholders through the effective supervision and regulation of the insurance industry."
                            </p>
                        </div>
                        <div>
                            <h3 class="text-xs font-black uppercase tracking-[0.3em] text-primary mb-3">The Vision</h3>
                            <p class="text-2xl font-bold leading-relaxed opacity-90">
                                "To be a model insurance regulator in Africa."
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="absolute right-[-10%] top-[-10%] opacity-10 pointer-events-none">
                <span class="material-symbols-outlined text-[30rem]">foundation</span>
            </div>
        </section>

        <!-- ── Board of Directors ───────────────────────────── -->
        <section class="py-24 bg-white dark:bg-slate-950">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">

                <!-- Section Header -->
                <div class="mb-16 max-w-2xl">
                    <div class="inline-flex items-center gap-2 bg-primary/10 text-primary text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-full mb-4">
                        <span class="material-symbols-outlined text-sm">groups</span>
                        Inaugurated May 2025
                    </div>
                    <h2 class="text-4xl font-black tracking-tight mb-4">Board of Directors</h2>
                    <p class="text-xl text-slate-600 dark:text-slate-400">
                        The Commission is governed by a board of seasoned professionals — lawyers, financiers, and industry leaders — committed to sound market regulation.
                    </p>
                </div>

                <!-- Board Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">

                    <!-- 1. Chairperson (spans full width treatment on first row) -->
                    <!-- Special featured card for Chairperson -->
                    <div class="board-card sm:col-span-2 lg:col-span-1">
                        <div class="h-full bg-gradient-to-br from-primary to-primary/80 rounded-[2rem] p-7 text-white shadow-2xl shadow-primary/20 relative overflow-hidden group">
                            <div class="absolute top-0 right-0 opacity-10 group-hover:scale-110 transition-transform duration-700 pointer-events-none">
                                <span class="material-symbols-outlined text-[8rem]">star</span>
                            </div>
                            <div class="relative z-10">
                                <div class="h-20 w-20 rounded-2xl bg-white/20 backdrop-blur overflow-hidden flex items-center justify-center mb-5 avatar-ring border-0" style="box-shadow:0 0 0 3px rgba(255,255,255,0.2);">
                                    <img src="static/images/board/board_christopher.png" alt="Mr. Christopher Boadi-Mensah" class="h-full w-full object-cover">
                                </div>
                                <div class="inline-flex items-center gap-1 bg-white/20 text-white text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                    <span class="material-symbols-outlined text-[11px]">workspace_premium</span>
                                    Chairperson
                                </div>
                                <h4 class="text-xl font-black leading-tight">Mr. Christopher Boadi-Mensah</h4>
                                <p class="text-sm text-white/70 font-medium mt-2">Appointed by the Presidency of the Republic of Ghana</p>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Commissioner of Insurance -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-emerald-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="static/images/board/board_abiba.png" alt="Dr. Abiba Zakariah" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-emerald-100 text-emerald-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">shield</span>
                                Commissioner
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Dr. Abiba Zakariah</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Commissioner of Insurance &amp; Executive Board Member</p>
                        </div>
                    </div>

                    <!-- 3. Ministry of Finance -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-indigo-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="static/images/board/board_david.png" alt="Mr. David Klotey Collison" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-indigo-100 text-indigo-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">account_balance</span>
                                Finance Rep.
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Mr. David Klotey Collison</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Coordinating Director, Ministry of Finance</p>
                        </div>
                    </div>

                    <!-- 4. Ghana Bar Association -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-amber-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="static/images/board/board_emmanuel.png" alt="Mr. Emmanuel Amofa" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-amber-100 text-amber-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">gavel</span>
                                Legal Rep.
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Mr. Emmanuel Amofa</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Representative of the Ghana Bar Association</p>
                        </div>
                    </div>

                    <!-- 5. Insurance Industry Trade Bodies -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-teal-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="https://images.unsplash.com/photo-1531384441138-2736e62e0919?q=80&w=300&h=300&auto=format&fit=crop" alt="Mr. Matthew Kwaku Atta Aidoo" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-teal-100 text-teal-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">business</span>
                                Industry Rep.
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Mr. Matthew Kwaku Atta Aidoo</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Representative, Insurance Industry Trade Bodies</p>
                        </div>
                    </div>

                    <!-- 6. MP & Presidential Nominee -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-rose-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?q=80&w=300&h=300&auto=format&fit=crop" alt="Ms. Jean-Marie Formadi" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-rose-100 text-rose-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">how_to_vote</span>
                                Presidential Nominee
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Ms. Jean-Marie Formadi</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Member of Parliament &amp; Presidential Nominee</p>
                        </div>
                    </div>

                    <!-- 7. Presidential Nominee -->
                    <div class="board-card">
                        <div class="h-full bg-background-light dark:bg-slate-900 rounded-[2rem] border border-slate-200 dark:border-slate-800 p-7 shadow-lg hover:shadow-xl transition-all group">
                             <div class="h-16 w-16 rounded-2xl bg-violet-100 overflow-hidden flex items-center justify-center mb-5 group-hover:scale-105 transition-transform">
                                <img src="https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=300&h=300&auto=format&fit=crop" alt="Mr. Simon Akibange Aworigo" class="h-full w-full object-cover">
                            </div>
                            <div class="inline-flex items-center gap-1 bg-violet-100 text-violet-700 text-[9px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full mb-4">
                                <span class="material-symbols-outlined text-[11px]">how_to_vote</span>
                                Presidential Nominee
                            </div>
                            <h4 class="text-lg font-black text-slate-900 dark:text-white leading-tight">Mr. Simon Akibange Aworigo</h4>
                            <p class="text-xs text-slate-500 font-medium mt-2">Presidential Nominee to the Commission Board</p>
                        </div>
                    </div>

                </div>

                <!-- Source note -->
                <p class="text-xs text-slate-400 font-medium flex items-center gap-1.5 mt-4">
                    <span class="material-symbols-outlined text-sm">info</span>
                    Board composition sourced from official NIC Ghana announcements and the Ministry of Finance (Ghana), May 2025.
                </p>
            </div>
        </section>

        <!-- ── Core Values ───────────────────────────────────── -->
        <section class="py-24 bg-background-light dark:bg-background-dark">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="border-t border-slate-200 dark:border-slate-800 pt-24">
                    <h2 class="text-4xl font-black mb-16 text-center">Our Core Values</h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-12">
                        <div class="text-center p-8">
                            <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-primary text-white mx-auto mb-6 shadow-lg shadow-primary/20">
                                <span class="material-symbols-outlined text-3xl">verified_user</span>
                            </div>
                            <h4 class="text-xl font-black mb-4">Integrity</h4>
                            <p class="text-slate-600 dark:text-slate-400">Adhering to the highest ethical and moral standards in all regulatory interactions.</p>
                        </div>
                        <div class="text-center p-8">
                            <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-emerald-500 text-white mx-auto mb-6 shadow-lg shadow-emerald-500/20">
                                <span class="material-symbols-outlined text-3xl">visibility</span>
                            </div>
                            <h4 class="text-xl font-black mb-4">Transparency</h4>
                            <p class="text-slate-600 dark:text-slate-400">Ensuring all commission processes and market data are open to public scrutiny.</p>
                        </div>
                        <div class="text-center p-8">
                            <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-amber-500 text-white mx-auto mb-6 shadow-lg shadow-amber-500/20">
                                <span class="material-symbols-outlined text-3xl">groups</span>
                            </div>
                            <h4 class="text-xl font-black mb-4">Professionalism</h4>
                            <p class="text-slate-600 dark:text-slate-400">A commitment to excellence, technical competence, and industry-leading expertise.</p>
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
