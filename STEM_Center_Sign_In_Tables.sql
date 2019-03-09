-- 2/17/2019
-- David Lohmann
-- This is a schema for a database to store all tutoring data

CREATE TABLE IF NOT EXISTS signins (
    Transaction_ID INTEGER PRIMARY KEY NOT NULL,
    Passed_Denied BOOLEAN,
    First_Name TEXT,	
    Last_Name TEXT,
    Email TEXT,
    CatCard_ID INTEGER,
    Active INTEGER,
    Affiliation TEXT,
    Class TEXT,
    Department TEXT,
    Transaction_Date_Time TEXT,
    Error_Info TEXT,
    Comment_Note TEXT,
    Semester TEXT
);

/*
INSERT INTO signins
(
    Transaction_ID,
    Passed_Denied,
    First_Name,	
    Last_Name,
    Email,
    CatCard_ID,
    Active,
    Affiliation,
    Class,
    Transaction_Date_Time,
    Semester
) VALUES (
    273961,
    1,
    "Marcos",
    "Lucero",
    "mlucero@ucmerced.edu",
    100178687,
    1,
    "student",
    "senior",
    "2016-10-28 14:59:02",
    "Fall 2016"
);
*/

/*
INSERT INTO signins (Transaction_ID,Passed_Denied,First_Name,	
    Last_Name,
    Email,
    CatCard_ID,
    Active,
    Affiliation,
    Class,
    Transaction_Date_Time,
    Semester
) VALUES (273961,1,"Marcos","Lucero","mlucero@ucmerced.edu",100178687,1,"student","senior","2016-10-28 14:59:02", "Fall 2016");
*/

-- SELECT *
--FROM signins;

-- SELECT *
-- FROM signins
-- WHERE First_Name="Marcos";

-- DELETE FROM signins;

-- DROP TABLE signins;