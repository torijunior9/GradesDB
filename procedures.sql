USE grados;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_delete_student_grades(
   IN p_student_dni CHAR(9)
)
BEGIN
   DECLARE v_student_id INT;
   SELECT student_id INTO v_student_id
   FROM people p
   JOIN students s ON s.student_id = p.person_id
   WHERE p.dni = p_student_dni;
   DELETE FROM grades WHERE student_id = v_student_id;
END //
DELIMITER ;

/*
CALL p_delete_student_grades("10000006F");
SELECT * FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE p.first_name = "10000006F";
*/

DELIMITER //
CREATE OR REPLACE PROCEDURE p_student_average(
	IN p_student_id INT,
	OUT p_average DECIMAL(4,2)
)
BEGIN
	SELECT AVG(grade_value) INTO p_average
	FROM grades
	WHERE student_id = p_student_id;
END //
DELIMITER ;

/*
CALL p_student_average(6, @avg_student_6);
SELECT @avg_student_6 AS "promedio del estudiante 6";

CALL p_student_average(7, @avg_student_7);
CALL p_student_average(8, @avg_student_8);
SELECT @avg_student_6, @avg_student_7, @avg_student_8;
*/

DELIMITER //                                            -- 0. Cambia el fin de instrucción a // para poder usar ; dentro

CREATE OR REPLACE PROCEDURE p_boost_group_grades(      -- 0. Crea el procedimiento con este nombre
   IN p_group_id INT,                                  -- 1. ENTRA: el grupo (ej. 1)
   IN p_exam_call VARCHAR(20)                          -- 1. ENTRA: la convocatoria (ej. 'Primera')
)
BEGIN                                                   --    Empieza el cuerpo

   DECLARE v_affected_rows INT;                        -- 2. Crea una caja vacía para contar las notas cambiadas
   DECLARE v_group_name VARCHAR(40);                   -- 2. Crea una caja vacía para el nombre del grupo

   SELECT group_name INTO v_group_name                 -- 3. Busca el nombre del grupo...
   FROM groups                                         --    ...en la tabla groups...
   WHERE group_id = p_group_id;                        --    ...del grupo que ha entrado. Lo guarda en v_group_name ('T1')

   UPDATE grades                                       -- 4. Va a MODIFICAR notas de la tabla grades
   SET grade_value = LEAST(grade_value * 1.15, 10.0)   -- 6. Nota nueva = nota × 1,15 (sube un 15 %), pero nunca más de 10
   WHERE group_id = p_group_id                         -- 5. Solo las notas de ESE grupo...
     AND exam_call = p_exam_call                       -- 5. ...Y de ESA convocatoria...
     AND grade_value BETWEEN 4.5 AND 8.0;              -- 5. ...Y que estén entre 4,5 y 8

   SET v_affected_rows = ROW_COUNT();                  -- 7. Cuenta cuántas notas ha cambiado el UPDATE y lo guarda (ej. 2)

   SELECT v_group_name AS group_name,                  -- 8. Enseña en pantalla el nombre del grupo...
         v_affected_rows AS updated_grades;           --    ...y cuántas notas ha subido

END //                                                  --    Acaba el procedimiento
DELIMITER ;                                             -- 0. Vuelve a poner ; como fin de instrucción

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id
JOIN people p ON p.person_id = s.student_id
WHERE g.group_id = 1 AND g.exam_call = "Primera"
ORDER BY g.grade_value;

CALL p_boost_group_grades(1, "Primera");

SELECT g.grade_id, p.first_name, p.last_name, g.grade_value, g.exam_call
FROM grades g
JOIN students s ON s.student_id = g.student_id 
JOIN people p ON p.person_id = s.student_id 
WHERE g.group_id = 1 AND g.exam_call = "Primera"
ORDER BY g.grade_value;



