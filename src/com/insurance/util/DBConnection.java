package com.insurance.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // SQLite configuration
    private static final String DB_NAME = "NIC_insurance.db";
    private static String connectionUrl = null;

    /**
     * Dynamically initializes the database connection URL.
     * Called by AppContextListener during webapp startup.
     */
    public static void initialize(String basePath) {
        connectionUrl = "jdbc:sqlite:" + basePath + DB_NAME;
        System.out.println("DEBUG: DBConnection initialized with URL: " + connectionUrl);
    }

    // Load driver once
    static {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load SQLite Driver");
        }
    }

    public static Connection getConnection() throws SQLException {
        if (connectionUrl == null) {
            // Robust fallback for standalone scripts and IDEs
            String[] searchPaths = {
                "WEB-INF/database/" + DB_NAME,
                "webapps/NationalInsuranceCompany/WEB-INF/database/" + DB_NAME,
                "../WEB-INF/database/" + DB_NAME,
                DB_NAME
            };

            for (String path : searchPaths) {
                java.io.File dbFile = new java.io.File(path);
                if (dbFile.exists()) {
                    connectionUrl = "jdbc:sqlite:" + dbFile.getAbsolutePath().replace("\\", "/");
                    System.out.println("DEBUG: DBConnection found database at: " + dbFile.getAbsolutePath());
                    break;
                }
            }

            if (connectionUrl == null) {
                // Final default if nothing found
                connectionUrl = "jdbc:sqlite:" + DB_NAME;
                System.err.println("CRITICAL: Could not locate database. Defaulting to: " + connectionUrl);
            }
        }
        return DriverManager.getConnection(connectionUrl);
    }
}
