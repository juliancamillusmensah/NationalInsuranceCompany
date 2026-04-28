<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userId") == null) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }
    
    String userId = (String) sess.getAttribute("userId");
    String topic = request.getParameter("topic");
    String message = request.getParameter("message");
    
    if (topic != null && message != null && !message.trim().isEmpty()) {
        Notification note = new Notification();
        note.setUserId(userId);
        note.setTitle("Support Ticket Submitted");
        note.setMessage("We have received your support request regarding " + topic + ". Our team will get back to you shortly.");
        note.setType("Success");
        
        NotificationDAO noteDAO = new NotificationDAO();
        noteDAO.addNotification(note);
        response.sendRedirect("customer_support.jsp?msg=success");
    } else {
        response.sendRedirect("customer_support.jsp?msg=error");
    }
%>
