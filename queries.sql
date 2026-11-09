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
	pr.first_name,
	p.age,
	p.email,
FROM students st
JOIN people p ON st.student_id = person_id;

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




