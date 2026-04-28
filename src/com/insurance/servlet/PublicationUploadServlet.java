package com.insurance.servlet;

import com.insurance.dao.PublicationDAO;
import com.insurance.model.Publication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/upload-publication")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 50,        // 50 MB
    maxRequestSize = 1024 * 1024 * 60      // 60 MB
)
public class PublicationUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
            !"ROLE_SUPERADMIN".equals(session.getAttribute("roleId"))) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String year = request.getParameter("year");
        String description = request.getParameter("description");

        /* Handle file upload */
        Part filePart = request.getPart("file");
        String fileUrl = request.getParameter("fileUrl");
        String fileSize = "N/A";

        if (filePart != null && filePart.getSize() > 0) {
            String originalName = getFileName(filePart);
            String safeName = System.currentTimeMillis() + "_" + originalName.replaceAll("[^a-zA-Z0-9._-]", "_");

            String uploadDir = getServletContext().getRealPath("/uploads/publications/");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            Path filePath = Paths.get(uploadDir, safeName);
            Files.copy(filePart.getInputStream(), filePath);

            fileUrl = "uploads/publications/" + safeName;

            long sizeBytes = filePart.getSize();
            if (sizeBytes >= 1024 * 1024) {
                fileSize = String.format("%.2f MB", sizeBytes / (1024.0 * 1024.0));
            } else {
                fileSize = String.format("%.0f KB", sizeBytes / 1024.0);
            }
        } else {
            String manualSize = request.getParameter("fileSize");
            fileSize = (manualSize != null && !manualSize.isEmpty()) ? manualSize : "N/A";
        }

        if (title != null && category != null) {
            Publication p = new Publication();
            p.setTitle(title);
            p.setCategory(category);
            p.setYear(year);
            p.setDescription(description);
            p.setFileUrl(fileUrl);
            p.setFileSize(fileSize);

            PublicationDAO pubDAO = new PublicationDAO();
            if (pubDAO.addPublication(p)) {
                response.sendRedirect("superadmin_publications.jsp?success=uploaded");
            } else {
                response.sendRedirect("superadmin_publications.jsp?error=upload_failed");
            }
        } else {
            response.sendRedirect("superadmin_publications.jsp?error=missing");
        }
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header != null) {
            for (String token : header.split(";")) {
                if (token.trim().startsWith("filename")) {
                    String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    /* Handle IE full path */
                    int idx = name.lastIndexOf(File.separator);
                    if (idx >= 0) name = name.substring(idx + 1);
                    idx = name.lastIndexOf('/');
                    if (idx >= 0) name = name.substring(idx + 1);
                    return name;
                }
            }
        }
        return "unknown_file";
    }
}
