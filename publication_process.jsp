<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.insurance.dao.*" %>
<%@ page import="com.insurance.model.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null || !"ROLE_SUPERADMIN".equals(sess.getAttribute("roleId"))) {
        response.sendRedirect("allloginpage.jsp");
        return;
    }

    String action = request.getParameter("action");
    PublicationDAO pubDAO = new PublicationDAO();

    if ("delete".equals(action)) {
        String id = request.getParameter("id");
        if (id != null) {
            pubDAO.deletePublication(id);
        }
        response.sendRedirect("superadmin_publications.jsp?success=deleted");
        return;
    }

    String title = request.getParameter("title");
    String category = request.getParameter("category");
    String year = request.getParameter("year");
    String description = request.getParameter("description");
    String fileUrl = request.getParameter("fileUrl");
    String fileSize = request.getParameter("fileSize");

    if (title != null && category != null) {
        Publication p = new Publication();
        p.setTitle(title);
        p.setCategory(category);
        p.setYear(year);
        p.setDescription(description);
        p.setFileUrl(fileUrl);
        p.setFileSize(fileSize != null && !fileSize.isEmpty() ? fileSize : "N/A");

        if (pubDAO.addPublication(p)) {
            response.sendRedirect("superadmin_publications.jsp?success=added");
        } else {
            response.sendRedirect("superadmin_publications.jsp?error=add_failed");
        }
    } else {
        response.sendRedirect("superadmin_publications.jsp?error=missing");
    }
%>
