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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            Connection conn = DBConnection.getConnection();

            // Total income
            String incomeSql = "SELECT COALESCE(SUM(amount), 0) AS total FROM transactions WHERE user_id = ? AND type = 'income'";
            PreparedStatement incomeStmt = conn.prepareStatement(incomeSql);
            incomeStmt.setInt(1, userId);
            ResultSet incomeRs = incomeStmt.executeQuery();
            double totalIncome = 0;
            if (incomeRs.next()) totalIncome = incomeRs.getDouble("total");

            // Total expense
            String expenseSql = "SELECT COALESCE(SUM(amount), 0) AS total FROM transactions WHERE user_id = ? AND type = 'expense'";
            PreparedStatement expenseStmt = conn.prepareStatement(expenseSql);
            expenseStmt.setInt(1, userId);
            ResultSet expenseRs = expenseStmt.executeQuery();
            double totalExpense = 0;
            if (expenseRs.next()) totalExpense = expenseRs.getDouble("total");

            // Last 5 transactions — store in a List instead of passing ResultSet
            String txnSql = "SELECT t.amount, t.type, t.note, t.txn_date, c.name as category " +
                    "FROM transactions t LEFT JOIN categories c ON t.category_id = c.category_id " +
                    "WHERE t.user_id = ? ORDER BY t.txn_date DESC LIMIT 5";
            PreparedStatement txnStmt = conn.prepareStatement(txnSql);
            txnStmt.setInt(1, userId);
            ResultSet txnRs = txnStmt.executeQuery();

            // Each row becomes a Map, all rows go into a List
            List<Map<String, String>> transactions = new ArrayList<>();
            while (txnRs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("amount",   String.valueOf(txnRs.getDouble("amount")));
                row.put("type",     txnRs.getString("type"));
                row.put("note",     txnRs.getString("note") != null ? txnRs.getString("note") : "");
                row.put("txn_date", String.valueOf(txnRs.getDate("txn_date")));
                row.put("category", txnRs.getString("category") != null ? txnRs.getString("category") : "—");
                transactions.add(row);
            }

            // Now safe to close — all data is in the List
            conn.close();

            request.setAttribute("totalIncome",  totalIncome);
            request.setAttribute("totalExpense", totalExpense);
            request.setAttribute("balance",      totalIncome - totalExpense);
            request.setAttribute("transactions", transactions);

            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}