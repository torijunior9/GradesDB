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