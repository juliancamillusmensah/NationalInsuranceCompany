package com.insurance.servlet;

import com.insurance.dao.*;
import com.insurance.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.insurance.util.DBConnection;

@WebServlet("/register-admin")
public class AdminRegisterServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private SystemDAO systemDAO = new SystemDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String fullName = request.getParameter("full_name") != null ? request.getParameter("full_name").trim() : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";
        String confirmPassword = request.getParameter("confirm_password") != null ? request.getParameter("confirm_password").trim() : "";

        if (token == null || token.isEmpty()) {
            response.sendRedirect("allloginpage.jsp?error=invalid_invitation");
            return;
        }

        AdminInvitation invite = systemDAO.getInvitationByToken(token);
        if (invite == null || invite.isUsed()) {
            response.sendRedirect("allloginpage.jsp?error=invalid_invitation");
            return;
        }

        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("register_admin.jsp?token=" + token + "&error=passwords_mismatch");
            return;
        }

        // 1. Create the Account
        Account account = new Account();
        account.setFullName(fullName);
        account.setEmail(invite.getEmail());
        account.setPassword(password);
        String roleId = systemDAO.getRoleIdByName(invite.getInvitedRole());
        account.setRoleId(roleId);
        account.setStatus("active");

        boolean success = accountDAO.addAccount(account);
        if (success) {
            // Need to get the newly created user ID to link to company_admins
            // Since AccountDAO.addAccount doesn't return the ID, we fetch it by email
            Account newUser = accountDAO.getAccountByEmail(invite.getEmail());
            if (newUser != null) {
                // 2. Link to company_admins
                linkAdminToCompany(newUser.getId(), invite.getCompanyId());
                
                // 3. Mark invitation as used
                invite.setUsed(true);
                systemDAO.updateInvitation(invite);
                
                response.sendRedirect("allloginpage.jsp?registered=true");
            } else {
                response.sendRedirect("register_admin.jsp?token=" + token + "&error=failed");
            }
        } else {
            response.sendRedirect("register_admin.jsp?token=" + token + "&error=failed");
        }
    }

    private void linkAdminToCompany(String userId, String companyId) {
        String sql = "INSERT INTO company_admins (user_id, company_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, companyId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
