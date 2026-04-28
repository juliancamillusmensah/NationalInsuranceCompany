package com.insurance.util;

import com.insurance.dao.CompanyDAO;
import com.insurance.dao.NotificationDAO;
import com.insurance.model.Company;
import com.insurance.model.Notification;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class ComplianceManager {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static void checkAllCompaniesCompliance(String adminUserId) {
        CompanyDAO companyDAO = new CompanyDAO();
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Company> companies = companyDAO.getAllCompanies();
        LocalDate today = LocalDate.now();

        for (Company c : companies) {
            String expiryStr = c.getLicenseExpiry();
            if (expiryStr == null || expiryStr.isEmpty() || "Pending".equalsIgnoreCase(expiryStr)) {
                continue;
            }

            try {
                LocalDate expiry = LocalDate.parse(expiryStr, DATE_FORMATTER);
                long daysUntilExpiry = ChronoUnit.DAYS.between(today, expiry);

                String currentStatus = c.getComplianceStatus();
                String newStatus = currentStatus;

                if (daysUntilExpiry < 0) {
                    newStatus = "Non-Compliant";
                } else if (daysUntilExpiry <= 30) {
                    newStatus = "At Risk";
                } else {
                    newStatus = "Compliant";
                }

                // Update database if status changed
                if (!newStatus.equalsIgnoreCase(currentStatus)) {
                    companyDAO.updateComplianceStatus(c.getId(), newStatus);
                    
                    // Notify Admin of status change
                    Notification note = new Notification();
                    note.setUserId(adminUserId);
                    note.setTitle("Regulatory Alert: " + c.getName());
                    note.setMessage("The compliance status for " + c.getName() + " has automatically shifted to " + newStatus + " due to license progress.");
                    note.setType(newStatus.equals("Non-Compliant") ? "Warning" : "Info");
                    notificationDAO.addNotification(note);
                }

                // Periodic Notifications for nearing expiry (30, 15, 5 days)
                if (daysUntilExpiry > 0 && (daysUntilExpiry == 30 || daysUntilExpiry == 15 || daysUntilExpiry == 5)) {
                    Notification note = new Notification();
                    note.setUserId(adminUserId);
                    note.setTitle("License Expiring Soon: " + c.getName());
                    note.setMessage(c.getName() + " has " + daysUntilExpiry + " days remaining until license expiration (" + expiryStr + ").");
                    note.setType("Warning");
                    notificationDAO.addNotification(note);
                }

            } catch (Exception e) {
                System.err.println("Error processing compliance for company " + c.getName() + ": " + e.getMessage());
            }
        }
    }
}
