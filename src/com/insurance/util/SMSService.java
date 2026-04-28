package com.insurance.util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * SMS service using Textbelt REST API (https://textbelt.com).
 * 
 * Free tier: 1 SMS/day with the public key "textbelt" — no signup required.
 * For more volume, get a paid API key at https://textbelt.com/purchase (supports 250+ countries).
 * 
 * Alternative for Ghana production: Termii (https://termii.com) — Africa-focused,
 * supports MTN/Vodafone/AirtelTigo, free sandbox with test credits.
 * 
 * Setup:
 * 1. For testing: use key "textbelt" (1 free SMS/day automatically)
 * 2. For production: purchase a key at textbelt.com or sign up at termii.com
 * 3. Add system settings in the DB:
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('sms_api_key', 'textbelt');
 *    INSERT INTO system_settings (setting_key, setting_value) VALUES ('sms_sender_id', 'NIC-Ghana');
 */
public class SMSService {

    private static final Logger LOGGER = Logger.getLogger(SMSService.class.getName());
    private static final String TEXTBELT_API_URL = "https://textbelt.com/text";

    /**
     * Send an SMS to a single phone number via Textbelt API.
     *
     * @param phone   Phone number in E.164 format (e.g. +233241234567 for Ghana)
     * @param message SMS message body (max ~160 chars for 1 SMS segment)
     * @return true if SMS was accepted for delivery, false otherwise
     */
    public static boolean sendSMS(String phone, String message) {
        String apiKey = getApiKey();
        if (apiKey == null || apiKey.isEmpty()) {
            LOGGER.warning("SMS API key not configured. Skipping SMS send.");
            return false;
        }

        if (phone == null || phone.trim().isEmpty()) {
            LOGGER.warning("No phone number provided. Skipping SMS send.");
            return false;
        }

        try {
            URL url = new URL(TEXTBELT_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(20000);

            String payload = "phone=" + URLEncoder.encode(phone.trim(), StandardCharsets.UTF_8)
                    + "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8)
                    + "&key=" + URLEncoder.encode(apiKey, StandardCharsets.UTF_8);

            try (DataOutputStream dos = new DataOutputStream(conn.getOutputStream())) {
                dos.writeBytes(payload);
                dos.flush();
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

            String responseBody = response.toString();
            boolean success = responseBody.contains("\"success\":true") || responseBody.contains("\"success\": true");
            String textId = extractJsonValue(responseBody, "textId");
            String quotaStr = extractJsonValue(responseBody, "quotaRemaining");
            String error = extractJsonValue(responseBody, "error");

            if (success) {
                LOGGER.info("SMS sent successfully to " + maskPhone(phone) + " | textId: " + textId + " | quotaRemaining: " + quotaStr);
                return true;
            } else {
                LOGGER.warning("SMS send failed for " + maskPhone(phone) + ": " + (error != null ? error : responseBody));
                return false;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to send SMS to " + maskPhone(phone), e);
            return false;
        }
    }

    /**
     * Send a notification-style SMS. Automatically truncates if message exceeds 1 SMS segment.
     */
    public static boolean sendNotificationSMS(String phone, String title, String message) {
        String body = title + ": " + message;
        if (body.length() > 160) {
            body = body.substring(0, 157) + "...";
        }
        return sendSMS(phone, body);
    }

    /**
     * Send an SMS for a claim notification to admins.
     */
    public static boolean sendClaimAlertSMS(String phone, String claimantName, String claimId) {
        String message = "New claim submitted by " + claimantName + ". Ref: " + claimId + ". Please review.";
        if (message.length() > 160) {
            message = message.substring(0, 157) + "...";
        }
        return sendSMS(phone, message);
    }

    private static String getApiKey() {
        try {
            return new com.insurance.dao.SystemDAO().getSystemSetting("sms_api_key");
        } catch (Exception e) {
            LOGGER.warning("Could not read sms_api_key: " + e.getMessage());
            return null;
        }
    }

    private static String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\"";
        int idx = json.indexOf(searchKey);
        if (idx < 0) return null;
        idx = json.indexOf(":", idx + searchKey.length());
        if (idx < 0) return null;
        idx++; // Move past the colon
        while (idx < json.length() && json.charAt(idx) == ' ') idx++;
        if (idx >= json.length()) return null;
        char c = json.charAt(idx);
        if (c == '"') {
            int start = idx + 1;
            int end = json.indexOf("\"", start);
            return end > start ? json.substring(start, end) : null;
        } else if (c == 'n') {
            return null;
        } else {
            int start = idx;
            int end = start;
            while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && json.charAt(end) != ' ') {
                end++;
            }
            return json.substring(start, end);
        }
    }

    private static String maskPhone(String phone) {
        if (phone == null || phone.length() < 4) return phone;
        return phone.substring(0, phone.length() - 4).replaceAll(".", "*") + phone.substring(phone.length() - 4);
    }
}
