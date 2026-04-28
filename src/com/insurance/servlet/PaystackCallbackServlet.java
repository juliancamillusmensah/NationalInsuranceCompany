package com.insurance.servlet;

import com.insurance.dao.*;
import com.insurance.model.*;
import com.insurance.util.PaystackService;
import com.insurance.util.PaystackService.VerificationResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Handles the Paystack payment callback redirect.
 * Paystack redirects here after the user completes payment on the popup.
 * This servlet verifies the transaction and processes the enrollment or license renewal.
 */
@WebServlet("/paystack/callback")
public class PaystackCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reference = request.getParameter("reference");
        String trxType = request.getParameter("trx_type"); // "enrollment" or "license_renewal"

        if (reference == null || reference.isEmpty()) {
            response.sendRedirect("Customerportal.jsp?error=payment_invalid");
            return;
        }

        // Verify the transaction with Paystack
        VerificationResult result = PaystackService.verifyTransaction(reference);

        if (!result.isSuccess()) {
            if ("license_renewal".equals(trxType)) {
                response.sendRedirect("license_renewal_checkout.jsp?error=payment_failed&status=" + result.getStatus());
            } else {
                response.sendRedirect("customer_explore_policies.jsp?error=payment_failed&status=" + result.getStatus());
            }
            return;
        }

        // Payment verified — process based on transaction type
        if ("license_renewal".equals(trxType)) {
            processLicenseRenewal(request, response, result);
        } else {
            processEnrollment(request, response, result);
        }
    }

    private void processEnrollment(HttpServletRequest request, HttpServletResponse response, VerificationResult result)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        Account user = (Account) session.getAttribute("user");
        String userId = user.getId();

        // Retrieve pending enrollment details from session (set before Paystack popup)
        String policyId = (String) session.getAttribute("paystack_policy_id");
        String insuredItem = (String) session.getAttribute("paystack_insured_item");
        String documentPath = (String) session.getAttribute("paystack_document_path");
        BigDecimal premium = (BigDecimal) session.getAttribute("paystack_premium_amount");

        if (policyId == null || premium == null) {
            response.sendRedirect("customer_explore_policies.jsp?error=payment_session_expired");
            return;
        }

        // Record the transaction with Paystack reference
        TransactionDAO transactionDAO = new TransactionDAO();
        String paymentMethod = "Paystack (" + result.getChannel() + ")";
        boolean recorded = transactionDAO.recordTransaction(userId, policyId, premium, "Enrollment", paymentMethod);

        if (recorded) {
            // Enroll the policy
            PolicyDAO policyDAO = new PolicyDAO();
            boolean enrolled = policyDAO.enrollPolicy(userId, policyId,
                insuredItem != null ? insuredItem : "General Coverage",
                documentPath);

            if (enrolled) {
                // Add notification
                NotificationDAO noteDAO = new NotificationDAO();
                Notification note = new Notification();
                note.setUserId(userId);
                note.setTitle("Policy Enrolled!");
                note.setMessage("You have successfully enrolled in policy " + policyId + ". Payment of GHS " + result.getAmountGHS() + " confirmed via Paystack.");
                note.setType("Success");
                noteDAO.addNotification(note);

                // Clean up session
                session.removeAttribute("paystack_policy_id");
                session.removeAttribute("paystack_insured_item");
                session.removeAttribute("paystack_document_path");
                session.removeAttribute("paystack_premium_amount");

                response.sendRedirect("Customerportal.jsp?success=enroll&ref=" + result.getReference());
                return;
            }
        }

        response.sendRedirect("customer_explore_policies.jsp?error=enroll_failed");
    }

    private void processLicenseRenewal(HttpServletRequest request, HttpServletResponse response, VerificationResult result)
            throws IOException {

        HttpSession session = request.getSession(false);
        String roleId = (session != null) ? (String) session.getAttribute("roleId") : null;
        Account currentUser = (session != null) ? (Account) session.getAttribute("user") : null;

        if (session == null || currentUser == null) {
            response.sendRedirect("allloginpage.jsp");
            return;
        }

        String companyId = (String) session.getAttribute("paystack_company_id");
        String licenseExpiry = (String) session.getAttribute("paystack_license_expiry");
        BigDecimal feeAmount = (BigDecimal) session.getAttribute("paystack_fee_amount");

        if (companyId == null || licenseExpiry == null || feeAmount == null) {
            String redirectPage = "ROLE_SUPERADMIN".equals(roleId) ? "superadmin_companies.jsp" : "Companyadmin.jsp";
            response.sendRedirect(redirectPage + "?error=payment_session_expired");
            return;
        }

        // Security check for company admin
        if ("ROLE_ADMIN".equals(roleId)) {
            String sessionCompanyId = (String) session.getAttribute("companyId");
            if (!companyId.equals(sessionCompanyId)) {
                response.sendRedirect("Companyadmin.jsp?error=unauthorized");
                return;
            }
        }

        // Record transaction
        TransactionDAO transactionDAO = new TransactionDAO();
        String paymentMethod = "Paystack (" + result.getChannel() + ")";
        transactionDAO.recordTransaction(currentUser.getId(), "NIC-LICENSE-FEE", feeAmount, "License Renewal", paymentMethod);

        // Update license
        CompanyDAO companyDAO = new CompanyDAO();
        if (companyDAO.renewLicense(companyId, licenseExpiry)) {
            com.insurance.util.ComplianceManager.checkAllCompaniesCompliance(roleId);

            // Clean up session
            session.removeAttribute("paystack_company_id");
            session.removeAttribute("paystack_license_expiry");
            session.removeAttribute("paystack_fee_amount");

            String redirectPage = "ROLE_SUPERADMIN".equals(roleId) ? "superadmin_companies.jsp" : "Companyadmin.jsp";
            response.sendRedirect(redirectPage + "?success=renewed&ref=" + result.getReference());
        } else {
            String redirectPage = "ROLE_SUPERADMIN".equals(roleId) ? "superadmin_companies.jsp" : "Companyadmin.jsp";
            response.sendRedirect(redirectPage + "?error=renewal_failed");
        }
    }
}
