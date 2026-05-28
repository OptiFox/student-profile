DROP TABLE Users;

CREATE TABLE Users (
    user_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(50),
    role VARCHAR(20)
);

INSERT INTO Users (username, password, role) 
VALUES ('admin', 'password', 'ADMIN');

DROP TABLE Events;

CREATE TABLE Events (
    event_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_date DATE,
    description VARCHAR(255)
);

DROP TABLE Students;

CREATE TABLE Students (
    student_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    mykid VARCHAR(15) UNIQUE NOT NULL,
    gender VARCHAR(10),
    race VARCHAR(20),
    grade_year INT CHECK (grade_year BETWEEN 4 AND 6) NOT NULL,
    class_name VARCHAR(50),
    uniform_unit VARCHAR(50),
    club VARCHAR(50),
    sport VARCHAR(50)
);
