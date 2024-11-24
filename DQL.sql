--Update and View Syllabus

CREATE OR REPLACE FUNCTION update_syllabus(
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

SELECT * 
FROM Syllabus
WHERE course_id = 'CS101' AND semester = 'Fall' AND offered_year = 2024;

--View Students’ exam grades
SELECT 
	Exam_grades.student_id,
	Exam_grades.feedback,
	Exam.type as exam_type,
	Exam_grades.grade
FROM Exam_grades
INNER JOIN Exam ON Exam_grades.exam_id = Exam.exam_id
INNER JOIN Enrolls ON Exam_grades.student_id = Enrolls.student_id and Exam.course_id = Enrolls.course_id
WHERE Exam_grades.student_id = '1000001'
AND Exam.course_id = 'CS102'

--View Students’ final course grades
SELECT *
FROM Enrolls
where student_id = '1000001' and course_id = 'CS102'

