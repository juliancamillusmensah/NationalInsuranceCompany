<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.insurance.util.DBConnection" %>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        String sql = "CREATE TABLE IF NOT EXISTS claims (" +
                     "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                     "user_id INTEGER NOT NULL, " +
                     "policy_id INTEGER NOT NULL, " +
                     "claim_amount DECIMAL(10,2) NOT NULL, " +
                     "description TEXT, " +
                     "incident_date TEXT, " +
                     "status TEXT DEFAULT 'Pending', " +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                     "FOREIGN KEY(user_id) REFERENCES Account(id), " +
                     "FOREIGN KEY(policy_id) REFERENCES policies(id))";
        
        stmt.execute(sql);
        out.println("<h2>Claims table initialized successfully!</h2>");
        out.println("<p><a href='Customerportal.jsp'>Back to Portal</a></p>");
        
    } catch (Exception e) {
        out.println("<h2>Error initializing claims table</h2>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
