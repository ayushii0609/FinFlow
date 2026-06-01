package com.finflow.servlet;

import com.finflow.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Handle delete
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement delStmt = conn.prepareStatement(
                        "DELETE FROM categories WHERE category_id = ? AND user_id = ?"
                );
                delStmt.setInt(1, Integer.parseInt(deleteId));
                delStmt.setInt(2, userId);
                delStmt.executeUpdate();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/categories");
            return;
        }

        // Load all categories for this user
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT category_id, name, type FROM categories WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            List<Map<String, String>> categories = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> cat = new HashMap<>();
                cat.put("id",   String.valueOf(rs.getInt("category_id")));
                cat.put("name", rs.getString("name"));
                cat.put("type", rs.getString("type"));
                categories.add(cat);
            }

            conn.close();

            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/categories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String name = request.getParameter("name");
        String type = request.getParameter("type");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO categories (user_id, name, type) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, name);
            stmt.setString(3, type);
            stmt.executeUpdate();

            conn.close();

            response.sendRedirect(request.getContextPath() + "/categories");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }
}