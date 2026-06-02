<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>FinFlow - Categories</title>
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
        <a href="<%= request.getContextPath() %>/transactions" class="btn btn-outline-light btn-sm me-2">Transactions</a>
        <a href="<%= request.getContextPath() %>/goals" class="btn btn-outline-light btn-sm me-2">Goals</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
    </div>
</nav>

<div class="content">
    <div class="container mt-4">
        <div class="row">

            <!-- Add Category Form -->
            <div class="col-md-4">
                <div class="card p-3 mb-4">
                    <h5 class="mb-3">Add Category</h5>
                    <form action="<%= request.getContextPath() %>/categories" method="post">

                        <div class="mb-2">
                            <label>Category Name</label>
                            <input type="text" name="name" class="form-control"
                                   placeholder="e.g. Mess Bill, Salary" required>
                        </div>

                        <div class="mb-3">
                            <label>Type</label>
                            <select name="type" class="form-select" required>
                                <option value="expense">Expense</option>
                                <option value="income">Income</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-success w-100">Add Category</button>
                    </form>
                </div>
            </div>

            <!-- Categories List -->
            <div class="col-md-8">
                <div class="card p-3">
                    <h5 class="mb-3">Your Categories</h5>
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Map<String, String>> categories =
                                    (List<Map<String, String>>) request.getAttribute("categories");

                            if (categories != null && !categories.isEmpty()) {
                                for (Map<String, String> cat : categories) {
                                    String type = cat.get("type");
                        %>
                        <tr>
                            <td><%= cat.get("name") %></td>
                            <td>
                                    <span class="badge <%= type.equals("income") ? "bg-success" : "bg-danger" %>">
                                        <%= type %>
                                    </span>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/categories?delete=<%= cat.get("id") %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this category?')">Delete</a>
                            </td>
                        </tr>
                        <%      }
                        } else { %>
                        <tr>
                            <td colspan="3" class="text-center text-muted">
                                No categories yet. Add one above!
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