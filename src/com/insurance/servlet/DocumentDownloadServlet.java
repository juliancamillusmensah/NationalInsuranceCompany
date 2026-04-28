package com.insurance.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/DocumentDownloadServlet")
public class DocumentDownloadServlet extends HttpServlet {

    private static final String UPLOAD_DIR_NAME = "NIC_Insurance_Uploads" + File.separator + "claims";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String roleId = (session != null) ? (String) session.getAttribute("roleId") : null;
        
        // Ensure only admins can download evidence files
        if (session == null || roleId == null || session.getAttribute("user") == null || 
            (!"ROLE_ADMIN".equals(roleId) && !"ROLE_COMPANY_ADMIN".equals(roleId) && !"ROLE_SUPERADMIN".equals(roleId))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Only administrators can view evidence documents.");
            return;
        }

        String fileName = request.getParameter("file");
        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File parameter is missing.");
            return;
        }

        // Extremely strict sanitization to prevent Directory Traversal
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid file name specified.");
            return;
        }

        String userHome = System.getProperty("user.home");
        File targetFile = new File(userHome + File.separator + UPLOAD_DIR_NAME, fileName);

        if (!targetFile.exists() || !targetFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "The requested evidence file could not be found.");
            return;
        }

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + targetFile.getName() + "\"");
        response.setContentLength((int) targetFile.length());

        try (FileInputStream inStream = new FileInputStream(targetFile);
             OutputStream outStream = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
