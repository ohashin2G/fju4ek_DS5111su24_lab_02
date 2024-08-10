-- 1. Which courses are currently included (active) in the program? Include the course mnemonic and course name for each.
SELECT
mnemonic,
course_name,
FROM DS5111_SU24.FJU4EK.COURSES_ERD
WHERE course_active = 'TRUE';

-- 2. Which courses were included in the program, but are no longer active? Include the course mnemonic and course name for each.
SELECT
mnemonic,
course_name
FROM courses_erd
WHERE course_active = 'FALSE';

-- 3. Which instructors are not current employees?
SELECT
instructor_name
FROM instructors_erd
WHERE employee_status = 'Inactive';

-- 4. For each course (active and inactive), how many learning outcomes are there?
SELECT
c.course_name,
COUNT(o.learning_outcome)
FROM courses_erd c, learning_outcome_erd o
WHERE c.course_id = o.course_id
GROUP BY c.course_name ;

--5. Are there any courses with no learning outcomes? If so, provide their mnemonics and names.
SELECT
c.course_name,
FROM courses_erd c
WHERE c.course_id NOT IN (SELECT course_id FROM learning_outcome_erd);

--6. Which courses include SQL as a learning outcome? Include the learning outcome descriptions, course mnemonics, and course names in your solution.
SELECT
c.course_name,
o.learning_outcome,
c.mnemonic
FROM courses_erd c, learning_outcome_erd o
WHERE c.course_id = o.course_id
AND o.learning_outcome LIKE '%SQL%';

--7. Who taught course ds5100 in Summer 2021?
SELECT
a.term_id,
c.mnemonic,
i.instructor_name
FROM assigned_instructors_erd a, instructors_erd i, courses_erd c
WHERE a.instructor_id = i.instructor_id
AND a.course_id = c.course_id
AND a.term_id = '2021su'
AND c.mnemonic = 'ds5100' ;

--8. Which instructors taught in Fall 2021? Order their names alphabetically, making sure the names are unique.
SELECT
a.term_id,
i.instructor_name
FROM assigned_instructors_erd a, instructors_erd i, courses_erd c
WHERE a.instructor_id = i.instructor_id
AND a.course_id = c.course_id
AND a.term_id = '2021fa'
GROUP BY (a.term_id, i.instructor_name)
ORDER BY i.instructor_name;

-- 9. How many courses did each instructor teach in each term? Order your results by term and then instructor.
SELECT
a.term_id,
i.instructor_name,
COUNT(a.course_id),
FROM assigned_instructors_erd a, instructors_erd i
WHERE a.instructor_id = i.instructor_id
GROUP BY (a.term_id, i.instructor_name)
ORDER BY (a.term_id, i.instructor_name);


-- 10a. Which courses had more than one instructor for the same term? Provide the mnemonic and term for each. Note this occurs in courses with multiple sections.
SELECT
c.mnemonic,
a.term_id
FROM assigned_instructors_erd a, courses_erd c, instructors_erd i
WHERE a.course_id = c.course_id
GROUP BY (c.mnemonic, a.term_id)
HAVING COUNT(DISTINCT a.instructor_id) > 1
ORDER BY a.term_id, c.mnemonic ;

-- 10b. For courses with multiple sections, provide the term, course mnemonic, and instructor name for each. Hint: You can use your result from 10a in a subquery or WITH clause.
WITH courses_multiple_sections AS (
    SELECT
    c.mnemonic,
    a.term_id
    FROM assigned_instructors_erd a, courses_erd c, instructors_erd i
    WHERE a.course_id = c.course_id
    GROUP BY (c.mnemonic, a.term_id)
    HAVING COUNT(DISTINCT a.instructor_id) > 1
    ORDER BY a.term_id, c.mnemonic
)
SELECT  
m.term_id,
m.mnemonic,
i.instructor_name
FROM courses_multiple_sections m, assigned_instructors_erd a, instructors_erd i, courses_erd c
WHERE c.course_id = a.course_id
AND m.term_id = a.term_id
AND a.instructor_id = i.instructor_id
GROUP BY (m.mnemonic, m.term_id, i.instructor_name)
HAVING COUNT(DISTINCT c.course_id) > 1
ORDER BY m.term_id, m.mnemonic, i.instructor_name ;
