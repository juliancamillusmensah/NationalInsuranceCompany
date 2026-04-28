package com.insurance.servlet;

import com.insurance.dao.AccountDAO;
import com.insurance.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet2 extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("registercustomer.jsp?error=passwords_mismatch");
            return;
        }

        Account account = new Account();
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPassword(password);
        account.setRoleId("ROLE_CUSTOMER"); // Customer role
        account.setStatus("active");

        boolean success = accountDAO.addAccount(account);

        if (success) {
            response.sendRedirect("allloginpage.jsp?registered=true");
        } else {
            response.sendRedirect("registercustomer.jsp?error=failed");
        }
    }
}
