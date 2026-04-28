<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    String success = request.getParameter("success");
    String error = null;
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String name = request.getParameter("fullName");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            
            if (name != null && email != null && message != null) {
                Enquiry enq = new Enquiry();
                enq.setFullName(name);
                enq.setEmail(email);
                enq.setSubject(subject);
                enq.setMessage(message);
                
                ContactDAO dao = new ContactDAO();
                if (dao.saveEnquiry(enq)) {
                    response.sendRedirect("nic_contact.jsp?success=true");
                    return;
                } else {
                    error = "Failed to save enquiry. Please try again.";
                }
            }
        } catch (Exception e) {
            error = "An unexpected error occurred: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Contact & Locations | NIC Ghana</title>
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
                <section class="py-20 lg:py-32 bg-white dark:bg-slate-900">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
                            <div>
                                <h1 class="text-4xl font-black tracking-tight sm:text-7xl">Get in <span class="text-primary italic">Touch.</span></h1>
                                <p class="mt-8 text-xl text-slate-600 dark:text-slate-400 max-w-lg leading-relaxed">
                                    Have questions about your policy, licensing, or the insurance industry? The NIC is here to support you at our Accra headquarters or any of our regional offices.
                                </p>
                                
                                <div class="mt-12 space-y-6">
                                    <div class="flex items-center gap-6 p-6 rounded-3xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-800">
                                        <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-primary text-white">
                                            <span class="material-symbols-outlined">call</span>
                                        </div>
                                        <div>
                                            <p class="text-xs font-black uppercase text-slate-400 tracking-widest">General Enquiries</p>
                                            <p class="text-lg font-bold text-slate-900 dark:text-white">+233 (0) 302 238 301</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-6 p-6 rounded-3xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-800">
                                        <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-emerald-500 text-white">
                                            <span class="material-symbols-outlined">alternate_email</span>
                                        </div>
                                        <div>
                                            <p class="text-xs font-black uppercase text-slate-400 tracking-widest">Email Support</p>
                                            <p class="text-lg font-bold text-slate-900 dark:text-white">complaints@nicgh.org</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-white dark:bg-slate-900 rounded-[3rem] p-10 lg:p-12 shadow-2xl shadow-slate-200/50 border border-slate-100 dark:border-slate-800 relative overflow-hidden">
                                <% if ("true".equals(success)) { %>
                                    <div id="successState" class="absolute inset-0 z-10 bg-white/95 dark:bg-slate-900/95 flex flex-col items-center justify-center p-8 text-center animate-in fade-in zoom-in duration-300">
                                        <div class="h-20 w-20 bg-emerald-100 rounded-full flex items-center justify-center mb-6">
                                            <span class="material-symbols-outlined text-emerald-600 text-4xl">check_circle</span>
                                        </div>
                                        <h3 class="text-2xl font-black mb-2">Message Sent!</h3>
                                        <p class="text-slate-500 mb-8">Thank you for Reaching out. Our team will get back to you within 24-48 hours.</p>
                                        <button onclick="window.location.href='nic_contact.jsp'" class="px-8 py-3 bg-primary text-white font-black rounded-2xl hover:scale-105 active:scale-95 transition-all">Send Another</button>
                                    </div>
                                <% } %>
                                
                                <h3 class="text-2xl font-black mb-8">Send an Enquiry</h3>
                                <form method="POST" class="space-y-6" onsubmit="this.querySelector('button').innerText='Sending...'; this.querySelector('button').disabled=true;">
                                    <% if (error != null) { %>
                                        <div class="p-4 bg-rose-50 border border-rose-100 text-rose-600 text-sm font-bold rounded-2xl">
                                            <%= error %>
                                        </div>
                                    <% } %>
                                    <div class="grid grid-cols-2 gap-6">
                                        <div class="space-y-2">
                                            <label class="text-sm font-black text-slate-500">Full Name</label>
                                            <input type="text" name="fullName" required class="w-full rounded-2xl border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800 px-4 py-3 focus:ring-primary">
                                        </div>
                                        <div class="space-y-2">
                                            <label class="text-sm font-black text-slate-500">Email Address</label>
                                            <input type="email" name="email" required class="w-full rounded-2xl border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800 px-4 py-3 focus:ring-primary">
                                        </div>
                                    </div>
                                    <div class="space-y-2">
                                        <label class="text-sm font-black text-slate-500">Subject</label>
                                        <select name="subject" class="w-full rounded-2xl border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800 px-4 py-3 focus:ring-primary">
                                            <option>General Inquiry</option>
                                            <option>Licensing Support</option>
                                            <option>Submit a Complaint</option>
                                            <option>Verification Request</option>
                                        </select>
                                    </div>
                                    <div class="space-y-2">
                                        <label class="text-sm font-black text-slate-500">Message</label>
                                        <textarea name="message" rows="5" required class="w-full rounded-2xl border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800 px-4 py-3 focus:ring-primary"></textarea>
                                    </div>
                                    <button class="w-full py-5 rounded-2xl bg-primary text-white font-black shadow-lg shadow-primary/30 hover:bg-primary/90 transition-all">Submit Inquiry</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Offices Section -->
                <section id="offices" class="py-24 bg-slate-50 dark:bg-slate-900/50">
                    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                        <div class="mb-16">
                            <h2 class="text-4xl font-black tracking-tight">Our Locations</h2>
                            <p class="text-xl text-slate-600 dark:text-slate-400 mt-4">The NIC maintains a presence across all major administrative zones in Ghana.</p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                            <!-- Accra (Head Office) -->
                            <div class="p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 group shadow-sm hover:shadow-xl transition-all">
                                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-primary text-white mb-6">
                                    <span class="material-symbols-outlined">apartment</span>
                                </div>
                                <h3 class="text-xl font-black mb-2">Head Office (Accra)</h3>
                                <p class="text-slate-500 text-sm leading-relaxed mb-6">Insurance House, 6th Avenue, Accra (Opposite Ghana School of Law).</p>
                                <a href="https://www.google.com/maps/search/?api=1&query=Insurance+House+Ghana+School+of+Law+Accra" 
                                   target="_blank" class="flex items-center gap-3 text-primary font-bold hover:underline transition-all">
                                    <span class="material-symbols-outlined text-sm">map</span>
                                    <span>Get Directions</span>
                                </a>
                            </div>
                            <!-- Kumasi -->
                            <div class="p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 group shadow-sm hover:shadow-xl transition-all">
                                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-500 mb-6">
                                    <span class="material-symbols-outlined">location_on</span>
                                </div>
                                <h3 class="text-xl font-black mb-2">Kumasi Office</h3>
                                <p class="text-slate-500 text-sm leading-relaxed mb-6">Asokwa Industrial Area, Kumasi, Ashanti Region.</p>
                                <a href="https://www.google.com/maps/search/?api=1&query=Asokwa+Industrial+Area+Kumasi" 
                                   target="_blank" class="flex items-center gap-3 text-primary font-bold hover:underline transition-all">
                                    <span class="material-symbols-outlined text-sm">map</span>
                                    <span>Get Directions</span>
                                </a>
                            </div>
                            <!-- Takoradi -->
                            <div class="p-8 rounded-[2.5rem] bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 group shadow-sm hover:shadow-xl transition-all">
                                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-500 mb-6">
                                    <span class="material-symbols-outlined">location_on</span>
                                </div>
                                <h3 class="text-xl font-black mb-2">Western Zone</h3>
                                <p class="text-slate-500 text-sm leading-relaxed mb-6">Adjacent to Takoradi Port, Sekondi-Takoradi.</p>
                                <a href="https://www.google.com/maps/search/?api=1&query=Takoradi+Port+Sekondi-Takoradi" 
                                   target="_blank" class="flex items-center gap-3 text-primary font-bold hover:underline transition-all">
                                    <span class="material-symbols-outlined text-sm">map</span>
                                    <span>Get Directions</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <jsp:include page="common/public_footer.jsp" />
        </div>
    </body>
</html>
