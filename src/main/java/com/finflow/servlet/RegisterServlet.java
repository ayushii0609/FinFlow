package com.finflow.servlet;

import com.finflow.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // GET — just show the register page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    // POST — runs when user submits the form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Step 1: Read what user typed in the form
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = DBConnection.getConnection();

            // Step 2: Check if email already exists
            String checkSql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Email already taken — send error back to JSP
                request.setAttribute("error", "Email already registered!");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }

            // Step 3: Insert new user into DB
            String sql = "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password); // plain text for now
            stmt.executeUpdate();

            // Step 4: Redirect to login page after success
            response.sendRedirect(request.getContextPath() + "/login");

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong. Try again.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}