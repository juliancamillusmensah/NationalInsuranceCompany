<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="com.insurance.dao.*" %>
<%
    SystemDAO dao = new SystemDAO();
    String maintenanceMsg = dao.getSystemSetting("maintenance_message");
    if (maintenanceMsg == null || maintenanceMsg.trim().isEmpty()) {
        maintenanceMsg = "Our systems are currently undergoing scheduled maintenance to improve your experience. We will be back online shortly.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Under Maintenance</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#1152d4",
                    },
                    fontFamily: {
                        display: ["Inter", "sans-serif"],
                    },
                },
            },
        }
    </script>
</head>
<body class="bg-slate-50 font-display flex items-center justify-center min-h-screen p-6">
    
    <div class="max-w-2xl w-full bg-white rounded-3xl p-10 lg:p-16 border border-slate-100 shadow-2xl relative overflow-hidden text-center group">
        <!-- Floating decorative blobs -->
        <div class="absolute -top-10 -right-10 w-32 h-32 bg-primary/10 rounded-full blur-2xl group-hover:scale-150 transition-transform duration-700"></div>
        <div class="absolute -bottom-10 -left-10 w-32 h-32 bg-indigo-500/10 rounded-full blur-2xl group-hover:scale-150 transition-transform duration-700"></div>

        <div class="relative z-10 flex flex-col items-center">
            <div class="w-24 h-24 bg-primary/5 rounded-3xl flex items-center justify-center mb-8 border border-primary/10 rotate-3 group-hover:-rotate-3 transition-transform duration-500">
                <span class="material-symbols-outlined text-5xl text-primary font-black animate-pulse">engineering</span>
            </div>

            <h1 class="text-4xl lg:text-5xl font-black text-slate-900 tracking-tight mb-4">Under Maintenance</h1>
            
            <p class="text-lg lg:text-xl text-slate-500 font-medium leading-relaxed max-w-lg mx-auto mb-10">
                <%= maintenanceMsg %>
            </p>

            <a href="Systemcreator.jsp" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-sm transition-colors uppercase tracking-widest shadow-lg shadow-slate-900/20">
                <span class="material-symbols-outlined text-lg">admin_panel_settings</span>
                Admin Bypass (Staff Only)
            </a>
        </div>
    </div>

</body>
</html>
