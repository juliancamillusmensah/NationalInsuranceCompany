package com.insurance.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String rootPath = sce.getServletContext().getRealPath("/WEB-INF/database/");
        if (rootPath != null) {
            // Ensure trailing slash
            if (!rootPath.endsWith(File.separator)) {
                rootPath += File.separator;
            }
            // Normalize path for SQLite (forward slashes are generally safer in JDBC URLs)
            rootPath = rootPath.replace("\\", "/");
            
            System.out.println("DEBUG: AppContextListener initializing with rootPath: " + rootPath);
            DBConnection.initialize(rootPath);
        } else {
            System.err.println("ERROR: AppContextListener could not resolve real path of servlet context.");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if necessary
    }
}
