<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    Account currentUser = (Account) sess.getAttribute("user");
    AccountDAO accountDAO = new AccountDAO();
    String action = request.getParameter("action");

    if ("update_profile".equals(action)) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        if (fullName != null && !fullName.isEmpty() && email != null && !email.isEmpty()) {
            if (accountDAO.updateProfile(currentUser.getId(), fullName, email)) {
                // Update session object
                currentUser.setFullName(fullName);
                currentUser.setEmail(email);
                sess.setAttribute("user", currentUser);
                response.sendRedirect("account_settings.jsp?success=profile_updated");
            } else {
                response.sendRedirect("account_settings.jsp?error=update_failed");
            }
        } else {
            response.sendRedirect("account_settings.jsp?error=invalid_input");
        }
    } else if ("update_password".equals(action)) {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword != null && !newPassword.isEmpty() && newPassword.equals(confirmPassword)) {
            if (accountDAO.updatePassword(currentUser.getId(), newPassword)) {
                // Update session object password (optional, but good for consistency)
                currentUser.setPassword(newPassword);
                sess.setAttribute("user", currentUser);
                response.sendRedirect("account_settings.jsp?success=password_updated");
            } else {
                response.sendRedirect("account_settings.jsp?error=update_failed");
            }
        } else {
            response.sendRedirect("account_settings.jsp?error=pass_mismatch");
        }
    } else {
        response.sendRedirect("account_settings.jsp");
    }
%>
