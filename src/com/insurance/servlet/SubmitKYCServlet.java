package com.insurance.servlet;

import com.insurance.dao.AccountDAO;
import com.insurance.model.Account;

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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/SubmitKYCServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB (Total for two files)
    maxRequestSize = 1024 * 1024 * 30     // 30MB
)
public class SubmitKYCServlet extends HttpServlet {

    private static final String UPLOAD_DIR_NAME = "NIC_Insurance_Uploads" + File.separator + "kyc";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        Account user = (Account) session.getAttribute("user");
        String docType = request.getParameter("docType");
        
        String idCardPath = null;
        String portraitPath = null;
        
        try {
            // Handle ID Card Upload
            Part idPart = request.getPart("idCard");
            if (idPart != null && idPart.getSize() > 0) {
                idCardPath = saveFile(idPart, "id_");
            }
            
            // Handle Portrait Upload
            Part portraitPart = request.getPart("portrait");
            if (portraitPart != null && portraitPart.getSize() > 0) {
                portraitPath = saveFile(portraitPart, "portrait_");
            }
            
            if (idCardPath != null && portraitPath != null) {
                AccountDAO accountDAO = new AccountDAO();
                boolean success = accountDAO.submitKYC(user.getId(), docType, idCardPath, portraitPath);
                
                if (success) {
                    // Refresh session user object
                    user.setKycStatus("Pending");
                    user.setKycDocumentType(docType);
                    user.setKycDocumentPath(idCardPath);
                    user.setKycPortraitPath(portraitPath);
                    session.setAttribute("user", user);
                    
                    response.sendRedirect("customer_profile.jsp?kycSubmitted=true");
                } else {
                    response.sendRedirect("customer_profile.jsp?error=db_update_failed");
                }
            } else {
                response.sendRedirect("customer_profile.jsp?error=files_missing");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customer_profile.jsp?error=upload_failed");
        }
    }

    private String saveFile(Part part, String prefix) throws IOException {
        String fileName = extractFileName(part);
        if (fileName != null && !fileName.isEmpty()) {
            String cleanFileName = prefix + UUID.randomUUID().toString() + "_" + fileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
            
            String userHome = System.getProperty("user.home");
            File uploadDir = new File(userHome, UPLOAD_DIR_NAME);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            File targetFile = new File(uploadDir, cleanFileName);
            try (InputStream fileContent = part.getInputStream()) {
                Files.copy(fileContent, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                return cleanFileName;
            }
        }
        return null;
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
