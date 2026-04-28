<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String userId = (String) sess.getAttribute(\"userId\");
    String cpIdParam = request.getParameter("cpId");

    if (cpIdParam != null) {
        try {
            int cpId = Integer.parseInt(cpIdParam);
            PolicyDAO policyDAO = new PolicyDAO();
            boolean cancelled = policyDAO.cancelPolicy(cpId);

            if (cancelled) {
                NotificationDAO noteDAO = new NotificationDAO();
                Notification note = new Notification();
                note.setUserId(userId);
                note.setTitle("Policy Cancelled");
                note.setMessage("Your policy (Enrollment ID: " + cpId + ") has been cancelled successfully.");
                note.setType("info");
                noteDAO.addNotification(note);

                response.sendRedirect("Customerportal.jsp?success=cancelled");
            } else {
                response.sendRedirect("Customerportal.jsp?error=cancel_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Customerportal.jsp?error=exception");
        }
    } else {
        response.sendRedirect("Customerportal.jsp");
    }
%>
