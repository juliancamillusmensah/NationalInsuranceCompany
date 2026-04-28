<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Acts &amp; Regulations | NIC Ghana</title>
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
        .modal-overlay { animation: fadeIn 0.2s ease; }
        .modal-panel  { animation: slideUp 0.25s cubic-bezier(.22,.68,0,1.2); }
        @keyframes fadeIn  { from { opacity:0; }               to { opacity:1; } }
        @keyframes slideUp { from { opacity:0; transform:translateY(28px); } to { opacity:1; transform:translateY(0); } }
        
        .filter-chip.active { @apply bg-primary text-white shadow-lg shadow-primary/20; }
        .reg-card.hidden { display: none !important; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-display">
<div class="relative flex min-h-screen flex-col">
    <jsp:include page="common/public_header.jsp" />

    <main class="flex-grow">
        <!-- Hero -->
        <section class="bg-white dark:bg-slate-900 pt-16 pb-24">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="max-w-3xl">
                        <h1 class="text-4xl font-black tracking-tight text-slate-900 dark:text-white sm:text-6xl">
                            Acts &amp; <span class="text-primary italic">Regulations.</span>
                        </h1>
                        <p class="mt-6 text-xl text-slate-600 dark:text-slate-400 leading-relaxed">
                            Our legal infrastructure is built on the <b>Insurance Act, 2021 (Act 1061)</b>,
                            providing comprehensive powers for the monitoring and control of the insurance industry.
                        </p>
                        
                        <!-- Search & Filter Bar -->
                        <div class="mt-12 flex flex-col md:flex-row gap-4 items-center bg-slate-50 dark:bg-slate-800/50 p-3 rounded-[2rem] border border-slate-100 dark:border-slate-800 shadow-inner">
                            <div class="relative flex-grow w-full">
                                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400">search</span>
                                <input type="text" id="regSearch" onkeyup="filterRegulations()" 
                                    placeholder="Search acts, directives, or guidelines..." 
                                    class="w-full pl-12 pr-4 py-4 bg-transparent border-none focus:ring-0 text-sm font-bold placeholder:text-slate-400">
                            </div>
                            <div class="flex gap-2 p-1 bg-white dark:bg-slate-900 rounded-2xl shadow-sm overflow-x-auto max-w-full">
                                <button onclick="setFilter('all', this)" class="filter-chip active px-5 py-2.5 rounded-xl text-xs font-black transition-all">All</button>
                                <button onclick="setFilter('act', this)" class="filter-chip px-5 py-2.5 rounded-xl text-xs font-black text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">Acts</button>
                                <button onclick="setFilter('directive', this)" class="filter-chip px-5 py-2.5 rounded-xl text-xs font-black text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">Directives</button>
                                <button onclick="setFilter('guideline', this)" class="filter-chip px-5 py-2.5 rounded-xl text-xs font-black text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">Guidelines</button>
                            </div>
                        </div>

                        <div class="mt-6 flex items-center gap-3">
                            <div class="flex h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></div>
                            <span class="text-[10px] font-black uppercase tracking-widest text-slate-400">Official Repository Live Connection</span>
                        </div>
                </div>
            </div>
        </section>

        <!-- Core Assets -->
        <section class="py-24">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">

                    <!-- Act 1061 -->
                    <div class="reg-card p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 transition-all duration-300" data-type="act">
                        <span class="material-symbols-outlined text-4xl text-primary mb-6">menu_book</span>
                        <h3 class="text-2xl font-black text-slate-900 dark:text-white">Insurance Act 1061</h3>
                        <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                            The primary legislation governing insurance in Ghana. Replaced Law 1989 to align with IAIS global best practices.
                        </p>
                        <button onclick="openModal('modal-act1061')"
                            class="mt-8 inline-flex items-center gap-2 text-primary font-bold hover:underline transition-all">
                            Download PDF <span class="material-symbols-outlined text-sm">download</span>
                        </button>
                    </div>

                    <!-- Motor Insurance Database -->
                    <div class="reg-card p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 transition-all duration-300" data-type="directive">
                        <span class="material-symbols-outlined text-4xl text-emerald-500 mb-6">directions_car</span>
                        <h3 class="text-2xl font-black text-slate-900 dark:text-white">Motor Insurance Database</h3>
                        <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                            A centralized system for the verification of motor insurance policies to eliminate fake stickers and fraud.
                        </p>
                        <button onclick="openModal('modal-motor')"
                            class="mt-8 inline-flex items-center gap-2 text-primary font-bold hover:underline transition-all">
                            Verification Guide <span class="material-symbols-outlined text-sm">arrow_forward</span>
                        </button>
                    </div>

                    <!-- Statutory Funds -->
                    <div class="reg-card p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 shadow-xl border border-slate-100 dark:border-slate-800 transition-all duration-300" data-type="guideline">
                        <span class="material-symbols-outlined text-4xl text-amber-500 mb-6">account_balance</span>
                        <h3 class="text-2xl font-black text-slate-900 dark:text-white">Statutory Funds</h3>
                        <p class="mt-4 text-slate-600 dark:text-slate-400 leading-relaxed">
                            Regulations regarding the Motor Compensation Fund and other statutory deposits for market stability.
                        </p>
                        <button onclick="openModal('modal-statutory')"
                            class="mt-8 inline-flex items-center gap-2 text-primary font-bold hover:underline transition-all">
                            View Guidelines <span class="material-symbols-outlined text-sm">arrow_forward</span>
                        </button>
                    </div>
                </div>

                <!-- Additional Directives -->
                <div class="mt-20 border-t border-slate-200 dark:border-slate-800 pt-20">
                    <h2 class="text-3xl font-black mb-12">Additional Directives</h2>
                    <div id="noResults" class="hidden py-20 text-center bg-white dark:bg-slate-900 rounded-[3rem] border border-dashed border-slate-200 dark:border-slate-800 mb-12">
                        <span class="material-symbols-outlined text-6xl text-slate-200 mb-4">search_off</span>
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white">No documents match your criteria</h3>
                        <p class="text-slate-500 mt-2">Try adjusting your search or category filter.</p>
                        <button onclick="resetFilters()" class="mt-6 text-primary font-bold hover:underline">Reset Filters</button>
                    </div>
                    <div class="space-y-4">
                        <button onclick="openModal('modal-micro')" data-type="guideline"
                            class="reg-card w-full flex items-center justify-between p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 hover:shadow-lg hover:border-primary/30 transition-all group text-left">
                            <div class="flex items-center gap-4">
                                <span class="material-symbols-outlined text-slate-400 group-hover:text-primary transition-colors">description</span>
                                <span class="font-bold">Guidelines on Micro-Insurance Operations</span>
                            </div>
                            <span class="material-symbols-outlined text-slate-300 group-hover:text-primary group-hover:translate-x-1 transition-all">chevron_right</span>
                        </button>
                        <button onclick="openModal('modal-aml')" data-type="directive"
                            class="reg-card w-full flex items-center justify-between p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 hover:shadow-lg hover:border-primary/30 transition-all group text-left">
                            <div class="flex items-center gap-4">
                                <span class="material-symbols-outlined text-slate-400 group-hover:text-primary transition-colors">description</span>
                                <span class="font-bold">Anti-Money Laundering (AML) Regulations 2024</span>
                            </div>
                            <span class="material-symbols-outlined text-slate-300 group-hover:text-primary group-hover:translate-x-1 transition-all">chevron_right</span>
                        </button>
                        <button onclick="openModal('modal-agri')" data-type="guideline"
                            class="reg-card w-full flex items-center justify-between p-6 rounded-2xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 hover:shadow-lg hover:border-primary/30 transition-all group text-left">
                            <div class="flex items-center gap-4">
                                <span class="material-symbols-outlined text-slate-400 group-hover:text-primary transition-colors">description</span>
                                <span class="font-bold">Agricultural Insurance Regulatory Framework</span>
                            </div>
                            <span class="material-symbols-outlined text-slate-300 group-hover:text-primary group-hover:translate-x-1 transition-all">chevron_right</span>
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="common/public_footer.jsp" />
</div>

<!-- ═══════════════════════ MODALS ═══════════════════════ -->

<!-- MODAL: Insurance Act 1061 -->
<div id="modal-act1061" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-primary/5 border-b border-primary/10 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-primary/10 rounded-2xl"><span class="material-symbols-outlined text-primary text-2xl">menu_book</span></div>
                <div>
                    <p class="text-[10px] font-black text-primary uppercase tracking-widest mb-0.5">Official Legislation</p>
                    <h3 class="text-xl font-black text-slate-950">Insurance Act, 2021 (Act 1061)</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-act1061')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">
                The Insurance Act, 2021 (Act 1061) is the primary legislation governing insurance in Ghana. It replaces the Insurance Act, 2006 (Act 724) and aligns with IAIS international best practices.
            </p>
            <div class="grid grid-cols-2 gap-3">
                <div class="bg-slate-50 rounded-2xl p-4"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Enacted</p><p class="font-black text-slate-900">2021</p></div>
                <div class="bg-slate-50 rounded-2xl p-4"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Replaces</p><p class="font-black text-slate-900">Act 724 (2006)</p></div>
                <div class="bg-slate-50 rounded-2xl p-4"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Authority</p><p class="font-black text-slate-900">NIC Ghana</p></div>
                <div class="bg-slate-50 rounded-2xl p-4"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Format</p><p class="font-black text-slate-900">PDF Document</p></div>
            </div>
            <div class="bg-blue-50 rounded-2xl p-5 border border-blue-100">
                <p class="text-xs font-black text-blue-700 uppercase tracking-widest mb-3">Key Provisions</p>
                <ul class="space-y-2 text-sm text-blue-800/90">
                    <li class="flex gap-2"><span class="material-symbols-outlined text-blue-400 text-sm mt-0.5">check_circle</span>Licensing of insurers, brokers &amp; agents</li>
                    <li class="flex gap-2"><span class="material-symbols-outlined text-blue-400 text-sm mt-0.5">check_circle</span>Solvency and capital adequacy requirements</li>
                    <li class="flex gap-2"><span class="material-symbols-outlined text-blue-400 text-sm mt-0.5">check_circle</span>Consumer protection and complaints framework</li>
                    <li class="flex gap-2"><span class="material-symbols-outlined text-blue-400 text-sm mt-0.5">check_circle</span>Enforcement powers and sanctions</li>
                </ul>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="Insurance-Act-2021-GH.pdf" download="Insurance_Act_2021_Ghana.pdf"
                   onclick="showToast('Insurance_Act_2021_Ghana.pdf')"
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-primary text-white rounded-2xl text-sm font-black hover:bg-primary/90 shadow-lg shadow-primary/20 transition-all">
                    <span class="material-symbols-outlined text-sm">download</span> Download PDF
                </a>
                <button onclick="closeModal('modal-act1061')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: Motor Insurance Verification -->
<div id="modal-motor" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-emerald-50 border-b border-emerald-100 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-emerald-100 rounded-2xl"><span class="material-symbols-outlined text-emerald-600 text-2xl">directions_car</span></div>
                <div>
                    <p class="text-[10px] font-black text-emerald-600 uppercase tracking-widest mb-0.5">Verification System</p>
                    <h3 class="text-xl font-black text-slate-950">Motor Insurance Database</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-motor')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">The NIC Motor Insurance Database (MID) is a real-time platform for verifying motor insurance policies across Ghana, eliminating fraudulent stickers and protecting road users.</p>
            <p class="text-xs font-black text-slate-500 uppercase tracking-widest">How to Verify a Policy</p>
            <div class="space-y-3">
                <div class="flex gap-4 p-4 bg-slate-50 rounded-2xl items-start">
                    <div class="h-8 w-8 bg-emerald-100 rounded-xl flex items-center justify-center shrink-0 text-emerald-700 font-black text-sm">1</div>
                    <div><p class="font-bold text-sm text-slate-900">Enter Vehicle Registration Number</p><p class="text-xs text-slate-500 mt-0.5">Use format: GR-1234-21 or similar plate format.</p></div>
                </div>
                <div class="flex gap-4 p-4 bg-slate-50 rounded-2xl items-start">
                    <div class="h-8 w-8 bg-emerald-100 rounded-xl flex items-center justify-center shrink-0 text-emerald-700 font-black text-sm">2</div>
                    <div><p class="font-bold text-sm text-slate-900">Query the MID Portal</p><p class="text-xs text-slate-500 mt-0.5">The system returns the policy owner, insurer, and coverage period.</p></div>
                </div>
                <div class="flex gap-4 p-4 bg-slate-50 rounded-2xl items-start">
                    <div class="h-8 w-8 bg-emerald-100 rounded-xl flex items-center justify-center shrink-0 text-emerald-700 font-black text-sm">3</div>
                    <div><p class="font-bold text-sm text-slate-900">Confirm Active Coverage</p><p class="text-xs text-slate-500 mt-0.5">A green verified badge confirms valid, active insurance coverage.</p></div>
                </div>
                <div class="flex gap-4 p-4 bg-red-50 rounded-2xl border border-red-100 items-start">
                    <div class="h-8 w-8 bg-red-100 rounded-xl flex items-center justify-center shrink-0 text-red-700 font-black text-sm">!</div>
                    <div><p class="font-bold text-sm text-slate-900">Report Suspicious Stickers</p><p class="text-xs text-slate-500 mt-0.5">Contact NIC at <span class="font-bold text-primary">0302-671-795</span> or report via the portal.</p></div>
                </div>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="nic_motor_verify.jsp"
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-emerald-600 text-white rounded-2xl text-sm font-black hover:bg-emerald-700 shadow-lg shadow-emerald-200 transition-all">
                    <span class="material-symbols-outlined text-sm">search</span> Verify a Vehicle
                </a>
                <button onclick="closeModal('modal-motor')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: Statutory Funds -->
<div id="modal-statutory" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-amber-50 border-b border-amber-100 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-amber-100 rounded-2xl"><span class="material-symbols-outlined text-amber-600 text-2xl">account_balance</span></div>
                <div>
                    <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-0.5">Regulatory Guidelines</p>
                    <h3 class="text-xl font-black text-slate-950">Statutory Funds Guidelines</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-statutory')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">The statutory funds framework mandates all licensed insurers to maintain regulatory deposits that protect policyholders and ensure industry stability, administered directly by the NIC.</p>
            <div class="space-y-3">
                <div class="p-5 border border-amber-100 bg-amber-50/50 rounded-2xl">
                    <p class="font-black text-sm text-slate-900 mb-1">Motor Compensation Fund (MCF)</p>
                    <p class="text-xs text-slate-500">Compensates victims of uninsured or hit-and-run motor accidents. All licensed motor insurers must contribute.</p>
                </div>
                <div class="p-5 border border-blue-100 bg-blue-50/50 rounded-2xl">
                    <p class="font-black text-sm text-slate-900 mb-1">Life Insurance Policyholders' Protection Fund</p>
                    <p class="text-xs text-slate-500">Protects life insurance policyholders if a licensed insurer becomes insolvent or unable to meet obligations.</p>
                </div>
                <div class="p-5 border border-emerald-100 bg-emerald-50/50 rounded-2xl">
                    <p class="font-black text-sm text-slate-900 mb-1">Non-Life Insurance Solvency Reserve</p>
                    <p class="text-xs text-slate-500">Minimum capital deposits required of all non-life insurers to guarantee claims payment capacity.</p>
                </div>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="mailto:info@nic.gov.gh?subject=Document%20Request%3A%20Statutory%20Funds%20Guidelines&body=Hello%20NIC%20Ghana%2C%0A%0APlease%20send%20me%20a%20copy%20of%20the%20Statutory%20Funds%20Guidelines%20document.%0A%0AThank%20you."
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-amber-500 text-white rounded-2xl text-sm font-black hover:bg-amber-600 shadow-lg shadow-amber-200 transition-all">
                    <span class="material-symbols-outlined text-sm">mail</span> Request Document
                </a>
                <button onclick="closeModal('modal-statutory')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: Micro-Insurance -->
<div id="modal-micro" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-slate-50 border-b border-slate-100 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-primary/10 rounded-2xl"><span class="material-symbols-outlined text-primary text-2xl">description</span></div>
                <div>
                    <p class="text-[10px] font-black text-primary uppercase tracking-widest mb-0.5">Directive — Additional</p>
                    <h3 class="text-xl font-black text-slate-950">Micro-Insurance Operations</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-micro')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">These guidelines provide a regulatory framework for micro-insurance products in Ghana, expanding access to insurance among low-income and underserved populations.</p>
            <div class="bg-primary/5 rounded-2xl p-5 border border-primary/10 space-y-2">
                <p class="text-xs font-black text-primary uppercase tracking-widest mb-3">Scope of Guidelines</p>
                <div class="flex gap-2 text-sm text-slate-700"><span class="material-symbols-outlined text-primary text-sm mt-0.5">chevron_right</span>Licensing requirements for micro-insurance providers</div>
                <div class="flex gap-2 text-sm text-slate-700"><span class="material-symbols-outlined text-primary text-sm mt-0.5">chevron_right</span>Premium limits and benefit caps for micro-products</div>
                <div class="flex gap-2 text-sm text-slate-700"><span class="material-symbols-outlined text-primary text-sm mt-0.5">chevron_right</span>Distribution via mobile money &amp; agent networks</div>
                <div class="flex gap-2 text-sm text-slate-700"><span class="material-symbols-outlined text-primary text-sm mt-0.5">chevron_right</span>Claims turnaround requirement (max 5 business days)</div>
                <div class="flex gap-2 text-sm text-slate-700"><span class="material-symbols-outlined text-primary text-sm mt-0.5">chevron_right</span>Consumer literacy and disclosure obligations</div>
            </div>
            <div class="grid grid-cols-2 gap-3">
                <div class="bg-slate-50 rounded-2xl p-4 text-center"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Issued By</p><p class="font-black text-slate-900 text-sm">NIC Ghana</p></div>
                <div class="bg-slate-50 rounded-2xl p-4 text-center"><p class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Status</p><p class="font-black text-emerald-600 text-sm">In Force</p></div>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="mailto:info@nic.gov.gh?subject=Document%20Request%3A%20Micro-Insurance%20Operations%20Guidelines&body=Hello%20NIC%20Ghana%2C%0A%0APlease%20send%20me%20a%20copy%20of%20the%20Micro-Insurance%20Operations%20Guidelines.%0A%0AThank%20you."
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-primary text-white rounded-2xl text-sm font-black hover:bg-primary/90 shadow-lg shadow-primary/20 transition-all">
                    <span class="material-symbols-outlined text-sm">mail</span> Request Document
                </a>
                <button onclick="closeModal('modal-micro')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: AML Regulations -->
<div id="modal-aml" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-red-50 border-b border-red-100 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-red-100 rounded-2xl"><span class="material-symbols-outlined text-red-600 text-2xl">gavel</span></div>
                <div>
                    <p class="text-[10px] font-black text-red-600 uppercase tracking-widest mb-0.5">Compliance Directive — 2024</p>
                    <h3 class="text-xl font-black text-slate-950">AML Regulations 2024</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-aml')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">The AML Regulations 2024 impose mandatory obligations on all regulated insurance entities to implement robust anti-money laundering and counter-terrorist financing (AML/CFT) controls in line with FATF recommendations.</p>
            <div class="bg-red-50 border border-red-100 rounded-2xl p-5">
                <p class="text-xs font-black text-red-600 uppercase tracking-widest mb-3">Key Obligations</p>
                <div class="space-y-2 text-sm text-slate-700">
                    <div class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">warning</span>Customer Due Diligence (CDD) for all policyholders</div>
                    <div class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">warning</span>Enhanced Due Diligence (EDD) for high-risk clients &amp; PEPs</div>
                    <div class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">warning</span>Suspicious Transaction Reporting to FIC Ghana</div>
                    <div class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">warning</span>Record-keeping for a minimum of 7 years</div>
                    <div class="flex gap-2"><span class="material-symbols-outlined text-red-400 text-sm mt-0.5">warning</span>Staff AML training &amp; designated MLRO appointment</div>
                </div>
            </div>
            <div class="bg-amber-50 rounded-2xl p-4 border border-amber-100 flex gap-3">
                <span class="material-symbols-outlined text-amber-500 shrink-0 mt-0.5">info</span>
                <p class="text-xs text-amber-800">Non-compliance may result in license revocation and criminal prosecution under the Anti-Money Laundering Act, 2020 (Act 1044).</p>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="mailto:info@nic.gov.gh?subject=Document%20Request%3A%20AML%20Regulations%202024&body=Hello%20NIC%20Ghana%2C%0A%0APlease%20send%20me%20a%20copy%20of%20the%20Anti-Money%20Laundering%20Regulations%202024.%0A%0AThank%20you."
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-red-600 text-white rounded-2xl text-sm font-black hover:bg-red-700 shadow-lg shadow-red-200 transition-all">
                    <span class="material-symbols-outlined text-sm">mail</span> Request Document
                </a>
                <button onclick="closeModal('modal-aml')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: Agricultural Insurance -->
<div id="modal-agri" class="modal-overlay hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
    <div class="modal-panel bg-white rounded-[2.5rem] w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="bg-emerald-50 border-b border-emerald-100 p-7 flex items-start justify-between">
            <div class="flex items-center gap-4">
                <div class="p-3 bg-emerald-100 rounded-2xl"><span class="material-symbols-outlined text-emerald-600 text-2xl">agriculture</span></div>
                <div>
                    <p class="text-[10px] font-black text-emerald-600 uppercase tracking-widest mb-0.5">Regulatory Framework</p>
                    <h3 class="text-xl font-black text-slate-950">Agricultural Insurance</h3>
                </div>
            </div>
            <button onclick="closeModal('modal-agri')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors text-slate-400 shrink-0">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="p-7 space-y-5 max-h-[70vh] overflow-y-auto">
            <p class="text-sm text-slate-600 leading-relaxed">This framework establishes regulatory conditions for the licensing, operation, and supervision of agricultural insurance products in Ghana, supporting food security and rural development.</p>
            <div class="space-y-3">
                <div class="flex gap-4 p-4 bg-emerald-50 rounded-2xl border border-emerald-100 items-start">
                    <span class="material-symbols-outlined text-emerald-600 text-xl shrink-0">grain</span>
                    <div><p class="font-bold text-sm text-slate-900">Crop Insurance Products</p><p class="text-xs text-slate-500 mt-0.5">Covers rainfall deficits, drought, floods, and pests for smallholder and commercial farmers.</p></div>
                </div>
                <div class="flex gap-4 p-4 bg-emerald-50 rounded-2xl border border-emerald-100 items-start">
                    <span class="material-symbols-outlined text-emerald-600 text-xl shrink-0">pets</span>
                    <div><p class="font-bold text-sm text-slate-900">Livestock &amp; Aquaculture Cover</p><p class="text-xs text-slate-500 mt-0.5">Mandatory minimum benefit structures for livestock mortality and aquaculture losses.</p></div>
                </div>
                <div class="flex gap-4 p-4 bg-emerald-50 rounded-2xl border border-emerald-100 items-start">
                    <span class="material-symbols-outlined text-emerald-600 text-xl shrink-0">handshake</span>
                    <div><p class="font-bold text-sm text-slate-900">Government Co-Insurance Programme</p><p class="text-xs text-slate-500 mt-0.5">Subsidy arrangements between MOFAD, MOFA, and licensed providers for accessible premiums.</p></div>
                </div>
            </div>
            <div class="flex gap-3 pt-2">
                <a href="mailto:info@nic.gov.gh?subject=Document%20Request%3A%20Agricultural%20Insurance%20Regulatory%20Framework&body=Hello%20NIC%20Ghana%2C%0A%0APlease%20send%20me%20a%20copy%20of%20the%20Agricultural%20Insurance%20Regulatory%20Framework.%0A%0AThank%20you."
                   class="flex-1 flex items-center justify-center gap-2 py-4 bg-emerald-600 text-white rounded-2xl text-sm font-black hover:bg-emerald-700 shadow-lg shadow-emerald-200 transition-all">
                    <span class="material-symbols-outlined text-sm">mail</span> Request Document
                </a>
                <button onclick="closeModal('modal-agri')" class="px-5 py-4 bg-slate-100 text-slate-700 rounded-2xl text-sm font-black hover:bg-slate-200 transition-all">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Download Toast -->
<div id="download-toast" class="hidden fixed bottom-6 right-6 z-[300] bg-slate-950 text-white px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-3">
    <span class="material-symbols-outlined text-emerald-400">download_done</span>
    <div>
        <p class="font-black text-sm">Download Started</p>
        <p id="toast-filename" class="text-xs text-slate-400 mt-0.5"></p>
    </div>
</div>

<script>
    function openModal(id) {
        const modal = document.getElementById(id);
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        // Re-trigger animation
        const panel = modal.querySelector('.modal-panel');
        panel.style.animation = 'none';
        panel.offsetHeight;
        panel.style.animation = '';
    }

    function closeModal(id) {
        document.getElementById(id).classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    // Close on backdrop click
    document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.add('hidden');
                document.body.style.overflow = 'auto';
            }
        });
    });

    // Close on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay:not(.hidden)').forEach(function(m) {
                m.classList.add('hidden');
            });
            document.body.style.overflow = 'auto';
        }
    });

    function showToast(filename) {
        var toast = document.getElementById('download-toast');
        document.getElementById('toast-filename').textContent = filename;
        toast.classList.remove('hidden');
        setTimeout(function() { toast.classList.add('hidden'); }, 3500);
    }

    let currentFilter = 'all';

    function setFilter(type, btn) {
        currentFilter = type;
        document.querySelectorAll('.filter-chip').forEach(c => {
            c.classList.remove('active', 'bg-primary', 'text-white', 'shadow-lg', 'shadow-primary/20');
            c.classList.add('text-slate-500');
        });
        btn.classList.add('active', 'bg-primary', 'text-white', 'shadow-lg', 'shadow-primary/20');
        btn.classList.remove('text-slate-500');
        filterRegulations();
    }

    function filterRegulations() {
        const searchTerm = document.getElementById('regSearch').value.toLowerCase();
        const cards = document.querySelectorAll('.reg-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const text = card.textContent.toLowerCase();
            const type = card.getAttribute('data-type');
            
            const matchesSearch = text.includes(searchTerm);
            const matchesFilter = currentFilter === 'all' || type === currentFilter;

            if (matchesSearch && matchesFilter) {
                card.classList.remove('hidden');
                visibleCount++;
            } else {
                card.classList.add('hidden');
            }
        });

        document.getElementById('noResults').classList.toggle('hidden', visibleCount > 0);
    }

    function resetFilters() {
        document.getElementById('regSearch').value = '';
        setFilter('all', document.querySelector('.filter-chip'));
    }
</script>
</body>
</html>
