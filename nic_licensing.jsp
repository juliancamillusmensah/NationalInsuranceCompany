<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Licensing Guidelines | NIC Ghana</title>
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
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
            
            .accordion-content { max-height: 0; overflow: hidden; transition: max-height 0.4s cubic-bezier(0, 1, 0, 1); }
            .accordion-item.active .accordion-content { max-height: 2000px; transition: max-height 0.4s ease-in-out; }
            .accordion-item.active .chevron { transform: rotate(180deg); }
            
            .checklist-item input:checked + label { text-decoration: line-through; opacity: 0.5; }
        </style>
    </head>

    <body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
        <div class="relative flex min-h-screen flex-col">
            <jsp:include page="common/public_header.jsp" />

            <main class="flex-grow">
                <section class="py-20 lg:py-32 bg-white dark:bg-slate-900">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="max-w-3xl">
                            <h1 class="text-4xl font-black tracking-tight sm:text-6xl text-slate-900 dark:text-white">Licensing <span class="text-primary italic">Guidelines.</span></h1>
                            <p class="mt-6 text-xl text-slate-600 dark:text-slate-400 leading-relaxed font-medium">
                                Our licensing framework ensures that only financially sound and ethically managed entities operate within the Ghana insurance market.
                            </p>

                            <!-- Modern Search & Indicator -->
                            <div class="mt-12 flex flex-col md:flex-row gap-4 items-center bg-slate-50 dark:bg-slate-800/50 p-3 rounded-[2rem] border border-slate-100 dark:border-slate-800">
                                <div class="relative flex-grow w-full">
                                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                    <input type="text" id="guidelineSearch" onkeyup="filterGuidelines()" 
                                        placeholder="Search licensing requirements or documents..." 
                                        class="w-full pl-12 pr-4 py-4 bg-transparent border-none focus:ring-0 text-sm font-bold placeholder:text-slate-400">
                                </div>
                                <div class="flex items-center gap-3 px-6 py-3 bg-white dark:bg-slate-900 rounded-2xl shadow-sm shrink-0">
                                    <div class="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></div>
                                    <span class="text-[10px] font-black uppercase tracking-widest text-slate-400">Live Guidance Map</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-16 space-y-6" id="guidelineList">
                            <!-- Section: Insurers & Reinsurers -->
                            <div class="guideline-section accordion-item bg-white dark:bg-slate-900 rounded-[2.5rem] border border-slate-100 dark:border-slate-800 shadow-xl overflow-hidden active" data-title="Insurers Reinsurers Capital Business Plan">
                                <button onclick="toggleAccordion(this)" class="w-full p-8 lg:p-10 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-all text-left">
                                    <div class="flex items-center gap-6">
                                        <div class="h-14 w-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary">
                                            <span class="material-symbols-outlined text-3xl">corporate_fare</span>
                                        </div>
                                        <div>
                                            <h3 class="text-2xl font-black text-slate-900 dark:text-white">Insurers & Reinsurers</h3>
                                            <p class="text-sm font-bold text-slate-400 uppercase tracking-widest mt-1">Foundational Compliance</p>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-slate-400 chevron transition-transform duration-300">expand_more</span>
                                </button>
                                <div class="accordion-content">
                                    <div class="p-8 lg:p-10 border-t border-slate-100 dark:border-slate-800 bg-slate-50/30 dark:bg-slate-800/20">
                                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
                                            <div>
                                                <h4 class="text-lg font-black mb-6 flex items-center gap-2">
                                                    <span class="material-symbols-outlined text-primary">list_alt</span>
                                                    Detailed Requirements
                                                </h4>
                                                <div class="space-y-6">
                                                    <div class="p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm">
                                                        <p class="font-black text-slate-900 dark:text-white mb-2">Minimum Stated Capital</p>
                                                        <p class="text-sm text-slate-500 leading-relaxed">Companies must maintain a minimum stated capital of <span class="text-primary font-bold">GHS 50,000,000</span> (Fifty Million Ghana Cedis) for new licenses.</p>
                                                    </div>
                                                    <div class="p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm">
                                                        <p class="font-black text-slate-900 dark:text-white mb-2">Technical Feasibility</p>
                                                        <p class="text-sm text-slate-500 leading-relaxed">Submission of a 3-year business plan including projected solvency and liquidity ratios.</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="bg-white dark:bg-slate-900 rounded-3xl p-8 border border-slate-100 dark:border-slate-800 shadow-inner">
                                                <h4 class="text-lg font-black mb-6">Pre-Application Checklist</h4>
                                                <div class="space-y-4">
                                                    <div class="checklist-item flex items-center gap-4">
                                                        <input type="checkbox" id="check-cap" class="h-6 w-6 rounded-lg border-slate-300 text-primary focus:ring-primary">
                                                        <label for="check-cap" class="text-sm font-bold text-slate-600 dark:text-slate-400 cursor-pointer">Minimum Stated Capital Verified</label>
                                                    </div>
                                                    <div class="checklist-item flex items-center gap-4">
                                                        <input type="checkbox" id="check-biz" class="h-6 w-6 rounded-lg border-slate-300 text-primary focus:ring-primary">
                                                        <label for="check-biz" class="text-sm font-bold text-slate-600 dark:text-slate-400 cursor-pointer">3-Year Business Plan Ready</label>
                                                    </div>
                                                    <div class="checklist-item flex items-center gap-4">
                                                        <input type="checkbox" id="check-fit" class="h-6 w-6 rounded-lg border-slate-300 text-primary focus:ring-primary">
                                                        <label for="check-fit" class="text-sm font-bold text-slate-600 dark:text-slate-400 cursor-pointer">Fit & Proper Forms (Directors)</label>
                                                    </div>
                                                    <div class="checklist-item flex items-center gap-4">
                                                        <input type="checkbox" id="check-dep" class="h-6 w-6 rounded-lg border-slate-300 text-primary focus:ring-primary">
                                                        <label for="check-dep" class="text-sm font-bold text-slate-600 dark:text-slate-400 cursor-pointer">Statutory Deposit Paid to BoG</label>
                                                    </div>
                                                </div>
                                                <a href="static/docs/Application_Pack.pdf" download="Application_Pack.pdf" class="block text-center w-full mt-8 py-4 rounded-2xl bg-primary text-white font-black hover:scale-105 active:scale-95 transition-all shadow-lg shadow-primary/20">Download Full Application Pack</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Section: Brokers & Intermediaries -->
                            <div class="guideline-section accordion-item bg-white dark:bg-slate-900 rounded-[2.5rem] border border-slate-100 dark:border-slate-800 shadow-xl overflow-hidden" data-title="Brokers Intermediaries Agents Adjustment">
                                <button onclick="toggleAccordion(this)" class="w-full p-8 lg:p-10 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-all text-left">
                                    <div class="flex items-center gap-6">
                                        <div class="h-14 w-14 rounded-2xl bg-emerald-100 dark:bg-emerald-500/10 flex items-center justify-center text-emerald-500">
                                            <span class="material-symbols-outlined text-3xl">handshake</span>
                                        </div>
                                        <div>
                                            <h3 class="text-2xl font-black text-slate-900 dark:text-white">Brokers & Intermediaries</h3>
                                            <p class="text-sm font-bold text-slate-400 uppercase tracking-widest mt-1">Intermediary Compliance</p>
                                        </div>
                                    </div>
                                    <span class="material-symbols-outlined text-slate-400 chevron transition-transform duration-300">expand_more</span>
                                </button>
                                <div class="accordion-content">
                                    <div class="p-8 lg:p-10 border-t border-slate-100 dark:border-slate-800 bg-slate-50/30 dark:bg-slate-800/20">
                                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
                                            <div>
                                                <h4 class="text-lg font-black mb-6">Broker Guidelines</h4>
                                                <div class="space-y-6">
                                                    <div class="p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm">
                                                        <p class="font-black text-slate-900 dark:text-white mb-2">Professional Indemnity</p>
                                                        <p class="text-sm text-slate-500 leading-relaxed">Mandatory Professional Indemnity cover of at least <span class="text-emerald-500 font-bold">GHS 500,000</span> from an NIC approved insurer.</p>
                                                    </div>
                                                    <div class="p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm">
                                                        <p class="font-black text-slate-900 dark:text-white mb-2">Statutory Deposit</p>
                                                        <p class="text-sm text-slate-500 leading-relaxed">Deposit of 10% of stated capital with the Bank of Ghana.</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="bg-white dark:bg-slate-900 rounded-3xl p-8 border border-slate-100 dark:border-slate-800 shadow-inner">
                                                <h4 class="text-lg font-black mb-6">Submission Portal</h4>
                                                <p class="text-sm text-slate-500 mb-8">Brokers are required to submit their annual renewal applications via the NIC Intermediary Portal.</p>
                                                <a href="allloginpage.jsp" class="w-full py-4 rounded-2xl bg-emerald-500 text-white font-black hover:bg-emerald-600 transition-all flex items-center justify-center gap-2">
                                                    <span class="material-symbols-outlined text-sm">open_in_new</span>
                                                    Intermediary Portal
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Empty State for Search -->
                            <div id="noResults" class="hidden py-24 text-center bg-white dark:bg-slate-900 rounded-[3rem] border border-dashed border-slate-200 dark:border-slate-800">
                                <span class="material-symbols-outlined text-6xl text-slate-200 mb-4 font-light">find_in_page</span>
                                <h3 class="text-xl font-bold text-slate-900 dark:text-white">No matches found</h3>
                                <p class="text-slate-500 mt-2">Try searching for "Capital", "Brokers", or "Checklist".</p>
                                <button onclick="resetSearch()" class="mt-8 text-primary font-black text-sm uppercase tracking-widest hover:underline">Clear Search</button>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <jsp:include page="common/public_footer.jsp" />
        </div>

        <script>
            function toggleAccordion(button) {
                const item = button.closest('.accordion-item');
                const isActive = item.classList.contains('active');
                
                // Optional: Close other accordions
                // document.querySelectorAll('.accordion-item').forEach(i => i.classList.remove('active'));
                
                if (isActive) {
                    item.classList.remove('active');
                } else {
                    item.classList.add('active');
                }
            }

            function filterGuidelines() {
                const term = document.getElementById('guidelineSearch').value.toLowerCase();
                const sections = document.querySelectorAll('.guideline-section');
                let foundMatch = false;

                sections.forEach(section => {
                    const searchable = section.getAttribute('data-title').toLowerCase();
                    if (searchable.includes(term)) {
                        section.classList.remove('hidden');
                        foundMatch = true;
                    } else {
                        section.classList.add('hidden');
                    }
                });

                document.getElementById('noResults').classList.toggle('hidden', foundMatch);
            }

            function resetSearch() {
                document.getElementById('guidelineSearch').value = '';
                filterGuidelines();
            }
        </script>
    </body>
</html>
