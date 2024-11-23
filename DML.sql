INSERT INTO Users (user_id, email, user_type)
VALUES
(1000001, 'alice.smith@university.edu', 'student'),
(1000002, 'bob.brown@university.edu', 'student'),
(1000003, 'charlie.johnson@university.edu', 'student'),
(1000004, 'david.taylor@university.edu', 'student'),
(1000005, 'eve.williams@university.edu', 'student'),
(1000006, 'frank.jones@university.edu', 'student'),
(1000007, 'grace.adams@university.edu', 'student'),
(1000008, 'hannah.white@university.edu', 'student'),
(1000009, 'ian.martin@university.edu', 'student'),
(1000010, 'julia.king@university.edu', 'student'),
(1000011, 'kevin.moore@university.edu', 'student'),
(1000012, 'lisa.davis@university.edu', 'student'),
(1000013, 'mark.lee@university.edu', 'student'),
(1000014, 'nina.wood@university.edu', 'student'),
(1000015, 'oliver.turner@university.edu', 'student'),
(1000016, 'paula.johns@university.edu', 'student'),
(1000017, 'quentin.carter@university.edu', 'student'),
(1000018, 'rachel.evans@university.edu', 'student'),
(1000019, 'simon.morris@university.edu', 'student'),
(1000020, 'tina.clark@university.edu', 'student'),
(1000021, 'ursula.walker@university.edu', 'student'),
(1000022, 'victor.perez@university.edu', 'student'),
(1000023, 'wendy.hall@university.edu', 'student'),
(1000024, 'xander.lopez@university.edu', 'student'),
(1000025, 'yara.collins@university.edu', 'student'),
(1000026, 'anderson@university.edu', 'instructor'),
(1000027, 'moore@university.edu', 'instructor'),
(1000028, 'james@university.edu', 'instructor'),
(1000029, 'green@university.edu', 'instructor'),
(1000030, 'carter@university.edu', 'instructor'),
(1000031, 'johnson@university.edu', 'instructor'),
(1000032, 'wilson@university.edu', 'instructor'),
(1000033, 'smith@university.edu', 'instructor'),
(1000034, 'martinez@university.edu', 'instructor'),
(1000035, 'garcia@university.edu', 'instructor'),
(1000036, 'lopez@university.edu', 'instructor'),
(1000037, 'brown@university.edu', 'instructor'),
(1000038, 'davis@university.edu', 'instructor'),
(1000039, 'miller@university.edu', 'instructor'),
(1000040, 'taylor@university.edu', 'instructor');

INSERT INTO Student (student_id, first_name, last_name, status, cgpa)
VALUES
(1000001, 'Alice', 'Smith', 'undergraduate', 3.5),
(1000002, 'Bob', 'Brown', 'graduate', 3.8),
(1000003, 'Charlie', 'Johnson', 'undergraduate', 3.0),
(1000004, 'David', 'Taylor', 'non-degree', NULL),
(1000005, 'Eve', 'Williams', 'graduate', 3.9),
(1000006, 'Frank', 'Jones', 'undergraduate', 2.8),
(1000007, 'Grace', 'Adams', 'undergraduate', 3.2),
(1000008, 'Hannah', 'White', 'graduate', 3.7),
(1000009, 'Ian', 'Martin', 'undergraduate', 2.5),
(1000010, 'Julia', 'King', 'graduate', 3.4),
(1000011, 'Kevin', 'Moore', 'undergraduate', 3.1),
(1000012, 'Lisa', 'Davis', 'graduate', 3.6),
(1000013, 'Mark', 'Lee', 'undergraduate', 3.0),
(1000014, 'Nina', 'Wood', 'non-degree', NULL),
(1000015, 'Oliver', 'Turner', 'undergraduate', 2.9),
(1000016, 'Paula', 'Johns', 'graduate', 3.8),
(1000017, 'Quentin', 'Carter', 'graduate', 3.6),
(1000018, 'Rachel', 'Evans', 'undergraduate', 3.7),
(1000019, 'Simon', 'Morris', 'graduate', 3.3),
(1000020, 'Tina', 'Clark', 'undergraduate', 2.7),
(1000021, 'Ursula', 'Walker', 'undergraduate', 2.6),
(1000022, 'Victor', 'Perez', 'graduate', 3.9),
(1000023, 'Wendy', 'Hall', 'undergraduate', 3.4),
(1000024, 'Xander', 'Lopez', 'graduate', 3.5),
(1000025, 'Yara', 'Collins', 'undergraduate', 3.2);

INSERT INTO Instructor (instructor_id, first_name, last_name)
VALUES
(1000026, 'John', 'Anderson'),
(1000027, 'Michael', 'Moore'),
(1000028, 'David', 'James'),
(1000029, 'Sarah', 'Green'),
(1000030, 'Emily', 'Carter'),
(1000031, 'Andrew', 'Johnson'),
(1000032, 'Catherine', 'Wilson'),
(1000033, 'George', 'Smith'),
(1000034, 'Elizabeth', 'Martinez'),
(1000035, 'Henry', 'Garcia'),
(1000036, 'Sophia', 'Lopez'),
(1000037, 'Daniel', 'Brown'),
(1000038, 'Olivia', 'Davis'),
(1000039, 'James', 'Miller'),
(1000040, 'Isabella', 'Taylor');

INSERT INTO Courses (course_id, course_name, category, description)
VALUES
('CS101', 'Intro to Computer Science', 'Technology', 'Introduction to programming concepts and systems.'),
('CS102', 'Data Structures', 'Technology', 'Learn arrays, linked lists, and trees.'),
('CS201', 'Algorithms', 'Technology', 'In-depth analysis of algorithms.'),
('ENG101', 'English Literature', 'Arts', 'Explore classical and modern literature.'),
('BUS101', 'Intro to Business', 'Business', 'Fundamentals of business concepts.'),
('MTH101', 'Calculus I', 'Science', 'Study of limits, derivatives, and integrals.'),
('PHY101', 'Physics I', 'Science', 'Fundamentals of mechanics and waves.'),
('BIO101', 'Biology I', 'Science', 'Introduction to cell biology and genetics.'),
('HIS101', 'World History', 'Arts', 'Survey of major historical events globally.'),
('CHE101', 'Chemistry I', 'Science', 'Basics of chemical reactions.'),
('CS202', 'Machine Learning', 'Technology', 'An introduction to ML techniques.'),
('CS203', 'Artificial Intelligence', 'Technology', 'AI principles and applications.'),
('PSY101', 'Psychology Basics', 'Social Science', 'Fundamentals of human psychology.'),
('SOC101', 'Sociology Intro', 'Social Science', 'Study of social behavior and structure.'),
('MKT101', 'Marketing 101', 'Business', 'Introduction to marketing principles.'),
('LAW101', 'Legal Studies I', 'Law', 'Basics of legal systems and laws.'),
('MED101', 'Medical Terminology', 'Medicine', 'Intro to medical terms and concepts.'),
('PHI101', 'Philosophy Basics', 'Arts', 'Intro to major philosophical ideas.'),
('ART101', 'Art History', 'Arts', 'Survey of art through history.'),
('MUS101', 'Music Theory', 'Arts', 'Basics of musical theory.'),
('CS204', 'Cybersecurity', 'Technology', 'Introduction to information security.'),
('BIO201', 'Microbiology', 'Science', 'Study of microorganisms.'),
('CHE201', 'Organic Chemistry', 'Science', 'Study of carbon compounds.'),
('PHY201', 'Electromagnetism', 'Science', 'Introduction to electromagnetism principles.'),
('PSY201', 'Advanced Psychology', 'Social Science', 'In-depth study of psychological theories.');

INSERT INTO Course_section (course_id, section_id, semester, offered_year, start_date, end_date, student_count, weekday, time, instructor_id)
VALUES
('CS101', 1, 'Fall', 2024, '2024-09-01', '2024-12-15', 25, 'Monday', '10:00:00', 1000026),
('CS102', 1, 'Spring', 2024, '2024-01-15', '2024-05-15', 20, 'Wednesday', '11:00:00', 1000027),
('CS102', 2, 'Fall', 2024, '2024-09-01', '2024-12-15', 18, 'Thursday', '13:00:00', 1000028),
('CS201', 1, 'Spring', 2025, '2025-01-15', '2025-05-15', 22, 'Tuesday', '14:00:00', 1000029),
('CS202', 1, 'Summer', 2024, '2024-06-01', '2024-08-15', 20, 'Monday', '15:00:00', 1000030),
('CS202', 2, 'Summer', 2024, '2024-06-01', '2024-08-15', 19, 'Tuesday', '10:00:00', 1000031),
('CS204', 1, 'Spring', 2025, '2025-01-15', '2025-05-15', 18, 'Monday', '13:00:00', 1000026),
('MTH101', 1, 'Spring', 2024, '2024-01-15', '2024-05-15', 20, 'Tuesday', '10:00:00', 1000032),
('PHY101', 1, 'Fall', 2024, '2024-09-01', '2024-12-15', 18, 'Wednesday', '14:00:00', 1000033),
('BIO101', 1, 'Summer', 2024, '2024-06-01', '2024-08-15', 25, 'Thursday', '12:00:00', 1000034),
('BIO101', 2, 'Fall', 2024, '2024-09-01', '2024-12-15', 22, 'Monday', '15:00:00', 1000035),
('CHE101', 1, 'Spring', 2025, '2025-01-15', '2025-05-15', 20, 'Friday', '11:00:00', 1000036),
('CHE201', 1, 'Fall', 2025, '2025-09-01', '2025-12-15', 20, 'Wednesday', '11:00:00', 1000037),
('ENG101', 1, 'Fall', 2024, '2024-09-01', '2024-12-15', 20, 'Monday', '09:00:00', 1000039),
('ENG101', 2, 'Spring', 2025, '2025-01-15', '2025-05-15', 25, 'Thursday', '10:00:00', 1000040),
('BUS101', 1, 'Fall', 2024, '2024-09-01', '2024-12-15', 18, 'Monday', '10:00:00', 1000039),
('BUS101', 2, 'Spring', 2025, '2024-01-15', '2025-05-15', 18, 'Monday', '10:00:00', 1000039),
('MKT101', 1, 'Spring', 2024, '2024-01-15', '2024-05-15', 22, 'Tuesday', '12:00:00', 1000039),
('MED101', 1, 'Fall', 2025, '2025-09-01', '2025-12-15', 19, 'Monday', '09:00:00', 1000036),
('LAW101', 1, 'Spring', 2025, '2025-01-15', '2025-05-15', 17, 'Thursday', '12:00:00', 1000037);

INSERT INTO Prerequisites (course_id, prereq_id)
VALUES
('CS102', 'CS101'), -- Data Structures requires Intro to Computer Science
('CS201', 'CS102'), -- Algorithms requires Data Structures
('CS202', 'CS201'), -- Machine Learning requires Algorithms
('CS203', 'CS201'), -- Artificial Intelligence requires Algorithms
('CS204', 'CS201'), -- Cybersecurity requires Algorithms
('CS202', 'MTH101'), -- Machine Learning also requires Calculus I
('CS203', 'MTH101'), -- Artificial Intelligence also requires Calculus I
('CS204', 'PHY101'), -- Cybersecurity also requires Physics I
('MTH101', 'PHY101'), -- Calculus I requires Physics I
('BIO201', 'BIO101'), -- Microbiology requires Biology I
('CHE201', 'CHE101'), -- Organic Chemistry requires Chemistry I
('PHY201', 'PHY101'), -- Electromagnetism requires Physics I
('BIO201', 'CHE101'), -- Microbiology also requires Chemistry I
('CHE201', 'BIO101'), -- Organic Chemistry also requires Biology I
('PSY201', 'PSY101'), -- Advanced Psychology requires Psychology Basics
('ART101', 'PHI101'), -- Art History requires Philosophy Basics
('MUS101', 'ART101'), -- Music Theory requires Art History
('MKT101', 'BUS101'); -- Marketing 101 requires Intro to Business

INSERT INTO Enrolls (student_id, course_id, section_id, semester, offered_year, final_grade)
VALUES
(1000001, 'CS102', 2, 'Fall', 2024, 99.61),
(1000001, 'CS202', 2, 'Summer', 2024, 51.66),
(1000001, 'CHE101', 1, 'Spring', 2025, 98.51),
(1000002, 'CHE101', 1, 'Spring', 2025, 68.43),
(1000002, 'CS102', 1, 'Spring', 2024, 99.23),
(1000002, 'CS204', 1, 'Spring', 2025, 77.64),
(1000003, 'ENG101', 2, 'Spring', 2025, 80.25),
(1000003, 'CS102', 2, 'Fall', 2024, 56.31),
(1000003, 'CS201', 1, 'Spring', 2025, 89.91),
(1000004, 'MTH101', 1, 'Spring', 2024, 73.15),
(1000004, 'PHY101', 1, 'Fall', 2024, 92.54),
(1000004, 'BUS101', 1, 'Fall', 2024, 60.47),
(1000005, 'CS101', 1, 'Fall', 2024, 87.62),
(1000005, 'BIO101', 1, 'Summer', 2024, 78.83),
(1000006, 'BIO101', 2, 'Fall', 2024, 62.09),
(1000006, 'CS102', 2, 'Fall', 2024, 59.74),
(1000007, 'ENG101', 2, 'Spring', 2025, 91.08),
(1000007, 'BUS101', 1, 'Fall', 2024, 73.52),
(1000007, 'CS202', 2, 'Summer', 2024, 85.61),
(1000008, 'CS101', 1, 'Fall', 2024, 63.49),
(1000008, 'CS202', 1, 'Summer', 2024, 89.65),
(1000008, 'ENG101', 1, 'Fall', 2024, 92.18),
(1000009, 'BIO101', 1, 'Summer', 2024, 68.40),
(1000009, 'CHE101', 1, 'Spring', 2025, 55.32),
(1000009, 'PHY101', 1, 'Fall', 2024, 86.73),
(1000010, 'CHE101', 1, 'Spring', 2025, 90.51),
(1000010, 'CS201', 1, 'Spring', 2025, 84.63);


INSERT INTO Exam (exam_id, course_id, type, date, time)
VALUES
(1, 'CS101', 'midterm', '2024-10-15', '09:00:00'),
(2, 'CS101', 'final', '2024-12-10', '14:00:00'),
(3, 'CS102', 'midterm', '2024-03-15', '10:30:00'),
(4, 'CS102', 'final', '2024-05-10', '15:00:00'),
(5, 'CS201', 'midterm', '2025-03-15', '11:00:00'),
(6, 'CS201', 'final', '2025-05-10', '16:00:00'),
(7, 'CS202', 'midterm', '2024-07-15', '09:00:00'),
(8, 'CS202', 'final', '2024-08-10', '14:30:00'),
(9, 'CS204', 'midterm', '2025-03-15', '08:30:00'),
(10, 'CS204', 'final', '2025-05-10', '13:30:00'),
(11, 'MTH101', 'midterm', '2024-03-15', '09:30:00'),
(12, 'MTH101', 'final', '2024-05-10', '14:45:00'),
(13, 'PHY101', 'midterm', '2024-10-15', '10:45:00'),
(14, 'PHY101', 'final', '2024-12-10', '16:00:00'),
(15, 'BIO101', 'midterm', '2024-07-15', '08:30:00'),
(16, 'BIO101', 'final', '2024-08-10', '14:00:00'),
(17, 'CHE101', 'midterm', '2025-03-15', '09:00:00'),
(18, 'CHE101', 'final', '2025-05-10', '14:15:00'),
(19, 'ENG101', 'midterm', '2024-10-15', '13:00:00'),
(20, 'ENG101', 'final', '2024-12-10', '15:30:00');

INSERT INTO Exam_grades (exam_id, student_id, grade)
VALUES
(1, 1000001, 80.55),
(2, 1000001, 70.24),
(3, 1000001, 75.72),
(4, 1000001, 98.09),
(5, 1000002, 88.12),
(6, 1000002, 79.45),
(7, 1000003, 91.34),
(8, 1000003, 89.23),
(9, 1000003, 78.56),
(10, 1000004, 95.20),
(11, 1000004, 63.25),
(12, 1000004, 81.44),
(13, 1000005, 88.45),
(14, 1000005, 92.13),
(15, 1000006, 77.19),
(16, 1000006, 83.45),
(17, 1000007, 67.12),
(18, 1000007, 75.50),
(19, 1000008, 88.78),
(20, 1000008, 92.34);

INSERT INTO Syllabus (course_id, section_id, semester, offered_year, description, final_weight, midterm_weight, passing_grade)
VALUES
('CS101', 1, 'Fall', 2024, 'This syllabus covers the fundamentals of computer science, including programming concepts and problem-solving techniques.', 0.6, 0.4, 50),
('CS102', 1, 'Spring', 2024, 'This syllabus focuses on data structures, covering arrays, linked lists, stacks, queues, and trees with practical applications.', 0.6, 0.4, 55),
('CS102', 2, 'Fall', 2024, 'Advanced section of data structures emphasizing hands-on implementation and algorithmic optimizations.', 0.5, 0.5, 60),
('CS201', 1, 'Spring', 2025, 'This syllabus explores algorithm design and analysis, including sorting, searching, and graph algorithms.', 0.7, 0.3, 58),
('CS202', 1, 'Summer', 2024, 'Introduction to machine learning techniques, including regression, classification, and neural networks.', 0.6, 0.4, 60),
('CS202', 2, 'Summer', 2024, 'Intermediate machine learning with a focus on hands-on projects using modern ML frameworks.', 0.5, 0.5, 62),
('CS204', 1, 'Spring', 2025, 'Foundations of cybersecurity covering cryptographic methods, threat analysis, and secure coding practices.', 0.7, 0.3, 65),
('MTH101', 1, 'Spring', 2024, 'This syllabus covers calculus basics, including limits, derivatives, and integrals, with applications to physics.', 0.6, 0.4, 50),
('PHY101', 1, 'Fall', 2024, 'An introduction to classical mechanics, including kinematics, Newtonian mechanics, and energy conservation.', 0.6, 0.4, 52),
('BIO101', 1, 'Summer', 2024, 'This syllabus focuses on cell biology, genetics, and molecular biology, with an emphasis on laboratory techniques.', 0.6, 0.4, 55),
('BIO101', 2, 'Fall', 2024, 'Advanced biology section covering genetics, molecular biology, and bioinformatics tools.', 0.5, 0.5, 60),
('CHE101', 1, 'Spring', 2025, 'Introduction to chemistry, including atomic structure, chemical bonding, and stoichiometry.', 0.7, 0.3, 58),
('CHE201', 1, 'Fall', 2025, 'Organic chemistry syllabus focusing on carbon-based compounds, reaction mechanisms, and synthesis strategies.', 0.6, 0.4, 62),
('ENG101', 1, 'Fall', 2024, 'This syllabus explores English literature, covering classical works and contemporary themes.', 0.5, 0.5, 50),
('ENG101', 2, 'Spring', 2025, 'A deeper dive into modern English literature, including poetry, novels, and literary analysis.', 0.6, 0.4, 55),
('BUS101', 1, 'Fall', 2024, 'This syllabus introduces business fundamentals, including management, marketing, and entrepreneurship.', 0.6, 0.4, 55),
('BUS101', 2, 'Spring', 2025, 'Advanced business concepts focusing on case studies, strategy development, and market analysis.', 0.5, 0.5, 60),
('MKT101', 1, 'Spring', 2024, 'This syllabus covers marketing principles, including consumer behavior, branding, and digital marketing strategies.', 0.6, 0.4, 58),
('MED101', 1, 'Fall', 2025, 'Introduction to medical terminology, covering basic medical concepts, anatomy, and healthcare practices.', 0.6, 0.4, 58),
('LAW101', 1, 'Spring', 2025, 'This syllabus introduces legal systems, constitutional law, and the role of law in society.', 0.7, 0.3, 60);


INSERT INTO Discussion (course_id, section_id, semester, offered_year, discussion_id, creator_id, title, disucssion_content)
VALUES
('CS101', 1, 'Fall', 2024, 1, 1000001, 'Understanding Variables', 'Can someone explain the difference between local and global variables?'),
('CS102', 1, 'Spring', 2024, 2, 1000002, 'Data Structures Efficiency', 'What is the most efficient data structure for searching and why?'),
('CS102', 2, 'Fall', 2024, 3, 1000003, 'Sorting Algorithms', 'Which sorting algorithm is better for small data sets?'),
('CS201', 1, 'Spring', 2025, 4, 1000004, 'Algorithm Complexity', 'Can someone clarify how to calculate the Big-O notation for an algorithm?'),
('CS202', 1, 'Summer', 2024, 5, 1000005, 'Introduction to Regression', 'What is the difference between linear and logistic regression?'),
('MTH101', 1, 'Spring', 2024, 6, 1000006, 'Integration Techniques', 'Can anyone recommend resources for mastering integration techniques?'),
('PHY101', 1, 'Fall', 2024, 7, 1000007, 'Newton’s Laws', 'How do Newton’s laws apply to orbital motion?'),
('BIO101', 1, 'Summer', 2024, 8, 1000008, 'Genetics Basics', 'What are the key differences between mitosis and meiosis?'),
('ENG101', 1, 'Fall', 2024, 9, 1000009, 'Modern Literature Themes', 'What are the main themes in modern English literature?');

INSERT INTO Discussion_comments (comment_id, discussion_id, creator_id, comment_content)
VALUES
(1, 1, 1000002, 'Local variables are defined inside functions, while global variables are accessible throughout the program.'),
(2, 1, 1000003, 'Global variables should be used sparingly to avoid conflicts.'),
(3, 2, 1000004, 'Hash tables are often the most efficient for searching due to O(1) average time complexity.'),
(4, 2, 1000005, 'It depends on the type of search; binary search trees are also efficient for ordered data.'),
(5, 3, 1000006, 'For small data sets, bubble sort or insertion sort is simple and efficient.'),
(6, 4, 1000007, 'To calculate Big-O, focus on the dominant term and ignore constants.'),
(7, 5, 1000008, 'Linear regression is used for continuous data, while logistic regression is used for classification problems.'),
(8, 6, 1000009, 'Khan Academy has great videos on integration techniques.'),
(9, 7, 1000010, 'Newton’s laws describe how objects in motion are influenced by gravitational forces.');