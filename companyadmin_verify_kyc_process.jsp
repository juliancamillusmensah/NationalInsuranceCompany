<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    String roleId = (sess != null && sess.getAttribute("roleId") != null) ? (String) sess.getAttribute("roleId") : null;
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(roleId)) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String userId = request.getParameter("userId");
    String status = request.getParameter("status"); // Verified or Rejected
    String redirect = request.getParameter("redirect");
    if (redirect == null) redirect = "superadmin_kyc.jsp";

    if (userId != null && status != null) {
        AccountDAO accountDAO = new AccountDAO();
        if (accountDAO.verifyKYC(userId, status)) {
            // Also notify the user
            NotificationDAO noteDAO = new NotificationDAO();
            Notification note = new Notification();
            note.setUserId(userId);
            note.setTitle("Identity Verification " + status);
            note.setType("Verified".equals(status) ? "Success" : "Warning");
            
            if ("Verified".equals(status)) {
                note.setMessage("Congratulations! Your identity has been verified. Your account is now fully compliant.");
            } else {
                note.setMessage("Your identity verification was rejected. Please re-upload clear documents in your profile.");
            }
            
            noteDAO.addNotification(note);
            
            response.sendRedirect(redirect + "?kycUpdate=success");
        } else {
            response.sendRedirect(redirect + "?error=update_failed");
        }
    } else {
        response.sendRedirect(redirect + "?error=invalid_params");
    }
%>
