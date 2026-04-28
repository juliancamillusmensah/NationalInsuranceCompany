package com.insurance.util;

import com.insurance.dao.AccountDAO;
import com.insurance.model.Account;

public class RegisterTest {
    public static void main(String[] args) {
        System.out.println("Testing registration with lowercase 'active'...");

        Account account = new Account();
        account.setFullName("Test Customer");
        account.setEmail("testcustomer_" + System.currentTimeMillis() + "@example.com");
        account.setPassword("password123");
        account.setRoleId("ROLE_CUSTOMER");
        account.setStatus("active"); // lowercase to match CHECK constraint

        System.out.println("Account: " + account.getFullName() + " / " + account.getEmail());
        System.out.println("Status value: '" + account.getStatus() + "'");

        AccountDAO dao = new AccountDAO();
        boolean result = dao.addAccount(account);

        System.out.println("Result: " + result);

        // List all accounts
        System.out.println("\nAccounts after insert:");
        for (Account a : dao.getAllAccounts()) {
            System.out.println("- " + a.getEmail() + " (role=" + a.getRoleId() + ", status=" + a.getStatus() + ")");
        }
    }
}
