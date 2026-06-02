<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>FinFlow - Transactions</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>💰</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .content { flex: 1; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-success px-4">
    <span class="navbar-brand fw-bold">💰 FinFlow</span>
    <div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-light btn-sm me-2">Categories</a>
        <a href="<%= request.getContextPath() %>/goals" class="btn btn-outline-light btn-sm me-2">Goals</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
    </div>
</nav>

<div class="content">
    <div class="container mt-4">
        <div class="row">

            <!-- Add Transaction Form -->
            <div class="col-md-4">
                <div class="card p-3 mb-4">
                    <h5 class="mb-3">Add Transaction</h5>
                    <form action="<%= request.getContextPath() %>/transactions" method="post">

                        <div class="mb-2">
                            <label>Amount (₹)</label>
                            <input type="number" name="amount" step="0.01"
                                   class="form-control" required>
                        </div>

                        <div class="mb-2">
                            <label>Type</label>
                            <select name="type" class="form-select" required>
                                <option value="income">Income</option>
                                <option value="expense">Expense</option>
                            </select>
                        </div>

                        <div class="mb-2">
                            <label>Category</label>
                            <select name="category_id" class="form-select">
                                <option value="">-- None --</option>
                                <%
                                    List<Map<String, String>> categories =
                                            (List<Map<String, String>>) request.getAttribute("categories");
                                    if (categories != null) {
                                        for (Map<String, String> cat : categories) {
                                %>
                                <option value="<%= cat.get("id") %>"><%= cat.get("name") %></option>
                                <%      }
                                }
                                %>
                            </select>
                        </div>

                        <div class="mb-2">
                            <label>Note</label>
                            <input type="text" name="note" class="form-control"
                                   placeholder="e.g. Mess bill, Salary">
                        </div>

                        <div class="mb-3">
                            <label>Date</label>
                            <input type="date" name="txn_date" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-success w-100">Add</button>
                    </form>
                </div>
            </div>

            <!-- Transactions Table -->
            <div class="col-md-8">
                <div class="card p-3">
                    <h5 class="mb-3">All Transactions</h5>
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Date</th>
                            <th>Note</th>
                            <th>Category</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Action</th>
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
                            <td><span class="badge <%= type.equals("income") ? "bg-success" : "bg-danger" %>">
                                    <%= type %></span></td>
                            <td class="<%= color %>">
                                <strong><%= sign %>₹<%= txn.get("amount") %></strong>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/transactions?delete=<%= txn.get("txn_id") %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this transaction?')">Delete</a>
                            </td>
                        </tr>
                        <%      }
                        } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                No transactions yet. Add one!
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<footer class="text-center mt-3 py-3" style="background-color: #146c43; color: white;">
    <small>FinFlow — Personal Finance Tracker</small>
</footer>

</body>
</html>