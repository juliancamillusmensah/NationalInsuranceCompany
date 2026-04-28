<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session = request.getSession(false);
    if (session != null) {
        session.invalidate();
    }
    // Redirect to the homepage
    response.sendRedirect("allhomepage.jsp");
%>
