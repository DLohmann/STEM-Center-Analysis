-- Compare results for Bio 1 students in respect to STEM Center Peer-Tutor/Mentor Program attendance:
-- This task is performed for Fall 2017 and Spring 2018 – so, two completely different data set analysis









-- ***** Fall 2017: *****
-- Report total # of students enrolled in the class – Dr. Beaster-Jones will provide class rosters for each semester
-- There are 517 students on the Bio 1 course roster.
SELECT COUNT(*)
FROM bio1roster;






SELECT COUNT(*)
FROM bio1survey
WHERE Semester = "Fall 2017";
-- Returns 464, so the survey was completed 464 times

-- Fall 2017 Data Summary
-- Entries on survey
SELECT COUNT(*)
FROM bio1survey
WHERE Semester = "Fall 2017";    -- 464
-- Entries on roster
SELECT COUNT(*)
FROM bio1roster
WHERE Semester = "Fall 2017";    -- 517
-- Duplicates on survey
SELECT COUNT(*)
FROM (
    SELECT 1
    FROM bio1survey
    WHERE Semester = "Fall 2017"
    GROUP BY name
    HAVING COUNT(name) > 1
);    -- 5
-- Duplicates on roster
SELECT COUNT(*)
FROM (
    SELECT 1
    FROM bio1roster
    WHERE Semester = "Fall 2017"
    GROUP BY First_Name || " " || Last_Name
    HAVING COUNT(First_Name || " " || Last_Name) > 1
);    -- 1




-- Spring 2018 Data Summary
-- Entries on survey
SELECT COUNT(*)
FROM bio1survey
WHERE Semester = "Spring 2018";    -- 436
-- Entries on roster
SELECT COUNT(*)
FROM bio1roster
WHERE Semester = "Spring 2018";    -- 485
-- Duplicates on survey
SELECT COUNT(*)
FROM (
    SELECT 1
    FROM bio1survey
    WHERE Semester = "Spring 2018"
    GROUP BY name
    HAVING COUNT(name) > 1
);    -- 7
-- Duplicates on roster
SELECT COUNT(*)
FROM (
    SELECT 1
    FROM bio1roster
    WHERE Semester = "Spring 2018"
    GROUP BY First_Name || " " || Last_Name
    HAVING COUNT(First_Name || " " || Last_Name) > 1
);    -- 2


SELECT DISTINCT name
FROM bio1survey
WHERE Semester = "Fall 2017"
ORDER BY name;
-- Returns 459 names. So only 459 students took the survey, but 5 students took it twice lol (unless there are 2 people in the class with the exact same name).

SELECT name
FROM bio1survey
WHERE Semester = "Fall 2017"
ORDER BY name;
-- Returns 464 names

-- Find all students with same name

SELECT name
FROM bio1survey
WHERE Semester = "Fall 2017" AND name NOT IN(
    SELECT DISTINCT name
    FROM bio1survey
    WHERE Semester = "Fall 2017"
);
-- Returns 411 with distinct, 418 without distinct




-- 5 students have the same name???

-- Table 1: Fall 2017 Bio 1 STEM Center Signins And Survey Results.csv (this query was used to create this table in the report)
-- Make table of name vs number of visits vs survey answers
SELECT DISTINCT name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns, STEM_Resource_Center_study_groups, Exam_Reviews_led_by_BIO_001_TAs, PALS_weekly_study_groups, Exam_Reviews_led_by_PALS
FROM signins, bio1survey
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1survey.name AND bio1survey.Semester = "Fall 2017"
GROUP BY bio1survey.name
ORDER BY numSignIns DESC;

-- Table 2: Spring 2018 Bio 1 STEM Center Signins And Survey Results.csv (this query was used to create this table in the report)
SELECT DISTINCT name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns, STEM_Resource_Center_study_groups, Exam_Reviews_led_by_BIO_001_TAs, PALS_weekly_study_groups, Exam_Reviews_led_by_PALS
FROM signins, bio1survey
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1survey.name AND bio1survey.Semester = "Spring 2018"
GROUP BY bio1survey.name
ORDER BY numSignIns DESC;

-- Table 3: Fall 2017 Bio 1 Survey Activity Sum.csv (this query was used to create this table in the report)
-- Count the amount of students in survey doing each activity
SELECT SUM(STEM_Resource_Center_study_groups), SUM(Exam_Reviews_led_by_BIO_001_TAs), SUM(PALS_weekly_study_groups), SUM(Exam_Reviews_led_by_PALS)
FROM bio1survey
WHERE Semester = "Fall 2017";

-- Table 4: Spring 2018 Bio 1 Survey Activity Sum.csv (this query was used to create this table in the report)
SELECT SUM(STEM_Resource_Center_study_groups), SUM(Exam_Reviews_led_by_BIO_001_TAs), SUM(PALS_weekly_study_groups), SUM(Exam_Reviews_led_by_PALS)
FROM bio1survey
WHERE Semester = "Spring 2018";

-- Table 5: Fall 2017 bio 1 roster students who signed in more than 8 times
-- Provide the list of students who used the STEM Center more than 8 times per semester + indicate specific number of visits for each students
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns > 8
ORDER BY numSignIns DESC;

-- Same thing but using names from survey instead of from roster
/*
SELECT name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1survey
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1survey.name AND bio1survey.Semester = "Fall 2017"
GROUP BY bio1survey.name
HAVING numSignIns > 8
ORDER BY numSignIns DESC;
*/

-- Table 6: Spring 2018 bio 1 roster students who signed in more than 8 times
-- Provide the list of students who used the STEM Center more than 8 times per semester + indicate specific number of visits for each students
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Spring 2018"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns > 8
ORDER BY numSignIns DESC;

-- Table 7: Fall 2017 bio 1 roster students who signed in 5-8 times
-- Provide the list of students who used the STEM Center 5-8 times per semester+ indicate specific number of visits for each students
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns >= 5 AND numSignIns <= 8
ORDER BY numSignIns DESC;

-- Table 8: Spring 2018 bio 1 roster students who signed in 5-8 times
-- Provide the list of students who used the STEM Center 5-8 times per semester+ indicate specific number of visits for each students
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Spring 2018"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns >= 5 AND numSignIns <= 8
ORDER BY numSignIns DESC;


-- Table 9: Fall 2017 bio 1 roster students who signed in 1-4 times
-- Same as above for students with 1-4 visits per semester
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns <= 4
ORDER BY numSignIns DESC;

-- Table 10: Spring 2018 bio 1 roster students who signed in 1-4 times
-- Same as above for students with 1-4 visits per semester
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Spring 2018"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
HAVING numSignIns <= 4
ORDER BY numSignIns DESC;

-- Table 11: Fall 2017 count of ALL bio 1 roster students who signed in
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
ORDER BY numSignIns DESC;

-- Table 12: Spring 2018 count of ALL bio 1 roster students who signed in
SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1roster
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Spring 2018"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
ORDER BY numSignIns DESC;

-- Table 13: Fall 2017 Duplicate names on survey
-- Five students took the survey twice???
SELECT name, COUNT(name) AS numOccurences 
FROM bio1survey
WHERE Semester = "Fall 2017"
GROUP BY name
HAVING numOccurences > 1
ORDER BY numOccurences DESC;
-- 5 students have the same name???

-- Table 14: Spring 2018 Duplicate names on survey
-- Seven students took the survey twice???
SELECT name, COUNT(name) AS numOccurences 
FROM bio1survey
WHERE Semester = "Spring 2018"
GROUP BY name
HAVING numOccurences > 1
ORDER BY numOccurences DESC;
-- 5 students have the same name???

-- Table 15: Fall 2017 Duplicate names on roster
-- Same thing, but looking at duplicat names on roster (not survey)
SELECT (First_Name || " " || Last_Name) AS name, COUNT(First_Name || " " || Last_Name) AS numOccurences 
FROM bio1roster
WHERE Semester = "Fall 2017"
GROUP BY name
HAVING numOccurences > 1
ORDER BY numOccurences DESC;

-- Table 16: Spring 2018 Duplicate names on roster
-- Same thing, but looking at duplicat names on roster (not survey)
SELECT (First_Name || " " || Last_Name) AS name, COUNT(First_Name || " " || Last_Name) AS numOccurences 
FROM bio1roster
WHERE Semester = "Spring 2018"
GROUP BY name
HAVING numOccurences > 1
ORDER BY numOccurences DESC;


-- Table 17: Fall 2017 Histogram count of signins
-- This article was useful in making the histograms: https://www.dotnettricks.com/learn/sqlserver/different-types-of-sql-joins

SELECT numSignIns, COUNT(*)
FROM (
    SELECT bio1roster.First_Name, bio1roster.Last_Name, bio1roster.Semester, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1roster LEFT OUTER JOIN signins ON ( signins.First_Name = bio1roster.First_Name AND  signins.Last_Name = bio1roster.Last_Name AND signins.Semester = bio1roster.Semester )
    WHERE bio1roster.Semester = "Fall 2017"
    GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
    ORDER BY numSignIns DESC
)
GROUP BY numSignIns
ORDER BY numSignIns ASC;

-- Table 18: Spring 2018 Histogram count of signins
-- This article was useful in making the histograms

SELECT numSignIns, COUNT(*)
FROM (
    SELECT bio1roster.First_Name, bio1roster.Last_Name, bio1roster.Semester, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1roster LEFT OUTER JOIN signins ON ( signins.First_Name = bio1roster.First_Name AND  signins.Last_Name = bio1roster.Last_Name AND signins.Semester = bio1roster.Semester )
    WHERE bio1roster.Semester = "Spring 2018"
    GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
    ORDER BY numSignIns DESC
)
GROUP BY numSignIns
ORDER BY numSignIns ASC;

-- Table 19: Fall 2017 STEM Center Study Survey Response Vs Total Signins
SELECT STEM_Resource_Center_study_groups, SUM(numSignIns)
FROM (
    SELECT bio1survey.name, bio1survey.STEM_Resource_Center_study_groups, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1survey LEFT OUTER JOIN signins ON ( signins.First_Name || " " || signins.Last_Name = bio1survey.name AND signins.Semester = bio1survey.Semester )
    WHERE bio1survey.Semester = "Fall 2017"
    GROUP BY bio1survey.name
    ORDER BY bio1survey.STEM_Resource_Center_study_groups ASC, numSignIns ASC
)
GROUP BY STEM_Resource_Center_study_groups;

-- Table 20: Spring 2018 STEM Center Study Survey Response Vs Total Signins
SELECT STEM_Resource_Center_study_groups, SUM(numSignIns)
FROM (
    SELECT bio1survey.name, bio1survey.STEM_Resource_Center_study_groups, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1survey LEFT OUTER JOIN signins ON ( signins.First_Name || " " || signins.Last_Name = bio1survey.name AND signins.Semester = bio1survey.Semester )
    WHERE bio1survey.Semester = "Spring 2018"
    GROUP BY bio1survey.name
    ORDER BY bio1survey.STEM_Resource_Center_study_groups ASC, numSignIns ASC
)
GROUP BY STEM_Resource_Center_study_groups;

-- Table 21: Fall 2017 STEM Center Study Survey Response Vs Average Signins
SELECT STEM_Resource_Center_study_groups, AVG(numSignIns)
FROM (
    SELECT bio1survey.name, bio1survey.STEM_Resource_Center_study_groups, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1survey LEFT OUTER JOIN signins ON ( signins.First_Name || " " || signins.Last_Name = bio1survey.name AND signins.Semester = bio1survey.Semester )
    WHERE bio1survey.Semester = "Fall 2017"
    GROUP BY bio1survey.name
    ORDER BY bio1survey.STEM_Resource_Center_study_groups ASC, numSignIns ASC
)
GROUP BY STEM_Resource_Center_study_groups;


-- Table 22: Spring 2018 STEM Center Study Survey Response Vs Average Signins
SELECT STEM_Resource_Center_study_groups, AVG(numSignIns)
FROM (
    SELECT bio1survey.name, bio1survey.STEM_Resource_Center_study_groups, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM bio1survey LEFT OUTER JOIN signins ON ( signins.First_Name || " " || signins.Last_Name = bio1survey.name AND signins.Semester = bio1survey.Semester )
    WHERE bio1survey.Semester = "Spring 2018"
    GROUP BY bio1survey.name
    ORDER BY bio1survey.STEM_Resource_Center_study_groups ASC, numSignIns ASC
)
GROUP BY STEM_Resource_Center_study_groups;


SELECT bio1roster.First_Name, bio1roster.Last_Name, bio1roster.Semester, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM bio1roster LEFT OUTER JOIN signins ON ( signins.First_Name = bio1roster.First_Name AND  signins.Last_Name = bio1roster.Last_Name AND signins.Semester = bio1roster.Semester )
WHERE bio1roster.Semester = "Fall 2017"
GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
ORDER BY numSignIns DESC;


SELECT bio1survey.name, bio1survey.STEM_Resource_Center_study_groups, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM bio1survey LEFT OUTER JOIN signins ON ( signins.First_Name || " " || signins.Last_Name = bio1survey.name AND signins.Semester = bio1survey.Semester )
WHERE bio1survey.Semester = "Fall 2017"
GROUP BY bio1survey.name
ORDER BY bio1survey.STEM_Resource_Center_study_groups ASC, numSignIns ASC;




/*
SELECT DISTINCT (bio1roster.First_Name || " " || bio1roster.Last_Name) AS name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM bio1roster LEFT OUTER JOIN signins ON ( (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017" )
GROUP BY name
ORDER BY numSignins DESC;
*/
SELECT COUNT(*)
FROM bio1roster LEFT OUTER JOIN signins ON ( (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017" );

SELECT First_Name, Last_Name
FROM bio1roster LEFT OUTER JOIN signins ON ( signins.First_Name = bio1roster.First_Name AND  signins.Last_Name = bio1roster.Last_Name AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017" );


SELECT COUNT(bio1roster.First_Name || " " || bio1roster.Last_Name)
FROM bio1roster
WHERE Semester = "Fall 2017";

SELECT COUNT(*)
FROM signins;

SELECT COUNT(DISTINCT name)
FROM bio1survey
WHERE Semester = "Fall 2017";

SELECT numSignIns, COUNT(*)
FROM (
    SELECT bio1roster.First_Name, bio1roster.Last_Name, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
    FROM signins, bio1roster
    WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Fall 2017"
    GROUP BY (bio1roster.First_Name || " " || bio1roster.Last_Name)
    ORDER BY numSignIns DESC
)
GROUP BY numSignIns
ORDER BY numSignIns ASC;

SELECT *
FROM bio1roster, signins
WHERE (signins.First_Name || " " || signins.Last_Name) = (bio1roster.First_Name || " " || bio1roster.Last_Name) AND signins.Semester = bio1roster.Semester AND bio1roster.Semester = "Spring 2018";

-- ***** Venn Diagram *****
-- TODO: Make a Venn diagam indicating the overlap between the bio 1 roster, the bio1survey survey data, and the stem center signins. This will show how many students are in each group individually, and in both groups. Do this for both bio 1 semesters.



 

-- ***** For both semesters, or STEM Center in general (no particular semester of bio 1) *****


-- Find students who were in both semesters of bio 1:
SELECT *
FROM bio1survey F17, bio1survey S18
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
FROM signins, bio1survey
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1survey.name
GROUP BY bio1survey.name
ORDER BY numSignIns DESC;

-- Find counts of all people who have ever taken bio 1 in the semesters, and actually signed in DURING THE SEMESTER THEY TOOK bio1survey
SELECT DISTINCT name, bio1survey.Semester, COUNT(DISTINCT signins.Transaction_Date_Time) AS numSignIns
FROM signins, bio1survey
WHERE (signins.First_Name || " " || signins.Last_Name) = bio1survey.name AND signins.Semester = bio1survey.Semester
GROUP BY bio1survey.name
ORDER BY bio1survey.Semester, numSignIns DESC;


SELECT COUNT(*)
FROM bio1survey
WHERE STEM_Resource_Center_study_groups = 1;

SELECT COUNT(DISTINCT name)
FROM bio1survey;


-- TODO: Find all bio 1 students who signed in during the semester they took bio 1, but did not say they participated in the STEM Resource center study groups learning assistant led activities
SELECT bio1survey.name, COUNT(signins.Transaction_ID) AS numSignIns, signins.Semester
FROM bio1survey, signins
WHERE bio1survey.name = signins.First_Name || " " || signins.Last_Name AND bio1survey.STEM_Resource_Center_study_groups = 0 AND signins.Semester = bio1survey.Semester
GROUP BY bio1survey.name
ORDER BY signins.Semester, numSignIns DESC, bio1survey.name;


-- TODO: Find all bio 1 students who said they used the STEM resource center study groups, but did not sign in
SELECT bio1survey.name, bio1survey.Semester
FROM bio1survey
WHERE bio1survey.STEM_Resource_Center_study_groups = 1 AND bio1survey.name NOT IN (
    SELECT (signins.First_Name || " " || signins.Last_Name) AS name
    FROM signins
)
GROUP BY bio1survey.name
ORDER BY bio1survey.Semester, bio1survey.name;


/*
-- An example of a student who said he participated in STEM resource center study groups, but did not sign in
SELECT *
FROM signins
WHERE (signins.First_Name || " " || signins.Last_Name) = "Bryan Lopez Herrera";
SELECT *
FROM bio1survey
WHERE name = "Bryan Lopez Herrera";
*/

-- Find all bio 1 students who both said they used the STEM resource center study groups and signed in DURING THE SEMESTER THEY TOOK BIO 1
SELECT bio1survey.name, COUNT(signins.Transaction_ID) AS numSignIns, signins.Semester
FROM bio1survey, signins
WHERE bio1survey.name = signins.First_Name || " " || signins.Last_Name AND bio1survey.STEM_Resource_Center_study_groups = 1 AND signins.Semester = bio1survey.Semester
GROUP BY bio1survey.name
ORDER BY signins.Semester, numSignIns DESC, bio1survey.name;

-- Find all students who are on the roster, but did not take the survey
SELECT *
FROM bio1roster
WHERE Semester = "Fall 2017" AND (bio1roster.First_Name || " " || bio1roster.Last_Name) NOT IN (
    SELECT name
    FROM bio1survey
    WHERE Semester = "Fall 2017"
)
ORDER BY Semester, Last_Name, First_Name;






-- TODO: Finish report and email to Petia. After Petia reviews it and you make the corrections, schedule an in-person meeting with Petia. Then email it to Beaster-Jones.



