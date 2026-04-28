package com.insurance.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/DisplayImage")
public class ImageServlet extends HttpServlet {
    private static final String UPLOAD_BASE_DIR = "NIC_Insurance_Uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filename = request.getParameter("path");
        String type = request.getParameter("type"); // e.g. "kyc" or "claims"
        
        if (filename == null || type == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String userHome = System.getProperty("user.home");
        File file = new File(userHome + File.separator + UPLOAD_BASE_DIR + File.separator + type, filename);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        Files.copy(file.toPath(), response.getOutputStream());
    }
}
