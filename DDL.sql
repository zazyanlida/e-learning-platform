DROP TABLE IF EXISTS Enrolls;
DROP TABLE IF EXISTS Syllabus;
DROP TABLE IF EXISTS Discussion_comments;
DROP TABLE IF EXISTS Discussion;
DROP TABLE IF EXISTS Course_section;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Prerequisites;
DROP TABLE IF EXISTS Exam_grades;
DROP TABLE IF EXISTS Exam;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Courses;

DROP TYPE IF EXISTS exam_type;
DROP TYPE IF EXISTS user_type;
DROP TYPE IF EXISTS student_status;


CREATE TYPE exam_type AS ENUM ('midterm', 'final');
CREATE TYPE user_type AS ENUM ('instructor', 'student', 'admin');
CREATE TYPE student_status AS ENUM ('undergraduate', 'graduate', 'non-degree');



CREATE TABLE Users (
	user_id INT PRIMARY KEY, 
	email VARCHAR(255),
	user_type user_type
);

CREATE TABLE Student (
	student_id INT PRIMARY KEY REFERENCES Users(user_id), 
	first_name VARCHAR(255), 
	last_name VARCHAR(255), 
	status student_status,
	cgpa DECIMAL(2,1)
);


CREATE TABLE Instructor (
	instructor_id INT PRIMARY KEY REFERENCES Users(user_id), 
	first_name VARCHAR(255), 
	last_name VARCHAR(255) 
);

CREATE TABLE Prerequisites (
	course_id VARCHAR(255),
	prereq_id VARCHAR(255),
	PRIMARY KEY (course_id, prereq_id)
);

CREATE TABLE Courses (
	course_id VARCHAR(255) PRIMARY KEY,
	course_name VARCHAR(255),
	category VARCHAR(255),
	description TEXT
);

CREATE TABLE Course_section (
	course_id VARCHAR(255) REFERENCES Courses(course_id),
	section_id INT, 
	semester VARCHAR(255),
	offered_year INT, 
	start_date DATE,
	end_date DATE CHECK (end_date > start_date),
	student_count INT,
	weekday VARCHAR(255),
	time TIME,
	instructor_id INT REFERENCES Instructor(instructor_id),
	PRIMARY KEY (course_id, section_id, semester, offered_year)
);


CREATE TABLE Syllabus (
	course_id VARCHAR(255),
	section_id INT, 
	semester VARCHAR(255),
	offered_year INT, 
	description TEXT,
	final_weight DECIMAL(4, 2), 
	midterm_weight DECIMAL(4, 2), 
	passing_grade INT,
	CHECK (final_weight + midterm_weight = 1),
	PRIMARY KEY (course_id, section_id, semester, offered_year),
    FOREIGN KEY (course_id, section_id, semester, offered_year)
        REFERENCES Course_section (course_id, section_id, semester, offered_year)
);

CREATE TABLE Exam (
	exam_id INT PRIMARY KEY,
	course_id VARCHAR(255) REFERENCES Courses(course_id),
	type exam_type,
	date DATE,
	time TIME,
	UNIQUE (date, time)
);

CREATE TABLE Exam_grades (
	exam_id INT REFERENCES Exam(exam_id),
	student_id INT REFERENCES Student(student_id),
	grade DECIMAL(5,2),
	feedback TEXT,
	PRIMARY KEY (exam_id, student_id)
);

CREATE TABLE Enrolls (
	student_id INT REFERENCES Student(student_id),
	course_id VARCHAR(255),
	section_id INT, 
	semester VARCHAR(255),
	offered_year INT, 
	final_grade DECIMAL(5,2),
	PRIMARY KEY (student_id, course_id, section_id, semester, offered_year),
	FOREIGN KEY (course_id, section_id, semester, offered_year)
        REFERENCES Course_section (course_id, section_id, semester, offered_year),
	CHECK (final_grade BETWEEN 0.00 AND 100.00)
);

CREATE TABLE Discussion (
	discussion_id SERIAL PRIMARY KEY,
	course_id VARCHAR(255),
	section_id INT, 
	semester VARCHAR(255),
	offered_year INT, 
	creator_id INT REFERENCES Users(user_id),
	title VARCHAR(255), 
	disucssion_content TEXT,
	FOREIGN KEY (course_id, section_id, semester, offered_year)
	        REFERENCES Course_section (course_id, section_id, semester, offered_year)
);

CREATE TABLE Discussion_comments (
	comment_id SERIAL PRIMARY KEY,
	discussion_id INT REFERENCES Discussion(discussion_id),
	creator_id INT REFERENCES Users(user_id),
	comment_content TEXT
);





