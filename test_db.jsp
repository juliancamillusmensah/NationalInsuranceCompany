<%@ page import="com.insurance.dao.PublicationDAO" %>
<%@ page import="com.insurance.model.Publication" %>
<%@ page import="java.util.List" %>
<%
    PublicationDAO dao = new PublicationDAO();
    List<Publication> list = dao.getAllPublications();
    out.print("COUNT:" + list.size());
%>
