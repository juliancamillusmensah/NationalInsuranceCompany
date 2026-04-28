<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.insurance.util.DBConnection" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_ADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String companyId = (String) sess.getAttribute("companyId");
    String bankName = request.getParameter("bankName");
    String accName = request.getParameter("accName");
    String accNum = request.getParameter("accNum");

    if (companyId != null && bankName != null && accName != null && accNum != null) {
        String sql = "UPDATE insurance_companies SET bank_name = ?, account_name = ?, account_number = ?, updated_at = datetime('now') WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, bankName);
            pstmt.setString(2, accName);
            pstmt.setString(3, accNum);
            pstmt.setString(4, companyId);
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                response.sendRedirect("companyadmin_settings.jsp?success=bank_updated#bank-section");
            } else {
                response.sendRedirect("companyadmin_settings.jsp?error=update_failed#bank-section");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("companyadmin_settings.jsp?error=database_error#bank-section");
        }
    } else {
        response.sendRedirect("companyadmin_settings.jsp?error=invalid_data#bank-section");
    }
%>
