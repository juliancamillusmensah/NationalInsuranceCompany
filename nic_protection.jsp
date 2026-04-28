<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Policyholder Protection | NIC Ghana</title>
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
                        fontFamily: {
                            "display": ["Inter", "sans-serif"]
                        },
                    },
                },
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; scroll-behavior: smooth; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        </style>
    </head>

    <body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
        <div class="relative flex min-h-screen flex-col">
            <jsp:include page="common/public_header.jsp" />

            <main class="flex-grow">
                <!-- Hero -->
                <section class="py-20 bg-emerald-600 text-white relative overflow-hidden">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
                        <div class="max-w-3xl">
                            <h1 class="text-4xl font-black tracking-tight sm:text-6xl mb-6">Policyholder <span class="text-emerald-200 italic">Protection.</span></h1>
                            <p class="text-xl text-emerald-50 leading-relaxed">
                                Our primary mandate is your safety. The NIC provides multiple layers of protection to ensure that every policyholder and accident victim is treated fairly and compensated justly.
                            </p>
                        </div>
                    </div>
                    <div class="absolute right-0 bottom-0 opacity-10 pointer-events-none">
                        <span class="material-symbols-outlined text-[30rem]">shield_with_heart</span>
                    </div>
                </section>

                <!-- Compensation Fund Section -->
                <section id="fund" class="py-24 border-b border-slate-100 dark:border-slate-800">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                            <div>
                                <div class="inline-flex items-center gap-2 rounded-full bg-emerald-100 text-emerald-600 px-4 py-1 text-sm font-black mb-6">
                                    ESTABLISHED 1996
                                </div>
                                <h2 class="text-4xl font-black mb-6">Motor Compensation Fund</h2>
                                <p class="text-lg text-slate-600 dark:text-slate-400 leading-relaxed mb-8">
                                    The Fund was set up by the NIC in conjunction with insurance companies to compensate anybody who has been physically injured by a hit-and-run driver or an uninsured motorist.
                                </p>
                                <ul class="space-y-6">
                                    <li class="flex gap-4">
                                        <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600">
                                            <span class="material-symbols-outlined">how_to_reg</span>
                                        </div>
                                        <div>
                                            <p class="font-bold">Eligibility</p>
                                            <p class="text-sm text-slate-500">Available to victims injured after 1996 who cannot obtain compensation from an insurance company.</p>
                                        </div>
                                    </li>
                                    <li class="flex gap-4">
                                        <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600">
                                            <span class="material-symbols-outlined">assignment</span>
                                        </div>
                                        <div>
                                            <p class="font-bold">Requirements</p>
                                            <p class="text-sm text-slate-500">Police report, medical reports, and two passport-sized photographs.</p>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <div class="bg-slate-100 dark:bg-slate-800 rounded-[3rem] p-12 relative overflow-hidden">
                                <span class="material-symbols-outlined text-[10rem] text-emerald-200/50 absolute -right-10 -bottom-10">medical_services</span>
                                <h4 class="text-2xl font-black mb-6">How to Apply</h4>
                                <ol class="space-y-6 relative z-10 text-slate-700 dark:text-slate-300">
                                    <li class="flex gap-4">
                                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-500 text-white text-[10px] font-black">1</span>
                                        <p>Report the accident to the nearest Police Station.</p>
                                    </li>
                                    <li class="flex gap-4">
                                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-500 text-white text-[10px] font-black">2</span>
                                        <p>Obtain a police report and medical treatment records.</p>
                                    </li>
                                    <li class="flex gap-4">
                                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-500 text-white text-[10px] font-black">3</span>
                                        <p>Submit a formal application to any NIC office near you.</p>
                                    </li>
                                </ol>
                                <a href="static/docs/Claims_Form.pdf" download="Claims_Form.pdf" class="block text-center mt-10 w-full py-4 rounded-2xl bg-emerald-600 text-white font-black hover:bg-emerald-700 transition-all">Download Claims Form</a>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Grievances Section -->
                <section id="grievance" class="py-24 bg-white dark:bg-slate-900 border-b border-slate-100 dark:border-slate-800">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="text-center max-w-3xl mx-auto mb-20">
                            <h2 class="text-4xl font-black mb-6">Grievances & Complaints</h2>
                            <p class="text-lg text-slate-600 dark:text-slate-400">If you have a dispute with an insurance company or intermediary, the NIC is here to mediate and ensure justice.</p>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                            <div class="p-10 rounded-[2.5rem] bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-800">
                                <h3 class="text-2xl font-black mb-6">Formal Complaints</h3>
                                <p class="text-slate-600 dark:text-slate-400 mb-8">Write a formal letter addressed to the **Commissioner of Insurance**. The petition should state the reasons for the complaint and provide copies of policy documents.</p>
                                <div class="space-y-4">
                                    <div class="flex items-center gap-4 p-4 rounded-xl bg-white dark:bg-slate-900 shadow-sm">
                                        <span class="material-symbols-outlined text-primary">mail</span>
                                        <span class="text-sm font-bold">Insurance House, Accra</span>
                                    </div>
                                    <div class="flex items-center gap-4 p-4 rounded-xl bg-white dark:bg-slate-900 shadow-sm">
                                        <span class="material-symbols-outlined text-primary">phone_in_talk</span>
                                        <span class="text-sm font-bold">+233 (0) 302 238 301</span>
                                    </div>
                                </div>
                            </div>
                            <!-- Report Fraud -->
                            <div id="fraud" class="p-10 rounded-[2.5rem] bg-slate-900 text-white shadow-2xl relative overflow-hidden">
                                <div class="relative z-10">
                                    <h3 class="text-2xl font-black mb-6 text-amber-500">Report Insurance Fraud</h3>
                                    <p class="text-slate-300 mb-8 leading-relaxed">Protect our industry by reporting unauthorized businesses, fake insurance certificates, or unethical agent conduct. All reports are handled with the highest confidentiality.</p>
                                    <form class="space-y-4">
                                        <input type="text" placeholder="Subject of Report" class="w-full bg-white/10 border-white/20 rounded-xl px-4 py-3 placeholder:text-white/40 focus:ring-amber-500">
                                        <textarea rows="4" placeholder="Brief description of the activity..." class="w-full bg-white/10 border-white/20 rounded-xl px-4 py-3 placeholder:text-white/40 focus:ring-amber-500"></textarea>
                                        <button type="submit" class="w-full py-4 rounded-xl bg-amber-500 text-slate-900 font-black hover:bg-amber-400 transition-all">Submit Secure Report</button>
                                    </form>
                                </div>
                                <span class="material-symbols-outlined text-[10rem] text-white/5 absolute -right-5 -bottom-5">security</span>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <jsp:include page="common/public_footer.jsp" />
        </div>
    </body>
</html>
