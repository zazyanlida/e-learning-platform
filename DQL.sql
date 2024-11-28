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

DROP FUNCTION  view_student_course_grades(p_student_id INT, p_course_id VARCHAR(255));
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
Drop function view_class_grades;
CREATE OR REPLACE FUNCTION view_class_grades (
	p_course_id VARCHAR(255),
	p_semester VARCHAR(255), 
	p_offered_year INT, 
	p_section_id INT
)
RETURNS TABLE(
	student_id INT,
	final_grade DECIMAL(5,2),
	midterm_grade DECIMAL(5,2)L,
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

Drop function get_course_statistics;
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

DROP function view_exams
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
CREATE OR REPLACE FUNCTION leave_course_feedback(
    p_student_id INT, 
    p_course_id VARCHAR(255),
    p_section_id INT,
    p_semester VARCHAR(255),
    p_offered_year INT,
    p_feedback_text TEXT
)
RETURNS VOID AS $$
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

    -- Insert feedback for the student into Exam_grades
    -- We will assume there is at least one exam for the course and student, and we will insert feedback for the first exam found
    INSERT INTO Exam_grades (exam_id, student_id, grade, feedback)
    SELECT exam_id, p_student_id, grade, p_feedback_text
    FROM Exam_grades
    WHERE exam_id IN (
        SELECT exam_id 
        FROM Exam 
        WHERE course_id = p_course_id 
        AND date > CURRENT_DATE
        LIMIT 1
    )
    AND student_id = p_student_id
    ON CONFLICT (exam_id, student_id) 
    DO UPDATE SET feedback = EXCLUDED.feedback; 
    
    -- Notify the user that feedback was submitted
    RAISE NOTICE 'Feedback successfully submitted for student % in course %', p_student_id, p_course_id;
END;
$$ LANGUAGE plpgsql;
	SELECT leave_course_feedback(1000001, 'CS101', 1, 'Fall', 2024, 'This course was great!');
SELECT * FROM Exam_grades 
WHERE student_id = 1000001
AND exam_id IN (
    SELECT exam_id 
    FROM Exam 
    WHERE course_id = 'CS101'
);

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
-- Example usage to view syllabus for a student enrolled in a course
SELECT * FROM view_course_syllabus(1000001, 'CS102', 1, 'Fall', 2024);

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
SELECT * FROM view_exam_schedule(1000001, 'CS101', 1, 'Fall', 2024);

-----Droping course
drop function drop_course
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
-- Example usage: Drop a course for a student
SELECT drop_course(1000001, 'CS102', 2, 'Fall', 2024);
select * from Enrolls


------------------Admin Operations-----------------------------------------------------------------------------









