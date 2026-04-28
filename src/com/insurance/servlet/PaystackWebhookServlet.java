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

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Logger;

/**
 * Handles Paystack webhook notifications for asynchronous payment confirmation.
 * Configure this URL in your Paystack Dashboard > Settings > Webhooks.
 * URL: https://yourdomain.com/NationalInsuranceCompany/paystack/webhook
 */
@WebServlet("/paystack/webhook")
public class PaystackWebhookServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaystackWebhookServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read the webhook payload
        StringBuilder payload = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                payload.append(line);
            }
        }

        String body = payload.toString();

        // Extract event type
        String event = extractJsonValue(body, "event");

        if ("charge.success".equals(event)) {
            // Extract reference from the data object
            String reference = extractNestedValue(body, "data", "reference");

            if (reference != null && !reference.isEmpty()) {
                // Verify with Paystack to confirm it's legitimate
                VerificationResult result = PaystackService.verifyTransaction(reference);

                if (result.isSuccess()) {
                    LOGGER.info("Paystack webhook: Payment confirmed for ref " + reference);

                    // Determine transaction type from reference prefix
                    if (reference.startsWith("NIC-LIC-")) {
                        // License renewal — already handled by callback, webhook is backup
                        LOGGER.info("License renewal payment confirmed via webhook: " + reference);
                    } else if (reference.startsWith("NIC-ENR-")) {
                        // Enrollment — already handled by callback, webhook is backup
                        LOGGER.info("Enrollment payment confirmed via webhook: " + reference);
                    }
                } else {
                    LOGGER.warning("Paystack webhook: Verification failed for ref " + reference);
                }
            }
        }

        // Always return 200 to acknowledge receipt
        response.setStatus(200);
    }

    private static String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\"";
        int idx = json.indexOf(searchKey);
        if (idx < 0) return null;
        idx = json.indexOf(":", idx + searchKey.length());
        if (idx < 0) return null;
        while (idx < json.length() && json.charAt(idx) == ' ') idx++;
        if (idx >= json.length()) return null;
        char c = json.charAt(idx);
        if (c == '"') {
            int start = idx + 1;
            int end = json.indexOf("\"", start);
            return end > start ? json.substring(start, end) : null;
        }
        return null;
    }

    private static String extractNestedValue(String json, String parentKey, String childKey) {
        String searchKey = "\"" + parentKey + "\"";
        int idx = json.indexOf(searchKey);
        if (idx < 0) return null;
        int braceIdx = json.indexOf("{", idx + searchKey.length());
        if (braceIdx < 0) return null;
        String childSearch = "\"" + childKey + "\"";
        int childIdx = json.indexOf(childSearch, braceIdx);
        if (childIdx < 0) return null;
        int colonIdx = json.indexOf(":", childIdx + childSearch.length());
        if (colonIdx < 0) return null;
        while (colonIdx < json.length() && json.charAt(colonIdx) == ' ') colonIdx++;
        if (colonIdx >= json.length()) return null;
        char c = json.charAt(colonIdx);
        if (c == '"') {
            int start = colonIdx + 1;
            int end = json.indexOf("\"", start);
            return end > start ? json.substring(start, end) : null;
        }
        return null;
    }
}
