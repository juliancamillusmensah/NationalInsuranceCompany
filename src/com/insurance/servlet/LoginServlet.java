package com.insurance.servlet;

import com.insurance.dao.AccountDAO;
import com.insurance.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private com.insurance.dao.SystemDAO systemDAO = new com.insurance.dao.SystemDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null)
            email = email.trim();
        if (password != null)
            password = password.trim();

        Account account = accountDAO.authenticate(email, password);

        if (account != null && "active".equalsIgnoreCase(account.getStatus())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", account);
            session.setAttribute("userId", account.getId());
            session.setAttribute("roleId", account.getRoleId());
            
            // Resolve companyId for Company Admins, Support, and Auditors
            if ("ROLE_ADMIN".equals(account.getRoleId()) || 
                "ROLE_SUPPORT".equals(account.getRoleId()) || 
                "ROLE_AUDITOR".equals(account.getRoleId())) {
                String companyId = systemDAO.getCompanyIdByUserId(account.getId());
                session.setAttribute("companyId", companyId);
            }
            
            response.sendRedirect("auth_redirect.jsp");
        } else {
            response.sendRedirect("allloginpage.jsp?error=invalid");
        }
    }
}
