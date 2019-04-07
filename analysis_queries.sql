-- Compare results for Bio 1 students in respect to STEM Center Peer-Tutor/Mentor Program attendance:
-- This task is performed for Fall 2017 and Spring 2018 – so, two completely different data set analysis


-- ***** Fall 2017: *****
-- Report total # of students enrolled in the class – Dr. Beaster-Jones will provide class rosters for each semester
-- There are 516 students on the Bio 1 course roster.

SELECT COUNT(*)
FROM bio1
WHERE Semester = "Fall 2017";
-- Returns 464, so the survey was completed 464 times






SELECT DISTINCT name
FROM bio1
WHERE Semester = "Fall 2017"
ORDER BY name;
-- Returns 459 names. So only 459 students took the survey, but 5 students took it twice lol (unless there are 2 people in the class with the exact same name).

SELECT name
FROM bio1
WHERE Semester = "Fall 2017"
ORDER BY name;
-- Returns 464 names

-- Find all students with same name

SELECT name
FROM bio1
WHERE Semester = "Fall 2017" AND name NOT IN(
    SELECT DISTINCT name
    FROM bio1
    WHERE Semester = "Fall 2017"
);
-- Returns 411 with distinct, 418 without distinct




-- Five students took the survey twice???
CREATE View survey_count AS
SELECT name, COUNT(name) AS numOccurences 
FROM bio1
WHERE Semester = "Fall 2017"
GROUP BY name
ORDER BY numOccurences DESC;

SELECT * FROM survey_count;

SELECT survey_count.name, survey_count.numOccurrences
FROM survey_count, bio1
WHERE survey_count.name = bio1.name AND survey_count.numOccurences > 1;


-- 5 students have the same name???


-- Report total # of students who used the peer-tutors’ help




-- Provide the list of students who used the STEM Center more than 8 times per semester + indicate specific number of visits for each students
-- For all students 




-- Provide the list of students who used the STEM Center 5-8 times per semester+ indicate specific number of visits for each students

-- Same as above for students with 1-4 visits per semester

 
-- ***** Spring 2018: *****
-- Report total # of students enrolled in the class – Dr. Beaster-Jones will provide class rosters for each semester

-- Report total # of students who used the peer-tutors’ help – Petia will provide list of STEM Center attendees

-- Provide the list of students who used the STEM Center more than 8 times per semester + indicate specific number of visits for each students

-- Provide the list of students who used the STEM Center 5-8 times per semester+ indicate specific number of visits for each students

-- Same as above for students with 1-4 visits per semester

 

-- ***** For both semesters, or STEM Center in general *****


-- Find students who were in both semesters of bio 1:
SELECT *
FROM bio1 F17, bio1 S18
WHERE F17.Semester = "Fall 2017" AND S18.Semester = "Spring 2018" AND F17.name = S18.name
ORDER BY F17.name;
-- There were 18 students in both semesters


-- Provide the list of students who used the STEM Center more than 8 times per semester + indicate specific number of visits for each students
-- For all students

SELECT First_Name, Last_Name, COUNT(*)
FROM signins
GROUP BY First_Name, Last_Name
ORDER BY COUNT(*) DESC;


-- Find counts of all people who have ever taken bio 1 in the semesters, and have ever signed into the STEM Center
SELECT DISTINCT name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1.name
GROUP BY bio1.name
ORDER BY numSignIns DESC;

-- Find counts of all people who have ever taken bio 1 in the semesters, and actually signed in DURING THE SEMESTER THEY TOOK bio1
SELECT DISTINCT name, bio1.Semester, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1.name AND signins.Semester = bio1.Semester
GROUP BY bio1.name
ORDER BY bio1.Semester, numSignIns DESC;


SELECT COUNT(*)
FROM bio1
WHERE STEM_Resource_Center_study_groups = 1;

SELECT COUNT(DISTINCT name)
FROM bio1;


-- TODO: Find all bio 1 students who signed in, but did not say they used the STEM Resource center study groups
-- TODO: Find all bio 1 students who said they used the STEM resource center study groups, but did not sign in
-- TODO: Find all bio 1 students who both said they used the STEM resource center study groups and signed in
-- TODO: Read the bio 1 rosters into the database (not just the bio 1 survey responses)
-- TODO: Find all students who are on the roster, but did not take the survey
-- TODO: Make a Venn diagam indicating the overlap between the bio 1 roster, the bio1 survey data, and the stem center signins. This will show how many students are in each group individually, and in both groups. Do this for both bio 1 semesters.
-- TODO: Finish report and email to Petia. After Petia reviews it and you make the corrections, schedule an in-person meeting with Petia. Then email it to Beaster-Jones.
