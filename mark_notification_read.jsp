<%@ page import="com.insurance.dao.NotificationDAO" %>
<%
    String idParam = request.getParameter("id");
    if (idParam != null) {
        try {
            String id = idParam;
            NotificationDAO noteDAO = new NotificationDAO();
            noteDAO.markAsRead(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Simple redirect back to where we came from, or dashboard as default
    String referer = request.getHeader("Referer");
    if (referer != null) {
        response.sendRedirect(referer);
    } else {
        response.sendRedirect("Customerportal.jsp");
    }
%>
