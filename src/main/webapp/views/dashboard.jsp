<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>FinFlow - Dashboard</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>💰</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-dark bg-success px-4">
    <span class="navbar-brand fw-bold">FinFlow</span>
    <div>
        <span class="text-white me-3">Welcome, <%= session.getAttribute("userName") %></span>
        <a href="<%= request.getContextPath() %>/transactions" class="btn btn-outline-light btn-sm me-2">Transactions</a>
        <a href="<%= request.getContextPath() %>/goals" class="btn btn-outline-light btn-sm me-2">Goals</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
        <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-light btn-sm me-2">Categories</a>
    </div>
</nav>

<div class="container mt-4">

    <!-- Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card text-white bg-success p-3">
                <h6>Total Income</h6>
                <h3>₹ <%= request.getAttribute("totalIncome") %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-danger p-3">
                <h6>Total Expense</h6>
                <h3>₹ <%= request.getAttribute("totalExpense") %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-primary p-3">
                <h6>Balance</h6>
                <h3>₹ <%= request.getAttribute("balance") %></h3>
            </div>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="card p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0">Recent Transactions</h5>
            <a href="<%= request.getContextPath() %>/transactions" class="btn btn-success btn-sm">+ Add Transaction</a>
        </div>

        <table class="table table-hover">
            <thead>
            <tr>
                <th>Date</th>
                <th>Note</th>
                <th>Category</th>
                <th>Type</th>
                <th>Amount</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Map<String, String>> transactions =
                        (List<Map<String, String>>) request.getAttribute("transactions");

                if (transactions != null && !transactions.isEmpty()) {
                    for (Map<String, String> txn : transactions) {
                        String type  = txn.get("type");
                        String color = type.equals("income") ? "text-success" : "text-danger";
                        String sign  = type.equals("income") ? "+" : "-";
            %>
            <tr>
                <td><%= txn.get("txn_date") %></td>
                <td><%= txn.get("note") %></td>
                <td><%= txn.get("category") %></td>
                <td><span class="badge <%= type.equals("income") ? "bg-success" : "bg-danger" %>"><%= type %></span></td>
                <td class="<%= color %>"><strong><%= sign %>₹<%= txn.get("amount") %></strong></td>
            </tr>
            <% }
            } else { %>
            <tr><td colspan="5" class="text-center text-muted">No transactions yet. Add one!</td></tr>
            <% } %>
            </tbody>
        </table>

        <% if (request.getAttribute("transactions") == null) { %>
        <p class="text-muted text-center">No transactions yet. Add one!</p>
        <% } %>
    </div>
</div>

</body>
</html>