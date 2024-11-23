DROP TABLE IF EXISTS Syllabus;
DROP TABLE IF EXISTS CourseSection;
DROP TABLE IF EXISTS Instructor;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Prerequisites;
DROP TABLE IF EXISTS Users;
DROP TYPE IF EXISTS exam_type;


CREATE TYPE exam_type AS ENUM ('midterm', 'final');


CREATE TABLE Users (
	user_id INT PRIMARY KEY, 
	email VARCHAR(255),
	status VARCHAR(255)
);

CREATE TABLE Student (
	student_id INT PRIMARY KEY REFERENCES User(user_id), 
	first_name VARCHAR(255), 
	last_name VARCHAR(255), 
	status VARCHAR(255),
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
	PRIMARY KEY course_id, prereq_id)
)

CREATE TABLE Courses (
	course_id VARCHAR(255) PRIMARY KEY,
	course_name VARCHAR(255),
	category VARCHAR(255),
	description TEXT
)

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
	PRIMARY KEY (section_id, semester, offered_year)
);


CREATE TABLE Syllabus (
	course_id VARCHAR(255) REFERENCES Course_section(course_id),
	section_id INT REFERENCES Course_section(section_id), 
	semester VARCHAR(255) REFERENCES Course_section(semester),
	offered_year INT REFERENCES Course_section(offered_year), 
	description TEXT,
	final_weight DECIMAL(4, 2), 
	midterm_weight DECIMAL(4, 2), 
	passing_grade INT,
	CHECK (final_weight + midterm_weight = 1)
);

CREATE TABLE Exam (
	exam_id INT PRIMARY KEY,
	course_id VARCHAR(255) REFERENCES Courses(course_id),
	type exam_type,
	date DATE,
	time TIME
	EXCLUDE USING GIST (date, time WITH &&)
);

CREATE TABLE Exam_grades (
	exam_id INT REFERENCES Exam(exam_id),
	student_id INT REFERENCES Student(student_id),
	grade DECIMAL(5,2),
	PRIMARY KEY (exam_id, student_id)
);






