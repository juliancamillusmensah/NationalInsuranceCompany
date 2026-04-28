package com.insurance.servlet;

import com.insurance.dao.PolicyDAO;
import com.insurance.dao.TransactionDAO;
import com.insurance.dao.NotificationDAO;
import com.insurance.dao.SystemDAO;
import com.insurance.model.Account;
import com.insurance.model.Notification;
import com.insurance.util.PaystackService;

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

@WebServlet("/enrollAction")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,   // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class EnrollmentServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "enrollments";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        Account user = (Account) session.getAttribute("user");
        String userId = user.getId();
        
        String policyId = request.getParameter("policyId");
        String premiumParam = request.getParameter("premiumAmount");
        String paymentMethod = request.getParameter("paymentMethod");
        String insuredItem = request.getParameter("insuredItem");
        
        try {
            BigDecimal premium = new BigDecimal(premiumParam);

            // Handle Document Upload directly within the web app context
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String documentPath = null;
            Part documentPart = request.getPart("document");
            if (documentPart != null && documentPart.getSize() > 0) {
                String originalFileName = extractFileName(documentPart);
                if (originalFileName != null && !originalFileName.isEmpty()) {
                    String cleanFileName = UUID.randomUUID().toString() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9.\\-]", "_");
                    File targetFile = new File(uploadDir, cleanFileName);
                    
                    try (InputStream fileContent = documentPart.getInputStream()) {
                        Files.copy(fileContent, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        // Save the relative path
                        documentPath = UPLOAD_DIR + File.separator + cleanFileName;
                        // Replace OS specific separators for consistent web rendering
                        documentPath = documentPath.replace("\\", "/");
                    }
                }
            }

            // Check if Paystack is configured
            SystemDAO systemDAO = new SystemDAO();
            String paystackKey = systemDAO.getSystemSetting("paystack_secret_key");
            boolean usePaystack = paystackKey != null && !paystackKey.isEmpty() && !paystackKey.startsWith("pk_test_XXX") && !paystackKey.startsWith("sk_test_XXX");

            if (usePaystack) {
                // Paystack flow: save data in session, initialize transaction, redirect
                session.setAttribute("paystack_policy_id", policyId);
                session.setAttribute("paystack_insured_item", insuredItem);
                session.setAttribute("paystack_document_path", documentPath);
                session.setAttribute("paystack_premium_amount", premium);
                session.setAttribute("paystack_user_id", userId);

                String reference = "NIC-ENR-" + java.util.UUID.randomUUID().toString().substring(0, 12).toUpperCase();
                String callbackUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                        + request.getContextPath() + "/paystack/callback?trx_type=enrollment";

                String authUrl = PaystackService.initializeTransaction(user.getEmail(), premium.doubleValue(), reference, callbackUrl);

                if (authUrl != null) {
                    response.sendRedirect(authUrl);
                    return;
                } else {
                    // Fallback to direct enrollment if Paystack init fails
                    System.err.println("WARNING: Paystack initialization failed. Falling back to direct enrollment.");
                }
            }

            // Direct enrollment fallback (or if Paystack not configured)
            PolicyDAO policyDAO = new PolicyDAO();
            TransactionDAO transactionDAO = new TransactionDAO();

            boolean enrolled = policyDAO.enrollPolicy(userId, policyId, insuredItem, documentPath);
            
            if (enrolled) {
                transactionDAO.recordTransaction(userId, policyId, premium, "Enrollment", paymentMethod != null ? paymentMethod : "Direct");
                
                NotificationDAO noteDAO = new NotificationDAO();
                Notification note = new Notification();
                note.setUserId(userId);
                note.setTitle("Policy Enrolled!");
                note.setMessage("You have successfully enrolled in policy " + policyId + " insuring: " + insuredItem + ".");
                note.setType("Success");
                noteDAO.addNotification(note);

                response.sendRedirect("Customerportal.jsp?success=enroll");
            } else {
                response.sendRedirect("customer_explore_policies.jsp?error=enroll_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customer_explore_policies.jsp?error=exception&msg=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
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
