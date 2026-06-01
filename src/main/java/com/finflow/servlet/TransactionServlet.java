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

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        // Handle delete if requested
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement delStmt = conn.prepareStatement(
                        "DELETE FROM transactions WHERE txn_id = ? AND user_id = ?"
                );
                delStmt.setInt(1, Integer.parseInt(deleteId));
                delStmt.setInt(2, userId);
                delStmt.executeUpdate();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/transactions");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            // Load all categories for the dropdown
            String catSql = "SELECT category_id, name FROM categories WHERE user_id = ?";
            PreparedStatement catStmt = conn.prepareStatement(catSql);
            catStmt.setInt(1, userId);
            ResultSet catRs = catStmt.executeQuery();

            List<Map<String, String>> categories = new ArrayList<>();
            while (catRs.next()) {
                Map<String, String> cat = new HashMap<>();
                cat.put("id",   String.valueOf(catRs.getInt("category_id")));
                cat.put("name", catRs.getString("name"));
                categories.add(cat);
            }

            // Load all transactions for this user
            String txnSql = "SELECT t.txn_id, t.amount, t.type, t.note, t.txn_date, c.name as category " +
                    "FROM transactions t LEFT JOIN categories c ON t.category_id = c.category_id " +
                    "WHERE t.user_id = ? ORDER BY t.txn_date DESC";
            PreparedStatement txnStmt = conn.prepareStatement(txnSql);
            txnStmt.setInt(1, userId);
            ResultSet txnRs = txnStmt.executeQuery();

            List<Map<String, String>> transactions = new ArrayList<>();
            while (txnRs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("txn_id",   String.valueOf(txnRs.getInt("txn_id")));
                row.put("amount",   String.valueOf(txnRs.getDouble("amount")));
                row.put("type",     txnRs.getString("type"));
                row.put("note",     txnRs.getString("note") != null ? txnRs.getString("note") : "");
                row.put("txn_date", String.valueOf(txnRs.getDate("txn_date")));
                row.put("category", txnRs.getString("category") != null ? txnRs.getString("category") : "—");
                transactions.add(row);
            }

            conn.close();

            request.setAttribute("categories",   categories);
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/views/transactions.jsp").forward(request, response);

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

        // Read form values
        String amountStr   = request.getParameter("amount");
        String type        = request.getParameter("type");
        String note        = request.getParameter("note");
        String date        = request.getParameter("txn_date");
        String categoryStr = request.getParameter("category_id");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO transactions (user_id, category_id, amount, type, note, txn_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            // category is optional — if blank, store NULL
            if (categoryStr != null && !categoryStr.isEmpty()) {
                stmt.setInt(2, Integer.parseInt(categoryStr));
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }

            stmt.setDouble(3, Double.parseDouble(amountStr));
            stmt.setString(4, type);
            stmt.setString(5, note);
            stmt.setString(6, date);
            stmt.executeUpdate();

            conn.close();

            // After adding, reload the transactions page
            response.sendRedirect(request.getContextPath() + "/transactions");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/transactions");
        }
    }
}