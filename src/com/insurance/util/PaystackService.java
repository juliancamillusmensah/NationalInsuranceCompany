package com.insurance.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Paystack payment gateway integration for Ghana (GHS).
 * 
 * Setup:
 * 1. Sign up at https://paystack.com (free test mode, 1.5% + GH₵1 per live transaction)
 * 2. Get your API keys from Settings > API Keys
 * 3. Add system settings in the DB:
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('paystack_secret_key', 'sk_test_xxxxxxxxxxxxx');
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('paystack_public_key', 'pk_test_xxxxxxxxxxxxx');
 * 4. For live mode, use sk_live_ / pk_live_ keys instead
 * 
 * Flow:
 * - Frontend: Paystack Inline JS popup → user pays → redirect to callback URL
 * - Backend:  PaystackCallbackServlet verifies transaction via this service
 */
public class PaystackService {

    private static final Logger LOGGER = Logger.getLogger(PaystackService.class.getName());
    private static final String INITIALIZE_URL = "https://api.paystack.co/transaction/initialize";
    private static final String VERIFY_URL = "https://api.paystack.co/transaction/verify/";

    /**
     * Initialize a Paystack transaction (server-side).
     * Returns the authorization URL to redirect the user to, or null on failure.
     * 
     * @param email     Customer email
     * @param amountGHS Amount in GHS (will be converted to kobo/cents)
     * @param reference Unique transaction reference
     * @param callbackUrl URL Paystack redirects to after payment
     * @return Authorization URL, or null on failure
     */
    public static String initializeTransaction(String email, double amountGHS, String reference, String callbackUrl) {
        String secretKey = getSecretKey();
        if (secretKey == null || secretKey.isEmpty()) {
            LOGGER.severe("Paystack secret key not configured.");
            return null;
        }

        // Paystack expects amount in kobo (1 GHS = 100 pesewas/kobo)
        long amountKobo = Math.round(amountGHS * 100);

        String jsonPayload = "{" +
            "\"email\":\"" + escapeJson(email) + "\"," +
            "\"amount\":" + amountKobo + "," +
            "\"reference\":\"" + escapeJson(reference) + "\"," +
            "\"currency\":\"GHS\"," +
            "\"callback_url\":\"" + escapeJson(callbackUrl) + "\"" +
            "}";

        try {
            URL url = new URL(INITIALIZE_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + secretKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(20000);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                        responseCode >= 400 ? conn.getErrorStream() : conn.getInputStream(),
                        StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode >= 200 && responseCode < 300) {
                // Extract authorization_url from JSON response
                String authUrl = extractJsonValue(response.toString(), "authorization_url");
                if (authUrl != null) {
                    LOGGER.info("Paystack transaction initialized. Ref: " + reference + " | Auth URL: " + authUrl);
                    return authUrl;
                }
            }

            LOGGER.severe("Paystack initialize failed. HTTP " + responseCode + ": " + response.toString());
            return null;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize Paystack transaction", e);
            return null;
        }
    }

    /**
     * Verify a Paystack transaction by reference.
     * Returns a VerificationResult with status and details.
     */
    public static VerificationResult verifyTransaction(String reference) {
        String secretKey = getSecretKey();
        if (secretKey == null || secretKey.isEmpty()) {
            return new VerificationResult(false, "Paystack secret key not configured", null, 0, null);
        }

        try {
            URL url = new URL(VERIFY_URL + escapeJson(reference));
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + secretKey);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(20000);

            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                        responseCode >= 400 ? conn.getErrorStream() : conn.getInputStream(),
                        StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line);
                }
            }

            if (responseCode >= 200 && responseCode < 300) {
                String responseBody = response.toString();
                String status = extractJsonValue(responseBody, "status");
                String gatewayStatus = extractNestedValue(responseBody, "data", "status");
                String trxRef = extractNestedValue(responseBody, "data", "reference");
                String amountStr = extractNestedValue(responseBody, "data", "amount");
                String paidAt = extractNestedValue(responseBody, "data", "paid_at");
                String channel = extractNestedValue(responseBody, "data", "channel");

                boolean success = "true".equals(status) && "success".equalsIgnoreCase(gatewayStatus);
                long amountKobo = 0;
                try { amountKobo = Long.parseLong(amountStr != null ? amountStr : "0"); } catch (NumberFormatException e) {}

                if (success) {
                    LOGGER.info("Paystack payment verified. Ref: " + reference + " | Amount: " + (amountKobo / 100.0) + " GHS | Channel: " + channel);
                } else {
                    LOGGER.warning("Paystack payment NOT verified. Ref: " + reference + " | Status: " + gatewayStatus);
                }

                return new VerificationResult(success, gatewayStatus, trxRef, amountKobo, channel);
            }

            LOGGER.severe("Paystack verify failed. HTTP " + responseCode + ": " + response.toString());
            return new VerificationResult(false, "HTTP " + responseCode, null, 0, null);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to verify Paystack transaction", e);
            return new VerificationResult(false, "Exception: " + e.getMessage(), null, 0, null);
        }
    }

    /**
     * Get the Paystack public key for frontend inline JS popup.
     */
    public static String getPublicKey() {
        try {
            String key = new com.insurance.dao.SystemDAO().getSystemSetting("paystack_public_key");
            return (key != null && !key.isEmpty()) ? key : "";
        } catch (Exception e) {
            return "";
        }
    }

    private static String getSecretKey() {
        try {
            return new com.insurance.dao.SystemDAO().getSystemSetting("paystack_secret_key");
        } catch (Exception e) {
            LOGGER.warning("Could not read paystack_secret_key: " + e.getMessage());
            return null;
        }
    }

    // Simple JSON value extraction (no external JSON library needed)
    private static String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\"";
        int idx = json.indexOf(searchKey);
        if (idx < 0) return null;
        idx = json.indexOf(":", idx + searchKey.length());
        if (idx < 0) return null;
        idx++; // Move past the colon

        // Skip whitespace
        while (idx < json.length() && json.charAt(idx) == ' ') idx++;
        if (idx >= json.length()) return null;

        char c = json.charAt(idx);
        if (c == '"') {
            int start = idx + 1;
            int end = json.indexOf("\"", start);
            return end > start ? json.substring(start, end) : null;
        } else if (c == 'n') {
            return null; // null value
        } else {
            // Number or boolean
            int start = idx;
            int end = start;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && json.charAt(end) != ' ') {
                end++;
            }
            return json.substring(start, end);
        }
    }

    private static String extractNestedValue(String json, String parentKey, String childKey) {
        String searchKey = "\"" + parentKey + "\"";
        int idx = json.indexOf(searchKey);
        if (idx < 0) return null;
        // Find the opening brace of the nested object
        int braceIdx = json.indexOf("{", idx + searchKey.length());
        if (braceIdx < 0) return null;
        // Find the child key within this section
        String childSearch = "\"" + childKey + "\"";
        int childIdx = json.indexOf(childSearch, braceIdx);
        if (childIdx < 0) return null;
        // Find the value
        int colonIdx = json.indexOf(":", childIdx + childSearch.length());
        if (colonIdx < 0) return null;
        colonIdx++; // Move past the colon
        while (colonIdx < json.length() && json.charAt(colonIdx) == ' ') colonIdx++;
        if (colonIdx >= json.length()) return null;

        char c = json.charAt(colonIdx);
        if (c == '"') {
            int start = colonIdx + 1;
            int end = json.indexOf("\"", start);
            return end > start ? json.substring(start, end) : null;
        } else if (c == 'n') {
            return null;
        } else {
            int start = colonIdx;
            int end = start;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && json.charAt(end) != ' ') {
                end++;
            }
            return json.substring(start, end);
        }
    }

    private static String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "").replace("\t", "\\t");
    }

    /**
     * Result of a Paystack transaction verification.
     */
    public static class VerificationResult {
        private final boolean success;
        private final String status;
        private final String reference;
        private final long amountKobo;
        private final String channel;

        public VerificationResult(boolean success, String status, String reference, long amountKobo, String channel) {
            this.success = success;
            this.status = status;
            this.reference = reference;
            this.amountKobo = amountKobo;
            this.channel = channel;
        }

        public boolean isSuccess() { return success; }
        public String getStatus() { return status; }
        public String getReference() { return reference; }
        public long getAmountKobo() { return amountKobo; }
        public double getAmountGHS() { return amountKobo / 100.0; }
        public String getChannel() { return channel != null ? channel : "paystack"; }
    }
}
