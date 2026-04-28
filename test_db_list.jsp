<%@ page import="com.insurance.dao.PublicationDAO" %>
<%@ page import="com.insurance.model.Publication" %>
<%@ page import="java.util.List" %>
<%
    PublicationDAO dao = new PublicationDAO();
    List<Publication> list = dao.getAllPublications();
    for(Publication p : list) {
        out.println(p.getTitle() + " | " + p.getCategory() + " | " + p.getYear() + "<br/>");
    }
%>
