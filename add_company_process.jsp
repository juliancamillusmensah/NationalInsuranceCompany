<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String status = request.getParameter("status");
    String companyType = request.getParameter("companyType");
    String licenseNumber = request.getParameter("licenseNumber");
    String licenseExpiry = request.getParameter("licenseExpiry");
    String complianceStatus = request.getParameter("complianceStatus");
    String tin = request.getParameter("tin");
    String redirect = request.getParameter("redirect");
    
    if (redirect == null || redirect.isEmpty()) {
        redirect = "superadmin_companies.jsp";
    }

    if (name != null && email != null) {
        Company c = new Company();
        c.setName(name);
        c.setEmail(email);
        c.setPhoneNumber(phone);
        c.setAddress(address);
        c.setStatus(status != null ? status : "Active");
        c.setCompanyType(companyType);
        c.setLicenseNumber(licenseNumber);
        c.setLicenseExpiry(licenseExpiry);
        c.setComplianceStatus(complianceStatus != null ? complianceStatus : "Compliant");
        c.setTin(tin);

        CompanyDAO companyDAO = new CompanyDAO();
        if (companyDAO.addCompany(c)) {
            response.sendRedirect(redirect + "?success=1");
        } else {
            response.sendRedirect(redirect + "?error=1");
        }
    } else {
        response.sendRedirect(redirect + "?error=missing");
    }
%>
