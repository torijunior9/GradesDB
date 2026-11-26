CALL p_populate();

SET AUTOCOMMIT = 1;
START TRANSACTION;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (7, 1, 7.5, 'Extraordinaria', 0);

SELECT @@in_transaction;  
ROLLBACK;               

CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

SELECT @@in_transaction;  
ROLLBACK;               

SET AUTOCOMMIT = 1;

SELECT * FROM grades
WHERE student_id IN (6, 7) AND exam_call = 'Extraordinaria';

SELECT * FROM grades
WHERE student_id IN (6, 7) AND exam_call = 'Extraordinaria';

CALL p_populate();

SET AUTOCOMMIT = 0;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);

START TRANSACTION;  
ROLLBACK;           

SET AUTOCOMMIT = 1;

SELECT * FROM grades WHERE student_id = 6 AND exam_call = 'Extraordinaria';

CALL p_populate();

START TRANSACTION;

INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (6, 1, 4.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (7, 1, 7.5, 'Extraordinaria', 0);
INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
VALUES (8, 1, -7.5, 'Extraordinaria', 0);

COMMIT;

SELECT * FROM grades
WHERE student_id IN (6, 7, 8) AND exam_call = 'Extraordinaria';

CALL p_populate();

DELIMITER //
BEGIN NOT ATOMIC
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (6, 1, 4.5, 'Extraordinaria', 0);
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (7, 1, 7.5, 'Extraordinaria', 0);
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (8, 1, -7.5, 'Extraordinaria', 0);

    COMMIT;
END //
DELIMITER ;

SELECT * FROM grades
WHERE student_id IN (6, 7, 8) AND exam_call = 'Extraordinaria';

CREATE OR REPLACE PROCEDURE p_insert_degree_subject(
    IN p_degree_name VARCHAR(80),
    IN p_degree_years TINYINT,
    IN p_subject_name VARCHAR(120),
    IN p_subject_acronym VARCHAR(12),
    IN p_subject_credits TINYINT,
    IN p_subject_course TINYINT,
    IN p_subject_type VARCHAR(30)
)
BEGIN
    DECLARE v_new_degree_id INT;

    INSERT INTO degrees (degree_name, duration_years)
    VALUES (p_degree_name, p_degree_years);

    SET v_new_degree_id = LAST_INSERT_ID();

    INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
    VALUES (v_new_degree_id, p_subject_name, p_subject_acronym,
            p_subject_credits, p_subject_course, p_subject_type);
END //

CALL p_populate();

CALL p_insert_degree_subject(
    'Grado en Inteligencia Artificial',
    4,
    'Aprendizaje Automático',
    'AA',
    6,
    3,
    'Obligatoria'
);

SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE acronym = 'AA';

CALL p_populate();

CALL p_insert_degree_subject(
    'Grado en Ciberseguridad',
    4,
    'Redes Neuronales',
    'FP',  
    6,
    3,
    'Obligatoria'
);

SELECT * FROM degrees WHERE degree_name = 'Grado en Ciberseguridad';
SELECT * FROM subjects WHERE subject_name = 'Redes Neuronales';

CREATE OR REPLACE PROCEDURE p_insert_degree_subject_transactional(
    IN p_degree_name VARCHAR(80),
    IN p_degree_years TINYINT,
    IN p_subject_name VARCHAR(120),
    IN p_subject_acronym VARCHAR(12),
    IN p_subject_credits TINYINT,
    IN p_subject_course TINYINT,
    IN p_subject_type VARCHAR(30)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    CALL p_insert_degree_subject(p_degree_name, p_degree_years,
                                 p_subject_name, p_subject_acronym,
                                 p_subject_credits, p_subject_course, p_subject_type);

    COMMIT;
END //

CALL p_populate();
CALL p_insert_degree_subject_transactional(
    'Grado en Inteligencia Artificial',
    4,
    'Aprendizaje Automático',
    'AA',
    6,
    3,
    'Obligatoria'
);

SELECT * FROM degrees WHERE degree_name = 'Grado en Inteligencia Artificial';
SELECT * FROM subjects WHERE acronym = 'AA';

CALL p_populate();

CALL p_insert_degree_subject_transactional(
    'Grado en Ciberseguridad',
    4,
    'Redes Neuronales',
    'FP',  
    6,
    3,
    'Obligatoria'
);

SELECT * FROM degrees WHERE degree_name = 'Grado en Ciberseguridad';
SELECT * FROM subjects WHERE subject_name = 'Redes Neuronales';

