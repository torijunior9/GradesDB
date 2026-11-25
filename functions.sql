USE grados;

DELIMITER //

CREATE OR REPLACE FUNCTION f_student_average(
	p_student_id INT
) RETURNS DECIMAL(4,2)
BEGIN
	DECLARE v_average DECIMAL(4,2) DEFAULT 0;
	
	SELECT COALESCE(AVG(grade_value), 0) INTO v_average
	FROM grades
	WHERE student_id = p_student_id;
	
	RETURN v_average;
END //
DELIMITER ;

SELECT f_student_average(6) AS 'Promedio del estudiante 6';

SELECT p.first_name, p.last_name,
       f_student_average(s.student_id) AS promedio
FROM people p
JOIN students s ON s.student_id = p.person_id
ORDER BY promedio DESC;


DELIMITER //
CREATE OR REPLACE FUNCTION f_is_student_enrolled(
	p_student_id INT, 
	p_subject_id INT
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_exists INT;
	SELECT COUNT(*) INTO v_exists
	FROM subject_enrollments
	WHERE student_id = p_student_id
		AND subject_id = p_subject_id;
	RETURN v_exists > 0;
END //
DELIMITER ;

SELECT s.subject_id, s.subject_name,
	f_is_student_enrolled(6, s.subject_id) AS matriculado
FROM subjects s
WHERE s.degree_id = 3;


DELIMITER //
CREATE OR REPLACE FUNCTION f_subject_group_limit_reached(
	p_subject_id INT,
	p_activity VARCHAR(15),
	p_academic_year YEAR
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN 
	DECLARE v_count INT;
	DECLARE v_result BOOLEAN DEFAULT FALSE;
	
	SELECT COUNT(*) INTO v_count
	FROM groups
	WHERE subject_id = p_subject_id
		AND activity = p_activity
		AND academic_year = p_academic_year;
		
		IF p_activity = "Teoría" THEN
			SET v_result = (v_count >= 1);
		ELSEIF p_activity = "Laboratorio" THEN 
			SET v_result = (v_count >= 2);
		END IF;
	
		RETURN v_result;
END //
DELIMITER ;

SELECT f_subject_group_limit_reached(1, 'Teoría', 2025) AS 'Límite alcanzado';

SELECT s.subject_id, s.subject_name, s.acronym
FROM subjects s
WHERE f_subject_group_limit_reached(s.subject_id, 'Teoría', 2025) = TRUE;


DELIMITER //
CREATE OR REPLACE FUNCTION f_student_group_limit(
	p_student_id INT,
	p_subject_id INT,
	p_activity VARCHAR(15)
)
RETURNS BOOLEAN 
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_count INT;
	SELECT COUNT(*) INTO v_count
	FROM students_groups ge
	JOIN groups g ON g.group_id = ge.group_id
	WHERE ge.student_id = p_student_id
		AND g.subject_id = p_subject_id
		AND g.activity = p_activity;
		
	RETURN v_count >= 1;
END //
DELIMITER ;	

