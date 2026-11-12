SELECT *
FROM subjects;

SELECT * 
FROM subjects s
WHERE s.acronym = "IISSI-1"

SELECT s.subject_name, s.acronym
FROM subjects s;

SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = "Formación Básica";

SELECT p.first_name, p.last_name, st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = "Selectividad";

SELECT p.first_name, p.last_name, pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = "Catedrático";

CREATE OR REPLACE VIEW v_professors AS 
SELECT 
	pr.professor_id,
	pr.category,
	p.person_id,
	p.dni,
	p.first_name,
	p.last_name,
	p.age,
	p.email
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;

CREATE OR REPLACE VIEW v_students AS
SELECT
   st.student_id,
   st.access_method,
   p.person_id,
   p.dni,
   p.first_name,
   p.last_name,
   p.age,
   p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;

SELECT AVG(g.grade_value) AS average_grade
FROM grades g
WHERE g.group_id = 1;

SELECT SUM(s.credits) AS total_credits
FROM subjects s
WHERE s.degree_id = 3;

SELECT COUNT(*) AS total_students
FROM students;

SELECT activity, COUNT(*) AS total_groups
FROM groups
GROUP BY activity;

SELECT MAC(g.grade_value) AS max_grade
FROM grades g;

SELECT MIN(g-grade_value) AS min_grade
FROM grades g;

SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value < 5 OR g.grade_value > 9;

SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;

SELECT g.grade_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.grade_value BETWEEN 5 AND 7;

SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits IN (6,12);

SELECT p.first_name, p.last_name, p.age
FROM people p
WHERE p.age BETWEEN 20 AND 30;

SELECT DISTINCT g.group_name
FROM groups g;

SELECT DISTINCT s.subject_type
FROM subjects s;

SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC;

SELECT DISTINCT g.academic_year
FROM groups g
ORDER BY g.academic_year DESC;

SELECT MAX(g.grade_value) AS max_grade
FROM grades g
WHERE g.student_id = 6;

SELECT MAX(g.grades_value) AS max_grade 
FROM grades g
WHERE g.student_id = 6;

SELECT DISTINCT ge.student_id
FROM group_enrollments ge 
WHERE ge.group_id IN (
	SELECT g.group_id
	FROM groups g
	WHERE g.academic_year = 2024
);

SELECT s.subject_name, s.credits
FROM subjects s
WHERE s.credits > (SELECT AVG(credits) FROM subjects);

SELECT p.first_name, p.last_name, p.dni
FROM people p
WHERE p.dni LIKE "%A";

SELECT s.subject_name
FROM subjects s
WHERE s.subject_name LIKE "Fundamentos%";

SELECT p.first_name, p.last_name
FROM people p
WHERE p.first_name LIKE "_____";

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year = 2024;

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
WHERE g.academic_year BETWEEN 2020 AND 2023
ORDER BY g.academic_year;

CREATE OR REPLACE VIEW v_grades_with_honors AS 
SELECT g.grade_id, g.student_id, g.group_id, g.grade_value, g.exam_call
FROM grades g
WHERE g.with_honors = 1;

CREATE OR REPLACE VIEW v_student_grades AS
SELECT 
	p.person_id,
	p.first_name,
	p.last_name,
	p.dni,
	g.grade_value,
	g.exam_call,
	g.with_honors,
	gr.group_name,
	gr.activity,
	gr.academic_year,
	s.subject_name,
	s.acronym,
	s.credits
FROM people p
JOIN students st ON p.person_id = st.student_id
JOIN grades g ON st.student_id = g.student_id
JOIN groups gr ON g.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

CREATE OR REPLACE VIEW v_professor_loads AS
SELECT
	p.person_id,
	p.first_name,
	p.last_name,
	pr.category,
	tl.credits AS teaching_credits,
	gr.group_name,
	gr.activity,
	gr.academic_year,
	s.subject_name,
	s.acronym
FROM people p
JOIN professors pr ON p.person_id = pr.professor_id
JOIN teaching_loads tl ON pr.professor_id = tl.professor_id
JOIN groups gr ON tl.group_id = gr.group_id
JOIN subjects s ON gr.subject_id = s.subject_id;

CREATE OR REPLACE VIEW v_degree_students AS 
SELECT DISTINCT
	d.degree_id,
	d.degree_name,
	p.person_id,
	p.first_name,
	p.last_name,
	st.access_method,
	gr.academic_year
FROM degrees d
JOIN subjects s ON d.degree_id = s.degree_id 
JOIN groups gr ON s.subject_id = gr.subject_id
JOIN students_groups ge ON gr.group_id = ge.group_id
JOIN students st ON ge.student_id = st.student_id
JOIN people p ON st.student_id = p.person_id;

SELECT COUNT(*) AS total_honors
FROM v_grades_with_honors;

SELECT v.first_name, v.last_name, AVG(v.grade_value) AS average_grade
FROM v_student_grades v
GROUP BY v.person_id, first_name, v.last_name;

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value ASC;

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC;

SELECT g.grade_id, g.student_id, g.grade_value, g.exam_call
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5;

SELECT
	st.first_name, 
	st.last_name,
	g.grade_value,
	g.exam_call
FROM grades g
JOIN v_students st ON g.student_id = st.student_id
WHERE g.grade_value >= 5
ORDER BY st.last_name ASC, st.first_name ASC;
	
SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC 
LIMIT 5 OFFSET 5;
	
SELECT g.grade_id, g.student_id, g.grade_value
FROM grades g
ORDER BY g.grade_value DESC
LIMIT 5 OFFSET 10;

SELECT g.group_name, g.activity, g.academic_year
FROM groups g
ORDER BY g.academic_year DESC, g.group_name ASC;


	


