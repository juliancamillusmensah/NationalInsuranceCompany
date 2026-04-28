<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    Account user = (Account) sess.getAttribute("user");
    String policyId = request.getParameter("id");
    
    if (policyId == null || policyId.isEmpty()) {
        response.sendRedirect("customer_explore_policies.jsp");
        return;
    }

    PolicyDAO policyDAO = new PolicyDAO();
    Policy p = policyDAO.getPolicyById(policyId);
    
    if (p == null) {
        response.sendRedirect("customer_explore_policies.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Enroll in <%= p.getPolicyName() %></title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: { "primary": "#1152d4", "background-light": "#f8fafc" },
                    fontFamily: { "display": ["Inter", "sans-serif"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .step-active { background-color: #1152d4; color: white; border-color: #1152d4; }
        .step-inactive { background-color: #f1f5f9; color: #94a3b8; border-color: #e2e8f0; }
        .step-completed { background-color: #22c55e; color: white; border-color: #22c55e; }
    </style>
</head>
<body class="bg-slate-50 text-slate-900 antialiased min-h-screen py-10 px-4">

    <div class="max-w-3xl mx-auto">
        <!-- Header -->
        <div class="text-center mb-10">
            <div class="inline-flex items-center justify-center h-16 w-16 bg-primary rounded-2xl text-white mb-4 shadow-lg shadow-primary/20">
                <span class="material-symbols-outlined text-3xl">verified_user</span>
            </div>
            <h1 class="text-3xl font-black text-slate-950 tracking-tight">Complete Your Enrollment</h1>
            <p class="text-slate-500 font-medium mt-2"> <%= p.getPolicyName() %> • $<%= p.getPremiumAmount() %>/mo</p>
        </div>

        <!-- Wizard Container -->
        <div class="bg-white rounded-3xl shadow-xl border border-slate-100 overflow-hidden">
            <!-- Progress Tracker -->
            <div class="bg-slate-50/50 border-b border-slate-100 p-6 flex justify-between items-center relative">
                <div class="absolute top-1/2 left-0 right-0 h-0.5 bg-slate-200 -z-10 translate-y-[-50%] mx-12"></div>
                <div id="progress-line" class="absolute top-1/2 left-0 h-0.5 bg-primary -z-10 translate-y-[-50%] mx-12 transition-all duration-300" style="width: 0%;"></div>
                
                <div class="flex flex-col items-center gap-2 bg-white px-2 z-10" id="step1-indicator">
                    <div class="h-10 w-10 rounded-full border-2 flex items-center justify-center font-bold text-sm transition-colors step-active">1</div>
                    <span class="text-[10px] font-bold text-slate-500 tracking-wider uppercase">Details</span>
                </div>
                
                <div class="flex flex-col items-center gap-2 bg-white px-2 z-10" id="step2-indicator">
                    <div class="h-10 w-10 rounded-full border-2 flex items-center justify-center font-bold text-sm transition-colors step-inactive">2</div>
                    <span class="text-[10px] font-bold text-slate-400 tracking-wider uppercase">Upload</span>
                </div>
                
                <div class="flex flex-col items-center gap-2 bg-white px-2 z-10" id="step3-indicator">
                    <div class="h-10 w-10 rounded-full border-2 flex items-center justify-center font-bold text-sm transition-colors step-inactive">3</div>
                    <span class="text-[10px] font-bold text-slate-400 tracking-wider uppercase">Payment</span>
                </div>
            </div>

            <!-- Form -->
            <form action="enrollAction" method="post" enctype="multipart/form-data" class="p-8 md:p-12" id="enrollmentForm" onsubmit="return validateAndSubmit()">
                <input type="hidden" name="policyId" value="<%= p.getId() %>">
                <input type="hidden" name="premiumAmount" value="<%= p.getPremiumAmount() %>">

                <!-- Step 1: Personal Details & Insured Item -->
                <div id="step1" class="space-y-6">
                    <div>
                        <h2 class="text-xl font-black text-slate-900 mb-1">Applicant & Coverage Details</h2>
                        <p class="text-sm font-medium text-slate-500 mb-6">Provide the required information for your policy application.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Full Legal Name</label>
                            <input type="text" required value="<%= user.getFullName() %>" readonly class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all cursor-not-allowed">
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Email Address</label>
                            <input type="email" required value="<%= user.getEmail() %>" readonly class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all cursor-not-allowed">
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Phone Number <span class="text-red-500">*</span></label>
                            <input type="tel" id="phoneNumber" required placeholder="e.g. +1 555-0123" class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Date of Birth <span class="text-red-500">*</span></label>
                            <input type="date" id="dob" required class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>
                        <div class="space-y-1.5 md:col-span-2">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Physical Address <span class="text-red-500">*</span></label>
                            <input type="text" id="address" required placeholder="123 Main St, City, Country" class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>
                        <div class="space-y-1.5 md:col-span-2 bg-primary/5 p-5 border border-primary/20 rounded-2xl mt-2">
                            <label class="text-xs font-black text-primary uppercase tracking-wider flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">category</span> What belonging are you insuring? <span class="text-red-500">*</span>
                            </label>
                            <p class="text-[11px] text-slate-500 mb-3">e.g., "2021 Honda Civic EX", "123 Main St Property", "Myself (Health/Life)""</p>
                            <input type="text" name="insuredItem" id="insuredItem" required placeholder="Enter the belonging to be insured" class="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-primary outline-none transition-all">
                        </div>
                    </div>
                </div>

                <!-- Step 2: Documentation -->
                <div id="step2" class="space-y-6 hidden animate-in fade-in slide-in-from-right-4 duration-300">
                    <div>
                        <h2 class="text-xl font-black text-slate-900 mb-1">Upload Documentation</h2>
                        <p class="text-sm font-medium text-slate-500 mb-6">Please provide proof of identity or ownership related to your policy.</p>
                    </div>

                    <div class="border-2 border-dashed border-slate-200 rounded-3xl p-10 text-center hover:bg-slate-50 hover:border-primary/50 transition-all group cursor-pointer relative" onclick="document.getElementById('document').click()">
                        <div class="h-16 w-16 bg-slate-100 group-hover:bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4 transition-colors">
                            <span class="material-symbols-outlined text-3xl text-slate-400 group-hover:text-primary transition-colors">upload_file</span>
                        </div>
                        <h3 class="text-sm font-bold text-slate-900 mb-1">Click to upload a document</h3>
                        <p class="text-xs text-slate-500">PDF, JPG, or PNG (Max. 10MB)</p>
                        
                        <input type="file" name="document" id="document" required accept=".pdf,.jpg,.jpeg,.png" class="hidden" onchange="updateFileName(this)">
                        
                        <div id="fileStatus" class="mt-4 hidden p-3 bg-emerald-50 text-emerald-700 text-xs font-bold rounded-xl border border-emerald-100 flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-sm">check_circle</span> <span id="fileNameDisplay">File Selected</span>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Payment -->
                <div id="step3" class="space-y-6 hidden animate-in fade-in slide-in-from-right-4 duration-300">
                    <div>
                        <h2 class="text-xl font-black text-slate-900 mb-1">Review & Payment</h2>
                        <p class="text-sm font-medium text-slate-500 mb-6">Secure payment powered by Paystack. You will be redirected to complete the payment.</p>
                    </div>

                    <div class="bg-slate-50 rounded-2xl p-6 border border-slate-200 mb-4 flex justify-between items-center">
                        <div class="flex items-center gap-3">
                            <div class="h-10 w-10 bg-primary rounded-xl text-white flex items-center justify-center">
                                <span class="material-symbols-outlined">receipt_long</span>
                            </div>
                            <div>
                                <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest">Amount Due Today</p>
                                <p class="text-sm font-black text-slate-900"><%= p.getPolicyName() %></p>
                            </div>
                        </div>
                        <div class="text-right">
                            <div class="text-2xl font-black text-primary">GHS <%= p.getPremiumAmount() %></div>
                            <p class="text-[10px] text-slate-400 font-bold">via Paystack</p>
                        </div>
                    </div>

                    <input type="hidden" name="paymentMethod" value="Paystack">

                    <div class="bg-white rounded-2xl border border-slate-200 p-5 flex items-center gap-4">
                        <div class="h-12 w-12 bg-[#0AA699]/10 rounded-xl flex items-center justify-center shrink-0">
                            <svg class="h-7 w-7" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 2L2 7l10 5 10-5-10-5z" fill="#0AA699"/>
                                <path d="M2 17l10 5 10-5M2 12l10 5 10-5" stroke="#0AA699" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-black text-slate-950">Paystack</p>
                            <p class="text-[10px] text-slate-400 font-bold">Secure card, mobile money & bank transfer</p>
                        </div>
                        <span class="material-symbols-outlined text-[#0AA699]">check_circle</span>
                    </div>

                    <div class="bg-amber-50 rounded-xl border border-amber-100 p-4 flex gap-3 items-start">
                        <span class="material-symbols-outlined text-amber-600 text-lg">info</span>
                        <p class="text-xs text-amber-700 font-medium">After clicking "Pay & Enroll", you will be redirected to Paystack to complete your payment securely. Once confirmed, you will be enrolled automatically.</p>
                    </div>
                </div>

                <!-- Footer Navigation -->
                <div class="flex items-center justify-between mt-10 pt-6 border-t border-slate-100">
                    <button type="button" id="prevBtn" onclick="nextStep(-1)" class="hidden text-sm font-bold text-slate-500 hover:text-slate-900 transition-colors flex items-center gap-1">
                        <span class="material-symbols-outlined text-[18px]">chevron_left</span> Back
                    </button>
                    <!-- Dummy div to force Next button to right when Prev is hidden -->
                    <div id="btnSpacer"></div>
                    
                    <button type="button" id="nextBtn" onclick="nextStep(1)" class="py-3 px-8 bg-slate-900 text-white rounded-xl text-sm font-black hover:bg-slate-800 transition-colors shadow-lg shadow-slate-900/10 flex items-center gap-2">
                        Next Step <span class="material-symbols-outlined text-[18px]">chevron_right</span>
                    </button>
                    
                    <button type="submit" id="submitBtn" class="hidden py-4 px-10 bg-primary text-white rounded-2xl text-sm font-black shadow-xl shadow-primary/20 hover:scale-[1.02] flex items-center gap-2 transition-all">
                        Pay & Enroll Securely <span class="material-symbols-outlined text-[18px]">lock</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let currentStep = 1;
        
        function updateFileName(input) {
            const display = document.getElementById('fileStatus');
            const nameEl = document.getElementById('fileNameDisplay');
            if (input.files && input.files.length > 0) {
                nameEl.innerText = input.files[0].name;
                display.classList.remove('hidden');
            } else {
                display.classList.add('hidden');
            }
        }

        function validateStep(step) {
            if (step === 1) {
                if (!document.getElementById('phoneNumber').value || 
                    !document.getElementById('dob').value || 
                    !document.getElementById('address').value || 
                    !document.getElementById('insuredItem').value) {
                    alert('Please fill out all required fields marked with an asterisk (*).');
                    return false;
                }
            } else if (step === 2) {
                if(!document.getElementById('document').files.length) {
                    alert("Please upload a required documentation file.");
                    return false;
                }
            }
            return true;
        }

        function nextStep(direction) {
            if (direction === 1 && !validateStep(currentStep)) return;
            
            document.getElementById('step' + currentStep).classList.add('hidden');
            
            // Manage old indicators
            const oldInd = document.getElementById('step' + currentStep + '-indicator').querySelector('div');
            if(direction === 1) {
                oldInd.className = 'h-10 w-10 rounded-full flex items-center justify-center font-bold text-sm transition-colors step-completed';
                oldInd.innerHTML = '<span class="material-symbols-outlined text-[18px]">check</span>';
            } else {
                oldInd.className = 'h-10 w-10 rounded-full flex border-2 items-center justify-center font-bold text-sm transition-colors step-inactive';
                oldInd.innerHTML = currentStep;
            }

            currentStep += direction;
            
            // Show new step
            document.getElementById('step' + currentStep).classList.remove('hidden');
            
            // Manage new indicator
            const newInd = document.getElementById('step' + currentStep + '-indicator').querySelector('div');
            newInd.className = 'h-10 w-10 rounded-full border-2 flex items-center justify-center font-bold text-sm transition-colors step-active';
            newInd.innerHTML = currentStep;

            // Manage Progress Line
            document.getElementById('progress-line').style.width = ((currentStep - 1) * 50) + '%';

            // Buttons
            document.getElementById('prevBtn').style.display = currentStep > 1 ? 'flex' : 'none';
            document.getElementById('btnSpacer').style.display = currentStep > 1 ? 'none' : 'block';
            
            if (currentStep === 3) {
                document.getElementById('nextBtn').classList.add('hidden');
                document.getElementById('submitBtn').classList.remove('hidden');
            } else {
                document.getElementById('nextBtn').classList.remove('hidden');
                document.getElementById('submitBtn').classList.add('hidden');
            }
        }

        function validateAndSubmit() {
            const btn = document.getElementById('submitBtn');
            btn.innerHTML = `<span class="material-symbols-outlined animate-spin text-[18px]">progress_activity</span> Processing...`;
            btn.classList.add('opacity-80', 'cursor-not-allowed');
            btn.disabled = true;
            return true;
        }
    </script>
</body>
</html>
