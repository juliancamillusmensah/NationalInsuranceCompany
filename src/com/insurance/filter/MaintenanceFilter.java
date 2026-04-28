package com.insurance.filter;

import com.insurance.dao.SystemDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class MaintenanceFilter implements Filter {

    private SystemDAO systemDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        systemDAO = new SystemDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Always allow static resources and the maintenance page itself
        if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/") || path.equals("/maintenance.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Always allow the master administration UI and logins to prevent lockouts
        if (path.equals("/allloginpage.jsp") || path.equals("/login") || path.equals("/logout.jsp") || 
            path.equals("/Systemcreator.jsp") || path.equals("/system_roles.jsp") || path.equals("/system_logs.jsp") || 
            path.equals("/system_status.jsp") || path.equals("/system_audit.jsp") || 
            path.startsWith("/update_") || path.startsWith("/delete_") || path.startsWith("/add_system_config")) {
            chain.doFilter(request, response);
            return;
        }

        // Check maintenance mode
        String maintenanceEnabled = systemDAO.getSystemSetting("maintenance_enabled");
        
        if ("true".equalsIgnoreCase(maintenanceEnabled)) {
            // Check if user is system creator, allowed to bypass
            String roleId = (String) httpRequest.getSession().getAttribute("roleId");
            if (!"ROLE_SYSTEM_CREATOR".equals(roleId)) {
                // Not a privileged admin, redirect to maintenance page
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/maintenance.jsp");
                return;
            }
        }

        // Proceed normally
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
