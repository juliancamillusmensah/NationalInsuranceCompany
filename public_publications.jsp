<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.util.List" %>
<%
    PublicationDAO pubDAO = new PublicationDAO();
    String filterCategory = request.getParameter("category");
    List<Publication> publications;
    if (filterCategory != null && !filterCategory.isEmpty() && !"All".equals(filterCategory)) {
        publications = pubDAO.getPublicationsByCategory(filterCategory);
    } else {
        publications = pubDAO.getAllPublications();
        filterCategory = "All";
    }

    /* Count for tabs */
    List<Publication> allPubs = pubDAO.getAllPublications();
    int annualCount = 0, quarterlyCount = 0, researchCount = 0, newsletterCount = 0, guidelineCount = 0;
    for (Publication p : allPubs) {
        String cat = p.getCategory();
        if ("Annual Report".equals(cat)) annualCount++;
        else if ("Quarterly Market Report".equals(cat)) quarterlyCount++;
        else if ("Market Research".equals(cat)) researchCount++;
        else if ("Newsletter".equals(cat)) newsletterCount++;
        else if ("Guideline".equals(cat)) guidelineCount++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Publications Center | NIC Ghana</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
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
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .category-tab.active { background-color: #1152d4; color: white; border-color: #1152d4; }
        .pub-card:hover { transform: translateY(-4px); box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1); }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #cbd5e1; }
    </style>
</head>
<body class="bg-background-light text-slate-800 antialiased min-h-screen font-display">
    
    <jsp:include page="common/public_header.jsp" />

    <main class="py-12 lg:py-20">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 space-y-16">
            
            <!-- Hero -->
            <div class="text-center max-w-3xl mx-auto space-y-6">
                <div class="inline-flex items-center gap-2 rounded-full bg-primary/10 px-4 py-1 text-sm font-bold text-primary">
                    <span class="material-symbols-outlined text-base">library_books</span>
                    Transparency Center
                </div>
                <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight">Publications & Industry Reports</h1>
                <p class="text-lg text-slate-600 leading-relaxed font-medium">Access official NIC Ghana annual reports, quarterly statistics, research papers, and regulatory guidelines.</p>
            </div>

            <!-- Filters -->
            <div class="flex flex-col md:flex-row gap-6 items-center justify-between">
                <div class="flex flex-wrap gap-2 justify-center md:justify-start">
                    <a href="public_publications.jsp" class="category-tab px-6 py-2.5 rounded-xl border border-slate-200 bg-white text-xs font-bold transition-all hover:bg-slate-50 <%= "All".equals(filterCategory) ? "active" : "text-slate-600" %>">
                        All Documents (<%= allPubs.size() %>)
                    </a>
                    <a href="public_publications.jsp?category=Annual+Report" class="category-tab px-6 py-2.5 rounded-xl border border-slate-200 bg-white text-xs font-bold transition-all hover:bg-slate-50 <%= "Annual Report".equals(filterCategory) ? "active" : "text-slate-600" %>">
                        Annual Reports (<%= annualCount %>)
                    </a>
                    <a href="public_publications.jsp?category=Quarterly+Market+Report" class="category-tab px-6 py-2.5 rounded-xl border border-slate-200 bg-white text-xs font-bold transition-all hover:bg-slate-50 <%= "Quarterly Market Report".equals(filterCategory) ? "active" : "text-slate-600" %>">
                        Quarterly Reports (<%= quarterlyCount %>)
                    </a>
                    <a href="public_publications.jsp?category=Market+Research" class="category-tab px-6 py-2.5 rounded-xl border border-slate-200 bg-white text-xs font-bold transition-all hover:bg-slate-50 <%= "Market Research".equals(filterCategory) ? "active" : "text-slate-600" %>">
                        Research (<%= researchCount %>)
                    </a>
                </div>
                <div class="relative w-full md:w-96">
                    <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 font-light">search</span>
                    <input type="text" id="publicSearch" placeholder="Search by document title..." class="w-full pl-12 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary/20 transition-all outline-none">
                </div>
            </div>

            <!-- Publications Listing -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8" id="pubGrid">
                <% if (publications != null && !publications.isEmpty()) {
                    for (Publication pub : publications) {
                        String catColor = "bg-primary/10 text-primary";
                        if ("Annual Report".equals(pub.getCategory())) catColor = "bg-purple-100 text-purple-600";
                        else if ("Quarterly Market Report".equals(pub.getCategory())) catColor = "bg-emerald-100 text-emerald-600";
                        else if ("Market Research".equals(pub.getCategory())) catColor = "bg-blue-100 text-blue-600";
                        else if ("Guideline".equals(pub.getCategory())) catColor = "bg-rose-100 text-rose-600";
                %>
                <div class="pub-card bg-white rounded-[2.5rem] p-8 border border-slate-100 shadow-xl shadow-slate-200/40 flex flex-col transition-all group search-card">
                    <div class="flex justify-between items-start mb-6">
                        <div class="h-14 w-14 rounded-2xl bg-red-50 flex items-center justify-center text-red-500 shrink-0 shadow-inner">
                            <span class="material-symbols-outlined text-2xl" style="font-variation-settings: 'FILL' 1">picture_as_pdf</span>
                        </div>
                        <span class="px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest <%= catColor %>">
                            <%= pub.getCategory() %>
                        </span>
                    </div>
                    
                    <div class="flex-1">
                        <h3 class="text-xl font-black text-slate-900 leading-tight mb-3 group-hover:text-primary transition-colors search-title"><%= pub.getTitle() %></h3>
                        <% if (pub.getDescription() != null && !pub.getDescription().isEmpty()) { %>
                            <p class="text-xs text-slate-400 font-bold leading-relaxed mb-6"><%= pub.getDescription() %></p>
                        <% } %>
                    </div>

                    <div class="mt-auto pt-8 border-t border-slate-50 flex items-center justify-between">
                        <div class="space-y-1">
                            <p class="text-[10px] font-black text-slate-300 uppercase tracking-widest">Document Data</p>
                            <p class="text-xs font-black text-slate-900"><%= pub.getYear() != null ? pub.getYear() : "Archive" %> • <%= pub.getFileSize() %></p>
                        </div>
                        <div class="flex gap-2">
                            <button onclick="previewFile('<%= pub.getFileUrl() %>', '<%= pub.getTitle() %>')" class="h-10 w-10 flex items-center justify-center rounded-xl bg-slate-50 text-slate-400 hover:bg-primary hover:text-white transition-all shadow-sm">
                                <span class="material-symbols-outlined text-xl">visibility</span>
                            </button>
                            <a href="<%= pub.getFileUrl() %>" download class="h-10 w-10 flex items-center justify-center rounded-xl bg-primary text-white hover:bg-primary/90 transition-all shadow-lg shadow-primary/20">
                                <span class="material-symbols-outlined text-xl">download</span>
                            </a>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                    <div class="col-span-full py-20 text-center">
                        <div class="h-20 w-20 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-6">
                            <span class="material-symbols-outlined text-slate-200 text-5xl">folder_open</span>
                        </div>
                        <h4 class="text-xl font-black text-slate-900">No documents found</h4>
                        <p class="text-sm text-slate-400 font-medium mt-2">We couldn't find any publications matching your current filter.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- Document Viewer Modal -->
    <div id="viewerModal" class="fixed inset-0 z-[110] hidden flex flex-col p-4 sm:p-10">
        <div class="absolute inset-0 bg-slate-950/90 backdrop-blur-md transition-opacity" onclick="document.getElementById('viewerModal').classList.add('hidden')"></div>
        <div class="relative w-full max-w-7xl mx-auto flex flex-col bg-white rounded-3xl shadow-2xl border border-white/20 h-full overflow-hidden flex-1 z-10 animate-in zoom-in-95 duration-300">
            <!-- Header -->
            <div class="bg-primary px-6 py-4 flex items-center justify-between shrink-0 shadow-md z-20">
                <div class="flex items-center gap-3">
                    <div class="bg-white/20 p-2 rounded-xl text-white">
                        <span class="material-symbols-outlined font-light" id="viewerIcon">preview</span>
                    </div>
                    <div>
                        <h3 class="text-lg font-black text-white tracking-tight leading-tight" id="viewerTitle">Document Preview</h3>
                        <span class="text-[10px] uppercase font-bold tracking-widest text-white/70" id="viewerExtBadge">LOADING...</span>
                    </div>
                </div>
                <button onclick="document.getElementById('viewerModal').classList.add('hidden')" class="text-white/70 hover:text-white bg-white/10 hover:bg-white/20 p-2 rounded-xl transition-all">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <!-- Dynamic Content Container -->
            <div id="viewerContent" class="flex-1 bg-slate-50 relative overflow-hidden flex flex-col">
                <!-- Injected via JS -->
            </div>
        </div>
    </div>

    <jsp:include page="common/public_footer.jsp" />

    <script>
        // Local Filter
        document.getElementById('publicSearch')?.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('.search-card').forEach(card => {
                const title = card.querySelector('.search-title').innerText.toLowerCase();
                card.style.display = title.includes(term) ? '' : 'none';
            });
        });

        // Document Preview
        async function previewFile(url, title) {
            const modal = document.getElementById('viewerModal');
            const contentDiv = document.getElementById('viewerContent');
            const titleEl = document.getElementById('viewerTitle');
            const badgeEl = document.getElementById('viewerExtBadge');
            const iconEl = document.getElementById('viewerIcon');

            modal.classList.remove('hidden');
            titleEl.textContent = title || 'Document Preview';
            contentDiv.innerHTML = `
                <div class="absolute inset-0 flex flex-col items-center justify-center">
                    <div class="h-12 w-12 border-4 border-slate-200 border-t-primary rounded-full animate-spin"></div>
                    <p class="mt-4 text-sm font-bold text-slate-400">Loading Document...</p>
                </div>
            `;

            const ext = url.split('.').pop().toLowerCase();
            if (ext === 'pdf') {
                badgeEl.textContent = 'PDF DOCUMENT';
                iconEl.textContent = 'picture_as_pdf';
                contentDiv.innerHTML = '<iframe src="' + url + '#toolbar=0" class="absolute inset-0 w-full h-full border-none"></iframe>';
            } else if (['xls', 'xlsx', 'csv'].includes(ext)) {
                badgeEl.textContent = 'SPREADSHEET DATA';
                iconEl.textContent = 'table_chart';
                try {
                    const response = await fetch(url);
                    const arrayBuffer = await response.arrayBuffer();
                    const workbook = XLSX.read(arrayBuffer, { type: 'array' });
                    const sheet = workbook.Sheets[workbook.SheetNames[0]];
                    const html = XLSX.utils.sheet_to_html(sheet);
                    contentDiv.innerHTML = '<div class="flex-1 overflow-auto p-8 bg-white custom-scrollbar">' + html + '</div>';
                    // Style the table
                    const table = contentDiv.querySelector('table');
                    if (table) {
                        table.className = "min-w-full divide-y divide-slate-200 border border-slate-100 text-xs";
                        table.querySelectorAll('td').forEach(td => td.className = "px-4 py-3 border border-slate-50");
                    }
                } catch (e) {
                    contentDiv.innerHTML = '<div class="p-20 text-center text-red-500 font-bold">Error loading spreadsheet preview.</div>';
                }
            } else {
                badgeEl.textContent = 'PREVIEW NOT AVAILABLE';
                contentDiv.innerHTML = '<div class="p-20 text-center text-slate-400 font-bold">This file type cannot be previewed. Please download it instead.</div>';
            }
        }
    </script>
</body>
</html>
