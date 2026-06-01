CREATE DATABASE IF NOT EXISTS finflow_db;
USE finflow_db;

CREATE TABLE users (
                       user_id     INT AUTO_INCREMENT PRIMARY KEY,
                       name        VARCHAR(100) NOT NULL,
                       email       VARCHAR(100) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
                            category_id INT AUTO_INCREMENT PRIMARY KEY,
                            user_id     INT NOT NULL,
                            name        VARCHAR(100) NOT NULL,
                            type        ENUM('income', 'expense') NOT NULL,
                            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE transactions (
                              txn_id      INT AUTO_INCREMENT PRIMARY KEY,
                              user_id     INT NOT NULL,
                              category_id INT,
                              amount      DECIMAL(10, 2) NOT NULL,
                              type        ENUM('income', 'expense') NOT NULL,
                              note        VARCHAR(255),
                              txn_date    DATE NOT NULL,
                              created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                              FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE goals (
                       goal_id         INT AUTO_INCREMENT PRIMARY KEY,
                       user_id         INT NOT NULL,
                       title           VARCHAR(150) NOT NULL,
                       target_amount   DECIMAL(10, 2) NOT NULL,
                       saved_amount    DECIMAL(10, 2) DEFAULT 0.00,
                       deadline        DATE,
                       created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
