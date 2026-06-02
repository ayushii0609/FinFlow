<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <title>FinFlow - Goals</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>💰</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content {
            flex: 1;
        }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-success px-4">
    <span class="navbar-brand fw-bold">💰 FinFlow</span>
    <div>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
        <a href="<%= request.getContextPath() %>/transactions" class="btn btn-outline-light btn-sm me-2">Transactions</a>
        <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-light btn-sm me-2">Categories</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
    </div>
</nav>

<div class="content">
    <div class="container mt-4">
        <div class="row">

            <!-- Add Goal Form -->
            <div class="col-md-4">
                <div class="card p-3 mb-4">
                    <h5 class="mb-3">Add New Goal</h5>
                    <form action="<%= request.getContextPath() %>/goals" method="post">

                        <div class="mb-2">
                            <label>Goal Title</label>
                            <input type="text" name="title" class="form-control"
                                   placeholder="e.g. Buy Laptop, Trip to Manali" required>
                        </div>

                        <div class="mb-2">
                            <label>Target Amount (₹)</label>
                            <input type="number" name="target_amount" step="0.01"
                                   class="form-control" required>
                        </div>

                        <div class="mb-2">
                            <label>Already Saved (₹)</label>
                            <input type="number" name="saved_amount" step="0.01"
                                   class="form-control" placeholder="0">
                        </div>

                        <div class="mb-3">
                            <label>Target Date</label>
                            <input type="date" name="deadline" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-success w-100">Add Goal</button>
                    </form>
                </div>
            </div>

            <!-- Goals List -->
            <div class="col-md-8">
                <div class="card p-3">
                    <h5 class="mb-3">Your Savings Goals</h5>

                    <%
                        List<Map<String, String>> goals =
                                (List<Map<String, String>>) request.getAttribute("goals");

                        if (goals != null && !goals.isEmpty()) {
                            for (Map<String, String> goal : goals) {
                                int progress = Integer.parseInt(goal.get("progress"));
                                String barColor = progress == 100 ? "bg-success" :
                                        progress >= 50  ? "bg-warning"  : "bg-danger";
                                String statusText = progress == 100 ? "Goal Reached!" :
                                        progress >= 50  ? "Halfway there!" : "Keep saving!";
                    %>

                    <div class="card mb-3 p-3">

                        <!-- Title + Status + Delete -->
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <h6 class="mb-0"><%= goal.get("title") %></h6>
                            <div>
                                <span class="badge bg-secondary me-2"><%= statusText %></span>
                                <a href="<%= request.getContextPath() %>/goals?delete=<%= goal.get("id") %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this goal?')">Delete</a>
                            </div>
                        </div>

                        <!-- Deadline -->
                        <small class="text-muted mb-2">Deadline: <%= goal.get("deadline") %></small>

                        <!-- Saved vs Target -->
                        <div class="d-flex justify-content-between mt-2 mb-1">
                            <span>₹<%= goal.get("saved") %> saved</span>
                            <span>Target: ₹<%= goal.get("target") %></span>
                        </div>

                        <!-- Progress Bar -->
                        <div class="progress mb-3" style="height: 20px;">
                            <div class="progress-bar <%= barColor %>"
                                 style="width: <%= progress %>%">
                                <%= progress %>%
                            </div>
                        </div>

                        <!-- Update Form -->
                        <% if (progress < 100) { %>
                        <form action="<%= request.getContextPath() %>/goals"
                              method="get" class="d-flex gap-2 align-items-center">
                            <input type="hidden" name="update" value="<%= goal.get("id") %>">
                            <input type="number" name="saved_amount" step="0.01"
                                   class="form-control form-control-sm"
                                   placeholder="Update saved amount (₹)"
                                   min="0" max="<%= goal.get("target") %>"
                                   style="max-width: 250px;" required>
                            <button type="submit"
                                    class="btn btn-success btn-sm">Update</button>
                        </form>
                        <% } else { %>
                        <p class="text-success mb-0">
                            <strong>✅ Congratulations! You reached your goal!</strong>
                        </p>
                        <% } %>

                    </div>

                    <%
                        }
                    } else {
                    %>
                    <p class="text-muted text-center">No goals yet. Add one!</p>
                    <% } %>

                </div>
            </div>

        </div>
    </div>
</div>

<footer class="text-center mt-3 py-3" style="background-color: #198754; color: white;">
    <small>FinFlow — Personal Finance Tracker</small>
</footer>

</body>
</html>