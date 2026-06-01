# FinFlow — Personal Finance Tracker

A full-stack web application built for college students to track 
income, expenses, and savings goals.

## Features
- User Registration and Login with session management
- Add and delete income/expense transactions
- Custom categories for transactions
- Savings goals with visual progress tracker
- Dashboard showing real-time balance, income and expenses

## Tech Stack
- Frontend: HTML, CSS, Bootstrap 5, JSP
- Backend: Java Servlets (Jakarta EE), Apache Tomcat 10
- Database: MySQL 8 (JDBC)
- Architecture: MVC Pattern
- Deployment: Render

## How to Run Locally
1. Clone the repo
2. Create MySQL database using schema.sql in src/main/resources
3. Update DBConnection.java with your MySQL password
4. Run on Apache Tomcat 10 via IntelliJ
5. Visit http://localhost:8080

## Project Structure
- servlet/  → All Java Servlet controllers
- views/    → JSP pages
- dao/      → Database connection
- model/    → Java model classes
