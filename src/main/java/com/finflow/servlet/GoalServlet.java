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

@WebServlet("/goals")
public class GoalServlet extends HttpServlet {

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
                        "DELETE FROM goals WHERE goal_id = ? AND user_id = ?"
                );
                delStmt.setInt(1, Integer.parseInt(deleteId));
                delStmt.setInt(2, userId);
                delStmt.executeUpdate();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/goals");
            return;
        }

        // Handle update saved amount
        String updateId    = request.getParameter("update");
        String updateAmount = request.getParameter("saved_amount");
        if (updateId != null && updateAmount != null && !updateAmount.isEmpty()) {
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE goals SET saved_amount = ? WHERE goal_id = ? AND user_id = ?"
                );
                updateStmt.setDouble(1, Double.parseDouble(updateAmount));
                updateStmt.setInt(2, Integer.parseInt(updateId));
                updateStmt.setInt(3, userId);
                updateStmt.executeUpdate();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/goals");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT goal_id, title, target_amount, saved_amount, deadline " +
                    "FROM goals WHERE user_id = ? ORDER BY deadline ASC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            List<Map<String, String>> goals = new ArrayList<>();
            while (rs.next()) {
                double target  = rs.getDouble("target_amount");
                double saved   = rs.getDouble("saved_amount");

                // Calculate progress percentage
                int progress = 0;
                if (target > 0) {
                    progress = (int) Math.min((saved / target) * 100, 100);
                }

                Map<String, String> goal = new HashMap<>();
                goal.put("id",       String.valueOf(rs.getInt("goal_id")));
                goal.put("title",    rs.getString("title"));
                goal.put("target",   String.valueOf(target));
                goal.put("saved",    String.valueOf(saved));
                goal.put("deadline", String.valueOf(rs.getDate("deadline")));
                goal.put("progress", String.valueOf(progress));
                goals.add(goal);
            }

            conn.close();

            request.setAttribute("goals", goals);
            request.getRequestDispatcher("/views/goals.jsp").forward(request, response);

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

        String title      = request.getParameter("title");
        String targetStr  = request.getParameter("target_amount");
        String savedStr   = request.getParameter("saved_amount");
        String deadline   = request.getParameter("deadline");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO goals (user_id, title, target_amount, saved_amount, deadline) " +
                    "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, title);
            stmt.setDouble(3, Double.parseDouble(targetStr));
            stmt.setDouble(4, savedStr != null && !savedStr.isEmpty() ?
                    Double.parseDouble(savedStr) : 0);
            stmt.setString(5, deadline);
            stmt.executeUpdate();

            conn.close();

            response.sendRedirect(request.getContextPath() + "/goals");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/goals");
        }
    }
}