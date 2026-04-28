package com.insurance.servlet;

import com.insurance.dao.ClaimDAO;
import com.insurance.dao.AccountDAO;
import com.insurance.dao.SystemDAO;
import com.insurance.model.Claim;
import com.insurance.model.Account;
import com.insurance.util.EmailService;

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
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/SubmitClaimServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 15     // 15MB
)
public class SubmitClaimServlet extends HttpServlet {

    private static final String UPLOAD_DIR_NAME = "NIC_Insurance_Uploads" + File.separator + "claims";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        Account user = (Account) session.getAttribute("user");
        
        String policyId = request.getParameter("policyId");
        String claimAmountStr = request.getParameter("claimAmount");
        String incidentDate = request.getParameter("incidentDate");
        String description = request.getParameter("description");
        
        String documentPath = null;
        
        try {
            Part filePart = request.getPart("evidence");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    String cleanFileName = UUID.randomUUID().toString() + "_" + fileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
                    
                    String userHome = System.getProperty("user.home");
                    File uploadDir = new File(userHome, UPLOAD_DIR_NAME);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    File targetFile = new File(uploadDir, cleanFileName);
                    
                    try (InputStream fileContent = filePart.getInputStream()) {
                        Files.copy(fileContent, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        // Save relative path for DB
                        documentPath = cleanFileName;
                    }
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            System.err.println("File upload failed: " + e.getMessage());
        }

        Claim claim = new Claim();
        claim.setUserId(user.getId());
        claim.setPolicyId(policyId);
        try {
            claim.setClaimAmount(new BigDecimal(claimAmountStr));
        } catch (Exception e) {
            claim.setClaimAmount(BigDecimal.ZERO);
        }
        claim.setIncidentDate(incidentDate);
        claim.setDescription(description);
        claim.setDocumentPath(documentPath);

        ClaimDAO claimDAO = new ClaimDAO();
        boolean success = claimDAO.addClaim(claim);

        if (success) {
            // Notify company admin via email about the new claim
            try {
                SystemDAO sysDAO = new SystemDAO();
                String companyId = sysDAO.getCompanyIdByUserId(user.getId());
                if (companyId != null) {
                    java.util.List<com.insurance.model.TeamMember> team = sysDAO.getTeamMembersByCompanyId(companyId);
                    for (com.insurance.model.TeamMember member : team) {
                        if (member.getRoleId() != null && member.getRoleId().contains("ADMIN")) {
                            EmailService.sendClaimNotificationEmail(
                                member.getEmail(),
                                claim.getId() != null ? claim.getId() : "New Claim",
                                claim.getClaimAmount() != null ? claim.getClaimAmount().toString() : "0",
                                policyId != null ? policyId : "N/A",
                                user.getFullName()
                            );
                        }
                    }
                }
            } catch (Exception emEx) {
                System.err.println("WARNING: Failed to send claim notification email: " + emEx.getMessage());
            }
            response.sendRedirect("Customerportal.jsp?claimSubmitted=true");
        } else {
            response.sendRedirect("customer_new_claim.jsp?error=submit_failed");
        }
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
