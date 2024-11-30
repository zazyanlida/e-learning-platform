DROP FUNCTION IF EXISTS update_syllabus();
DROP FUNCTION IF EXISTS view_syllabus();
DROP FUNCTION IF EXISTS view_student_course_grades();
DROP FUNCTION IF EXISTS view_class_grades();
DROP FUNCTION IF EXISTS get_course_statistics();
DROP FUNCTION IF EXISTS view_exams(); 
DROP FUNCTION IF EXISTS update_exam_grades();
DROP FUNCTION IF EXISTS leave_feedback();
DROP FUNCTION IF EXISTS view_teaching_courses();
DROP FUNCTION IF EXISTS create_discussion();
DROP FUNCTION IF EXISTS add_comment();
DROP FUNCTION IF EXISTS update_final_grades_by_course();
DROP FUNCTION IF EXISTS leave_course_feedback();
DROP FUNCTION IF EXISTS view_course_syllabus();
DROP FUNCTION IF EXISTS view_exam_schedule();
DROP FUNCTION IF EXISTS drop_course();
DROP FUNCTION IF EXISTS get_enrolled_courses();
DROP FUNCTION IF EXISTS get_student_course_grades();
DROP FUNCTION IF EXISTS get_available_courses();
DROP FUNCTION IF EXISTS get_courses_with_prerequisites_status();
DROP FUNCTION IF EXISTS enroll_student();
DROP FUNCTION IF EXISTS get_student_gpa();
DROP FUNCTION IF EXISTS update_cumulative_gpa();
DROP FUNCTION IF EXISTS create_course_and_assign_professor();
DROP FUNCTION IF EXISTS create_exam_and_check_conflict();
	
--Update and View Syllabus

CREATE OR REPLACE FUNCTION update_syllabus (
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT,
    p_description TEXT,
    p_final_weight DECIMAL(4, 2),
    p_midterm_weight DECIMAL(4, 2),
    p_passing_grade INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE Syllabus
    SET description = COALESCE(p_description, description),
        final_weight = COALESCE(p_final_weight, final_weight),
        midterm_weight = COALESCE(p_midterm_weight, midterm_weight),
        passing_grade = COALESCE(p_passing_grade, passing_grade)
    WHERE course_id = p_course_id
      AND section_id = p_section_id
      AND semester = p_semester
      AND offered_year = p_offered_year;

    IF NOT FOUND THEN
        INSERT INTO Syllabus (course_id, section_id, semester, offered_year, description, final_weight, midterm_weight, passing_grade)
        VALUES (p_course_id, p_section_id, p_semester, p_offered_year, p_description, p_final_weight, p_midterm_weight, p_passing_grade);
    END IF;
END;
$$ LANGUAGE plpgsql;

--View Syllabus

CREATE OR REPLACE FUNCTION view_syllabus (
	p_course_id VARCHAR(255),
	p_semester VARCHAR(255), 
	p_offered_year INT, 
	p_section_id INT
)
RETURNS TABLE(
	course_id VARCHAR(255),
	section_id INT, 
	semester VARCHAR(255),
	offered_year INT, 
	description TEXT,
	final_weight DECIMAL(4, 2), 
	midterm_weight DECIMAL(4, 2), 
	passing_grade INT
) AS $$
BEGIN
    RETURN QUERY
	SELECT * 
	FROM Syllabus as s
	WHERE s.course_id = p_course_id 
	AND s.semester = p_semester 
	AND s.offered_year = p_offered_year 
	AND s.section_id = p_section_id;
END;
$$ LANGUAGE plpgsql;

--View a student’s course grades

CREATE OR REPLACE FUNCTION view_student_course_grades (
	p_student_id INT,
	p_course_id VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE(
	student_id INT,
	final_grade DECIMAL(5,2),
	midterm_grade DECIMAL(5,2),
	final_course_grade DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
	SELECT 
		Exam_grades.student_id,
	    MAX(CASE WHEN type = 'final' THEN grade END) AS final_grade,
	    MAX(CASE WHEN type = 'midterm' THEN grade END) AS midterm_grade,
		Enrolls.final_grade
	FROM Exam_grades
	INNER JOIN Exam ON Exam_grades.exam_id = Exam.exam_id
	INNER JOIN Enrolls ON Exam_grades.student_id = Enrolls.student_id and Exam.course_id = Enrolls.course_id
	WHERE Exam_grades.student_id = p_student_id
	AND Exam.course_id = p_course_id
	GROUP BY Exam_grades.student_id, Enrolls.final_grade;
END;
$$ LANGUAGE plpgsql;


--View all students exam grades for a class

CREATE OR REPLACE FUNCTION view_class_grades (
	p_course_id VARCHAR(255),
	p_semester VARCHAR(255), 
	p_offered_year INT, 
	p_section_id INT
)
RETURNS TABLE(
	student_id INT,
	final_grade DECIMAL(5,2),
	midterm_grade DECIMAL(5,2),
	final_course_grade DECIMAL(5,2)

) AS $$
BEGIN
    RETURN QUERY
	SELECT 
		Exam_grades.student_id,
	    MAX(CASE WHEN type = 'final' THEN grade END) AS final_grade,
	    MAX(CASE WHEN type = 'midterm' THEN grade END) AS midterm_grade,
		Enrolls.final_grade
	FROM Exam_grades
	INNER JOIN Exam ON Exam_grades.exam_id = Exam.exam_id
	INNER JOIN Enrolls ON Exam_grades.student_id = Enrolls.student_id and Exam.course_id = Enrolls.course_id
	WHERE Enrolls.course_id = p_course_id
	AND Enrolls.semester = p_semester
	AND Enrolls.offered_year = p_offered_year
	AND Enrolls.section_id = p_section_id
	GROUP BY Exam_grades.student_id, Enrolls.final_grade;
	
END;
$$ LANGUAGE plpgsql;

--View course statistics 

CREATE OR REPLACE FUNCTION get_course_statistics(
    p_course_id VARCHAR(255),
    p_section_id INT DEFAULT NULL,
    p_semester VARCHAR(255) DEFAULT NULL,
    p_offered_year INT DEFAULT NULL
)
RETURNS TABLE(
    average_grade DECIMAL(5,2),
    highest_grade DECIMAL(5,2),
    lowest_grade DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT AVG(e.final_grade) AS average_grade,
           MAX(e.final_grade) AS highest_grade,
           MIN(e.final_grade) AS lowest_grade
    FROM Enrolls e
    WHERE e.course_id = p_course_id
      AND (p_section_id IS NULL OR e.section_id = p_section_id)
      AND (p_semester IS NULL OR e.semester = p_semester)
      AND (p_offered_year IS NULL OR e.offered_year = p_offered_year);
END;
$$ LANGUAGE plpgsql;

--View exam ids and schedule of the course 
CREATE OR REPLACE FUNCTION view_exams(
    p_course_id VARCHAR(255)
)
RETURNS TABLE(
    exam_id INT,
    exam_type exam_type,
    exam_date DATE,
	exam_time TIME
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.exam_id,
        e.type AS exam_type,
        e.date,
		e.time
    FROM Exam e
    WHERE e.course_id = p_course_id;
END;
$$ LANGUAGE plpgsql;


--Update student grades 
CREATE OR REPLACE FUNCTION update_exam_grades(
    p_exam_id INT,
    p_student_id INT,
    p_grade DECIMAL(5, 2),
    p_feedback TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
	IF EXISTS (
        SELECT 1
        FROM Exam_grades
        WHERE exam_id = p_exam_id AND student_id = p_student_id
    ) THEN

	    IF p_feedback IS NOT NULL THEN
            UPDATE Exam_grades
            SET grade = p_grade,
                feedback = p_feedback
            WHERE exam_id = p_exam_id AND student_id = p_student_id;
        ELSE
            UPDATE Exam_grades
            SET grade = p_grade
            WHERE exam_id = p_exam_id AND student_id = p_student_id;
        END IF;
    ELSE
        INSERT INTO Exam_grades (exam_id, student_id, grade, feedback)
        VALUES (p_exam_id, p_student_id, p_grade, p_feedback);
    END IF;
END;
$$ LANGUAGE plpgsql;

--leave or update feedback

CREATE OR REPLACE FUNCTION leave_feedback(
    p_exam_id INT,
    p_student_id INT,
    p_feedback TEXT
)
RETURNS VOID AS $$
BEGIN
    UPDATE Exam_grades
    SET feedback = p_feedback
    WHERE exam_id = p_exam_id AND student_id = p_student_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Grade record not found for the given exam and student.';
    END IF;
END;
$$ LANGUAGE plpgsql;

--View all taught courses

CREATE OR REPLACE FUNCTION view_teaching_courses(p_instructor_id INT)
RETURNS TABLE(
	course_id VARCHAR, 
	section_id INT, 
	semester VARCHAR, 
	offered_year INT) AS $$
BEGIN
    RETURN QUERY
    SELECT cs.course_id, cs.section_id, cs.semester, cs.offered_year
    FROM Course_section cs
    WHERE cs.instructor_id = p_instructor_id;
END;
$$ LANGUAGE plpgsql;


--Create a discussion
CREATE OR REPLACE FUNCTION create_discussion(
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT,
    p_creator_id INT,
    p_title TEXT,
    p_content TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Discussion (course_id, section_id, semester, offered_year, creator_id, title, disucssion_content)
    VALUES (p_course_id, p_section_id, p_semester, p_offered_year, p_creator_id, p_title, p_content);
END;
$$ LANGUAGE plpgsql;

-- Add a comment to an existing discussion

CREATE OR REPLACE FUNCTION add_comment(
    p_discussion_id INT,
    p_creator_id INT,
    p_comment TEXT
)
RETURNS VOID AS $$
BEGIN
    -- Check if the discussion_id exists
    IF NOT EXISTS (
        SELECT 1
        FROM Discussion
        WHERE discussion_id = p_discussion_id
    ) THEN
        RAISE NOTICE 'Discussion ID % does not exist.', p_discussion_id;
    END IF;
    INSERT INTO Discussion_comments (discussion_id, creator_id, comment_content)
    VALUES (p_discussion_id, p_creator_id, p_comment);
END;
$$ LANGUAGE plpgsql;


--calculate final grades

CREATE OR REPLACE FUNCTION update_final_grades_by_course(
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT
)
RETURNS VOID AS $$
BEGIN
    WITH syllabus_data AS (
        SELECT midterm_weight, final_weight
        FROM Syllabus
        WHERE course_id = p_course_id
          AND section_id = p_section_id
          AND semester = p_semester
          AND offered_year = p_offered_year
    ),
	
    midterm_grades AS (
        SELECT eg.student_id, eg.grade AS midterm_grade
        FROM Exam_grades eg
        INNER JOIN Exam e ON eg.exam_id = e.exam_id
        WHERE e.course_id = p_course_id AND e.type = 'midterm'
    ),
	
    final_exam_grades AS (
        SELECT eg.student_id, eg.grade AS final_grade
        FROM Exam_grades eg
        INNER JOIN Exam e ON eg.exam_id = e.exam_id
        WHERE e.course_id = p_course_id AND e.type = 'final'
    ),
	
    final_grades AS (
        SELECT 
            m.student_id,
            (m.midterm_grade * s.midterm_weight) + 
            (f.final_grade * s.final_weight) AS final_grade
        FROM midterm_grades m
        INNER JOIN final_exam_grades f ON m.student_id = f.student_id
        CROSS JOIN syllabus_data s
    )
    UPDATE Enrolls e
    SET final_grade = fg.final_grade
    FROM final_grades fg
    WHERE e.student_id = fg.student_id
      AND e.course_id = p_course_id
      AND e.section_id = p_section_id
	  AND e.offered_year = p_offered_year;
END;
$$ LANGUAGE plpgsql;


--Leave course feedback 
--Leave course feedback
CREATE OR REPLACE FUNCTION leave_course_feedback(
    p_student_id INT,
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT,
    p_feedback TEXT,
    p_rating INT
)
RETURNS VOID AS $$
BEGIN
	 IF NOT EXISTS (
        SELECT 1 
        FROM Enrolls 
        WHERE student_id = p_student_id 
        AND course_id = p_course_id 
        AND section_id = p_section_id 
        AND semester = p_semester 
        AND offered_year = p_offered_year
    ) THEN
        RAISE EXCEPTION 'Student % is not enrolled in course % for section % in semester % of year %', 
            p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
    END IF;
    -- Insert feedback into the Course_feedback table
    INSERT INTO Course_feedback (student_id, course_id, section_id, semester, offered_year, feedback, rating)
    VALUES (p_student_id, p_course_id, p_section_id, p_semester, p_offered_year, p_feedback, p_rating);
    
    -- Optionally, you can add logic here to check if the course section exists or if the student is enrolled in the course section.
    
    RAISE NOTICE 'Feedback successfully provided by Student ID: %, Course ID: %, Section ID: %, Semester: %, Year: %', 
        p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
END;
$$ LANGUAGE plpgsql;

--Enrolled students see the syllabuses
CREATE OR REPLACE FUNCTION view_course_syllabus(
    p_student_id INT,
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT
)
RETURNS TABLE(
    course_description TEXT,
    final_weight DECIMAL(4,2),
    midterm_weight DECIMAL(4,2),
    passing_grade INT
) AS $$
BEGIN
    -- Check if the student is enrolled in the course
    IF NOT EXISTS (
        SELECT 1 
        FROM Enrolls 
        WHERE student_id = p_student_id 
        AND course_id = p_course_id 
        AND section_id = p_section_id 
        AND semester = p_semester 
        AND offered_year = p_offered_year
    ) THEN
        RAISE EXCEPTION 'Student % is not enrolled in course % for section % in semester % of year %', 
            p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
    END IF;

    -- Retrieve the syllabus information for the enrolled course
    RETURN QUERY
    SELECT s.description, s.final_weight, s.midterm_weight, s.passing_grade
    FROM Syllabus s
    WHERE s.course_id = p_course_id
    AND s.section_id = p_section_id
    AND s.semester = p_semester
    AND s.offered_year = p_offered_year;
END;
$$ LANGUAGE plpgsql;

--view exam schedule
CREATE OR REPLACE FUNCTION view_exam_schedule(
    p_student_id INT,
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT
)
RETURNS TABLE(
    exam_type exam_type,
    exam_date DATE,
    exam_time TIME
) AS $$
BEGIN
    -- Check if the student is enrolled in the course
    IF NOT EXISTS (
        SELECT 1 
        FROM Enrolls 
        WHERE student_id = p_student_id 
        AND course_id = p_course_id 
        AND section_id = p_section_id 
        AND semester = p_semester 
        AND offered_year = p_offered_year
    ) THEN
        RAISE EXCEPTION 'Student % is not enrolled in course % for section % in semester % of year %', 
            p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
    END IF;

    -- Retrieve the exam schedule for the enrolled course
    RETURN QUERY
    SELECT e.type, e.date, e.time
    FROM Exam e
    JOIN Course_section cs ON e.course_id = cs.course_id
    WHERE cs.course_id = p_course_id
    AND cs.section_id = p_section_id
    AND cs.semester = p_semester
    AND cs.offered_year = p_offered_year;
END;
$$ LANGUAGE plpgsql;

--drop course

CREATE OR REPLACE FUNCTION drop_course(
    p_student_id INT,
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT
)
RETURNS VOID AS $$
BEGIN
    -- Check if the student is enrolled in the specified course, section, semester, and year
    IF NOT EXISTS (
        SELECT 1 
        FROM Enrolls 
        WHERE student_id = p_student_id 
        AND course_id = p_course_id 
        AND section_id = p_section_id 
        AND semester = p_semester 
        AND offered_year = p_offered_year
    ) THEN
        RAISE EXCEPTION 'Student % is not enrolled in course % for section % in semester % of year %', 
            p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
    END IF;

    -- Drop the course (remove the student's enrollment)
    DELETE FROM Enrolls
    WHERE student_id = p_student_id
    AND course_id = p_course_id
    AND section_id = p_section_id
    AND semester = p_semester
    AND offered_year = p_offered_year;

    RAISE NOTICE 'Student % has successfully dropped course % for section % in semester % of year %', 
        p_student_id, p_course_id, p_section_id, p_semester, p_offered_year;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_enrolled_courses(my_student_id INT)
RETURNS TABLE (
    course_id VARCHAR(255),
    course_name VARCHAR(255),
    category VARCHAR(255),
    offered_year INT,
    semester VARCHAR(255),
    is_finished BOOLEAN,
    instructor_name VARCHAR(255)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cs.course_id,
        c.course_name,
        c.category,
        cs.offered_year,
        cs.semester,
        e.final_grade IS NOT NULL AS is_finished,
        CONCAT(i.first_name, ' ', i.last_name)::VARCHAR(255) AS instructor_name
    FROM 
        Enrolls e
    INNER JOIN Course_section cs
        ON e.course_id = cs.course_id 
        AND e.section_id = cs.section_id
        AND e.semester = cs.semester
        AND e.offered_year = cs.offered_year
    INNER JOIN Courses c
        ON cs.course_id = c.course_id
    INNER JOIN Instructor i
        ON cs.instructor_id = i.instructor_id
    WHERE 
        e.student_id = my_student_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_student_course_grades(my_student_id INT)
RETURNS TABLE (
    course_id VARCHAR(255),
    course_name VARCHAR(255),
    final_grade DECIMAL(5, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cs.course_id,
        c.course_name,
        e.final_grade
    FROM 
        Enrolls e
    INNER JOIN Course_section cs
        ON e.course_id = cs.course_id 
        AND e.section_id = cs.section_id
        AND e.semester = cs.semester
        AND e.offered_year = cs.offered_year
    INNER JOIN Courses c
        ON cs.course_id = c.course_id
    WHERE 
        e.student_id = my_student_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_available_courses(my_student_id INT)
RETURNS TABLE (
    course_id VARCHAR(255),
    course_name VARCHAR(255),
    category VARCHAR(255),
    description TEXT,
    is_passed BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        c.course_id,
        c.course_name,
        c.category,
        c.description,
        CASE 
            WHEN passed_courses.course_id IS NOT NULL THEN TRUE
            ELSE FALSE
        END AS is_passed
    FROM
        Courses c
    LEFT JOIN Prerequisites p
        ON c.course_id = p.course_id
    LEFT JOIN (
        SELECT 
            e.course_id
        FROM 
            Enrolls e
        INNER JOIN Syllabus s
            ON e.course_id = s.course_id
            AND e.section_id = s.section_id
            AND e.semester = s.semester
            AND e.offered_year = s.offered_year
        WHERE 
            e.student_id = my_student_id
            AND e.final_grade >= s.passing_grade
    ) passed_courses
        ON p.prereq_id = passed_courses.course_id
    LEFT JOIN (
        SELECT 
            e.course_id
        FROM 
            Enrolls e
        INNER JOIN Syllabus s
            ON e.course_id = s.course_id
            AND e.section_id = s.section_id
            AND e.semester = s.semester
            AND e.offered_year = s.offered_year
        WHERE 
            e.student_id = my_student_id
            AND e.final_grade >= s.passing_grade
    ) student_passed_courses
        ON c.course_id = student_passed_courses.course_id
    WHERE 
        p.prereq_id IS NULL OR passed_courses.course_id IS NOT NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_courses_with_prerequisites_status(my_student_id INT)
RETURNS TABLE (
    course_id VARCHAR(255),
    course_name VARCHAR(255),
    category VARCHAR(255),
    description TEXT,
    prerequisite_id VARCHAR(255),
    prerequisite_name VARCHAR(255),
    is_prerequisite_met BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.course_id,
        c.course_name,
        c.category,
        c.description,
        p.prereq_id AS prerequisite_id,
        pc.course_name AS prerequisite_name,
        CASE 
		    WHEN p.prereq_id IS NULL THEN TRUE
            WHEN passed_courses.course_id IS NOT NULL  THEN TRUE
            ELSE FALSE
        END AS is_prerequisite_met
    FROM 
        Courses c
    LEFT JOIN Prerequisites p
        ON c.course_id = p.course_id
    LEFT JOIN Courses pc
        ON p.prereq_id = pc.course_id
    LEFT JOIN (
        SELECT 
            e.course_id
        FROM 
            Enrolls e
        INNER JOIN Syllabus s
            ON e.course_id = s.course_id
            AND e.section_id = s.section_id
            AND e.semester = s.semester
            AND e.offered_year = s.offered_year
        WHERE 
            e.student_id = my_student_id
            AND e.final_grade >= s.passing_grade 
    ) passed_courses
        ON p.prereq_id = passed_courses.course_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION enroll_student(
    my_student_id INT,
    my_course_id VARCHAR(255),
    my_section_id INT,
    my_semester VARCHAR(255),
    my_offered_year INT
) RETURNS TEXT AS $$
DECLARE
    prereqs_met BOOLEAN;
    seats_available BOOLEAN;
    already_enrolled BOOLEAN;
    current_student_count INT;
    max_seats INT := 50; 
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM Enrolls
        WHERE student_id = my_student_id
          AND course_id = my_course_id
          AND section_id = my_section_id
          AND semester = my_semester
          AND offered_year = my_offered_year
    ) INTO already_enrolled;

    IF already_enrolled THEN
        RETURN 'You are already enrolled in this course section.';
    END IF;

    SELECT bool_and(is_prerequisite_met)
    FROM get_courses_with_prerequisites_status(my_student_id)
    WHERE course_id = my_course_id
    INTO prereqs_met;

    IF NOT prereqs_met THEN
        RETURN 'You do not meet the prerequisite requirements for this course.';
    END IF;

    SELECT student_count
    FROM Course_section
    WHERE course_id = my_course_id
      AND section_id = my_section_id
      AND semester = my_semester
      AND offered_year = my_offered_year
    INTO current_student_count;

    seats_available := (current_student_count < max_seats);

    IF NOT seats_available THEN
        RETURN 'No seats are available in this course section.';
    END IF;

    INSERT INTO Enrolls (student_id, course_id, section_id, semester, offered_year)
    VALUES (my_student_id, my_course_id, my_section_id, my_semester, my_offered_year);

    UPDATE Course_section
    SET student_count = student_count + 1
    WHERE course_id = my_course_id
      AND section_id = my_section_id
      AND semester = my_semester
      AND offered_year = my_offered_year;

    RETURN 'You have been successfully enrolled in the course.';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_student_gpa(my_student_id INT)
RETURNS DECIMAL(4, 2) AS $$
DECLARE
    cumulative_gpa DECIMAL(4, 2);
BEGIN
    SELECT 
        ROUND(SUM(final_grade) / COUNT(final_grade) / 25, 2)
    INTO 
        cumulative_gpa
    FROM 
        Enrolls
    WHERE 
        student_id = my_student_id
        AND final_grade IS NOT NULL;

    IF cumulative_gpa IS NULL THEN
        RETURN 0.00;
    END IF;

    RETURN cumulative_gpa;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_cumulative_gpa(my_student_id INT)
RETURNS VOID AS $$
DECLARE
    cumulative_gpa DECIMAL(4, 2);
BEGIN
    SELECT 
        ROUND(SUM(final_grade) / COUNT(final_grade) / 25, 2)
    INTO 
        cumulative_gpa
    FROM 
        Enrolls
    WHERE 
        student_id = my_student_id
        AND final_grade IS NOT NULL;

    UPDATE Student
    SET cgpa = COALESCE(cumulative_gpa, 0.00) -- Default to 0.00 if no grades
    WHERE student_id = my_student_id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION get_student_gpa(integer);
CREATE OR REPLACE FUNCTION get_student_gpa(my_student_id INT)
RETURNS TABLE (
    semester VARCHAR(255),
    offered_year INT,
    gpa DECIMAL(4, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.semester,
        e.offered_year,
        ROUND(SUM(e.final_grade) / COUNT(e.final_grade) / 25, 2) AS gpa
        
    FROM 
        Enrolls e
    WHERE 
        e.student_id = my_student_id
        AND e.final_grade IS NOT NULL
    GROUP BY 
        e.semester, e.offered_year, e.student_id
    ORDER BY 
        e.offered_year, e.semester;
END;
$$ LANGUAGE plpgsql;

------------------Admin Operations-----------------------------------------------------------------------------

--Add course andd assign to instructor 
CREATE OR REPLACE FUNCTION create_course_and_assign_professor(
    p_course_id VARCHAR(255),
    p_course_name VARCHAR(255),
    p_category VARCHAR(255),
    p_description TEXT,
    p_instructor_id INT,
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT,
    p_start_date DATE,
    p_end_date DATE,
    p_weekday VARCHAR(255),
    p_time TIME
)
RETURNS VOID AS $$
BEGIN
    -- Insert a new course record into the Courses table
    INSERT INTO Courses (course_id, course_name, category, description)
    VALUES (p_course_id, p_course_name, p_category, p_description);
    
    RAISE NOTICE 'Course % has been created successfully.', p_course_id;

    -- Insert a new course section and assign the professor in the Course_section table
    INSERT INTO Course_section (
        course_id, 
        section_id, 
        semester, 
        offered_year, 
        start_date, 
        end_date, 
        weekday, 
        time, 
        instructor_id
    )
    VALUES (
        p_course_id, 
        p_section_id, 
        p_semester, 
        p_offered_year, 
        p_start_date, 
        p_end_date, 
        p_weekday, 
        p_time, 
        p_instructor_id
    );
    
    RAISE NOTICE 'Professor % has been assigned to course % for section % in semester % of year %', 
        p_instructor_id, p_course_id, p_section_id, p_semester, p_offered_year;
END;
$$ LANGUAGE plpgsql;

-- Creating exams
CREATE OR REPLACE FUNCTION create_exam_and_check_conflict(
    p_exam_id INT,
    p_course_id VARCHAR(255),
    p_exam_type exam_type,   -- 'midterm' or 'final'
    p_exam_date DATE,
    p_exam_time TIME
)
RETURNS VOID AS $$
BEGIN
    -- Check for scheduling conflicts with other exams at the same date and time
    IF EXISTS (
        SELECT 1 
        FROM Exam 
        WHERE date = p_exam_date 
        AND ABS(EXTRACT(EPOCH FROM (time - p_exam_time)) / 60) < 50
    ) THEN
        -- Raise an error if there is a scheduling conflict
        RAISE EXCEPTION 'Conflict: An exam is already scheduled at % on % for another course', 
            p_exam_time::TEXT, p_exam_date::TEXT;
    ELSE
        -- Insert the new exam record into the Exam table
        INSERT INTO Exam (exam_id, course_id, type, date, time)
        VALUES (p_exam_id, p_course_id, p_exam_type, p_exam_date, p_exam_time);
        
        -- Raise a success message
        RAISE NOTICE 'Exam for course % has been scheduled successfully for % on % at %',
            p_course_id, p_exam_type, p_exam_date, p_exam_time;
    END IF;
END;
$$ LANGUAGE plpgsql;
