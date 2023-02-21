SELECT MAX(COALESCE(enrolment, 0)), MIN(COALESCE(enrolment, 0))
FROM (
	SELECT COUNT(*) AS enrolment
	FROM takes
	GROUP BY course_id, sec_id, semester, year
) AS enrolments;




SELECT sec_id, enrolment
FROM (
	SELECT sec_id, COUNT(*) AS enrolment
	FROM takes
	GROUP BY course_id, sec_id, semester, year
) AS table1
WHERE enrolment = (SELECT MAX(COALESCE(enrolment, 0))
FROM (
	SELECT sec_id, COUNT(*) AS enrolment
	FROM takes
	GROUP BY course_id, sec_id, semester, year
) AS enrolments);

SELECT MAX(COALESCE(enrolment, 0)), MIN(COALESCE(enrolment, 0))
FROM (
	SELECT
		(SELECT COUNT(*)
		 FROM takes
		 WHERE course_id = s.course_id
		 AND sec_id = s.sec_id
		 AND semester = s.semester
		 AND year = s.year
		) AS enrolment
	FROM section s
) AS enrolments;



SELECT * FROM course where course_id LIKE 'CS-1%';

SELECT name from instructor WHERE dept_name='Biology';


SELECT T.course_id as name, COUNT(ID) as enrollment FROM takes T INNER JOIN section S
ON T.course_id = S.course_id
WHERE S.year = '2022' AND S.semester = 'Fall' GROUP BY T.course_id;

SELECT MAX(COALESCE(enrollment, 0))
FROM(
 SELECT T.course_id as name, COUNT(ID) as enrollment FROM takes T INNER JOIN section S
 ON T.course_id = S.course_id
 WHERE S.year = '2022' AND S.semester = 'Fall' GROUP BY T.course_id
) AS enrolments;
