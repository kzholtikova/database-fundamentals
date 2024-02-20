SELECT COUNT(*) count
FROM marks;

SELECT m.subject_id, COUNT(*) records
FROM marks m
GROUP BY m.subject_id;

SELECT COUNT(*) count
FROM marks m
GROUP BY m.student_id;

# count od students passing each subject
SELECT sb.subject_name, COUNT(*) count
FROM (SELECT m.subject_id, m.student_id, AVG(m.mark) AS avg_mark
      FROM marks m
      GROUP BY m.student_id, m.subject_id
      HAVING avg_mark > 65) avg
         JOIN test.subjects sb ON avg.subject_id = sb.subject_id
GROUP BY sb.subject_name
ORDER BY count DESC;

SELECT sb.subject_name, COUNT(*) count
FROM (SELECT m.subject_id, m.student_id, AVG(m.mark) AS avg_mark
      FROM marks m
      GROUP BY m.student_id, m.subject_id) avg
         JOIN test.subjects sb ON avg.subject_id = sb.subject_id
WHERE avg_mark > 65
GROUP BY sb.subject_name
ORDER BY count DESC;

# average mark for each student by the subject
SELECT s.student_name, sb.subject_name, AVG(m.mark) AS avg_mark
FROM marks m
         JOIN students s ON m.student_id = s.student_id
         JOIN subjects sb ON m.subject_id = sb.subject_id
GROUP BY m.student_id, sb.subject_id
ORDER BY s.student_name, sb.subject_name;


# subject with low average marks
SELECT s.subject_name, AVG(mark) avg_mark
FROM marks m
    JOIN test.subjects s on m.subject_id = s.subject_id
GROUP BY m.subject_id
HAVING avg_mark < 70
ORDER BY avg_mark;


# subject with a min number of marks
SELECT s.subject_name, COUNT(mark) marks_count
FROM marks m
    JOIN test.subjects s on m.subject_id = s.subject_id
GROUP BY m.subject_id
ORDER BY marks_count
LIMIT 1;


# groups with below average performance
SELECT sg.group_name, AVG(mark) avg_mark, (SELECT AVG(mark) FROM marks) overall_avg
FROM marks m
    JOIN test.students s on m.student_id = s.student_id
    JOIN test.study_groups sg on s.group_id = sg.group_id
GROUP BY s.group_id
HAVING avg_mark < overall_avg
ORDER BY avg_mark;


SELECT a.subject_id, count(a.subject_id) passing
FROM (SELECT m.subject_id, avg(m.mark) avg_mark
      FROM marks m
      GROUP BY m.student_id, m.subject_id
      having avg_mark > 65) a
GROUP BY a.subject_id;

# find students with above average marks in a specific subjects
SELECT s.student_name, avg_mark
FROM (SELECT student_id, AVG(mark) avg_mark
        FROM marks m
        WHERE subject_id = 1
        GROUP BY m.student_id) avg_marks
    JOIN students s on avg_marks.student_id = s.student_id
WHERE avg_mark > 80
ORDER BY avg_mark DESC;

# list subjects with the highest average mark
SELECT s.subject_name, avg_mark
FROM (SELECT subject_id, AVG(mark) avg_mark
      FROM marks m
      GROUP BY m.subject_id) avg_marks
    JOIN subjects s on avg_marks.subject_id = s.subject_id
ORDER BY avg_mark DESC
LIMIT 3;
