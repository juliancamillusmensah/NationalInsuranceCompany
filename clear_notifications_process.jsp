<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.insurance.dao.NotificationDAO" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess != null && sess.getAttribute("userId") != null) {
        String userId = (String) sess.getAttribute(\"userId\");
        NotificationDAO dao = new NotificationDAO();
        dao.clearAllNotifications(userId);
    }
    String referer = request.getHeader("referer");
    if (referer != null && !referer.isEmpty()) {
        response.sendRedirect(referer);
    } else {
        response.sendRedirect("Customerportal.jsp");
    }
%>
