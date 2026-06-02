<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>FinFlow - Register</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>💰</text></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .content { flex: 1; }
    </style>
</head>
<body class="bg-light">

<div class="content">
    <div class="container mt-5" style="max-width: 450px;">
        <div class="card p-4 shadow-sm">
            <h3 class="text-center mb-4">💰 Create Account</h3>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post">
                <div class="mb-3">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Register</button>
            </form>

            <p class="text-center mt-3">Already have an account?
                <a href="<%= request.getContextPath() %>/login">Login</a>
            </p>
        </div>
    </div>
</div>

<footer class="text-center mt-3 py-3" style="background-color: #146c43; color: white;">
    <small>FinFlow — Personal Finance Tracker</small>
</footer>

</body>
</html>