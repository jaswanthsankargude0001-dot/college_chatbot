import mysql.connector

def get_bot_response(message):

    db = mysql.connector.connect(
        host="localhost",
        user="root",
        password="MySQL@2026",
        database="college_chatbot"
    )

    cursor = db.cursor()

    msg = message.lower()

    # FAQ table check
    cursor.execute("SELECT question, answer FROM faq")
    faqs = cursor.fetchall()

    for faq in faqs:
        question = faq[0].lower()

        if question in msg:
            db.close()
            return faq[1]

    # Courses table check
    cursor.execute("SELECT course_name, specialization, fees, duration, seats FROM courses")
    courses = cursor.fetchall()

    for course in courses:

        course_name = course[0].lower()
        specialization = course[1].lower()

        if course_name in msg or specialization in msg:

            response = f"""
Course: {course[0]}
Specialization: {course[1]}
Duration: {course[3]}
Fees: {course[2]}
Seats: {course[4]}
"""

            db.close()
            return response

    db.close()

    return "Please contact admin for more details."

/*

    CREATE DATABASE college_chatbot;

USE college_chatbot;

-- Courses table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    specialization VARCHAR(100),
    duration VARCHAR(50),
    fees VARCHAR(50),
    seats INT
);

-- FAQ table
CREATE TABLE faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255),
    answer TEXT
);

-- Student queries table
CREATE TABLE student_queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_message TEXT,
    bot_response TEXT
);

INSERT INTO courses(course_name, specialization, duration, fees, seats) VALUES
('B.Tech', 'CSE', '4 Years', '120000/year', 480),
('B.Tech', 'ECE', '4 Years', '110000/year', 240),
('B.Tech', 'AI & DS', '4 Years', '130000/year', 180),
('BCA', 'Computer Applications', '3 Years', '70000/year', 200),
('BBA', 'Business Administration', '3 Years', '65000/year', 150),
('MBA', 'Marketing & Finance', '2 Years', '150000/year', 120);

INSERT INTO faq(question, answer) VALUES
('fees', 'B.Tech fee is 1.2 lakh per year. BCA fee is 70k per year.'),
('hostel', 'Hostel facilities available for boys and girls.'),
('admission', 'Admissions are open for 2026 batch.'),
('placements', '95% placement record with top companies.'),
('contact', 'Call us at 9876543210');

SELECT * FROM courses;
SELECT * FROM faq;

USE college_db;
SHOW TABLES;

show tables;
SELECT * FROM courses;
SELECT * FROM faq;
SELECT * FROM student_queries;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;



CREATE DATABASE college_chatbot;

USE college_chatbot;

-- Courses table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    specialization VARCHAR(100),
    duration VARCHAR(50),
    fees VARCHAR(50),
    seats INT
);

-- FAQ table
CREATE TABLE faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255),
    answer TEXT
);

-- Student queries table
CREATE TABLE student_queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_message TEXT,
    bot_response TEXT
);

INSERT INTO courses(course_name, specialization, duration, fees, seats) VALUES
('B.Tech', 'CSE', '4 Years', '120000/year', 480),
('B.Tech', 'ECE', '4 Years', '110000/year', 240),
('B.Tech', 'AI & DS', '4 Years', '130000/year', 180),
('BCA', 'Computer Applications', '3 Years', '70000/year', 200),
('BBA', 'Business Administration', '3 Years', '65000/year', 150),
('MBA', 'Marketing & Finance', '2 Years', '150000/year', 120);

INSERT INTO faq(question, answer) VALUES
('fees', 'B.Tech fee is 1.2 lakh per year. BCA fee is 70k per year.'),
('hostel', 'Hostel facilities available for boys and girls.'),
('admission', 'Admissions are open for 2026 batch.'),
('placements', '95% placement record with top companies.'),
('contact', 'Call us at 9876543210'),
('college_name', 'The name of the college is XYZ Engineering College.'),
('location', 'The college is located in a peaceful environment outside the city.'),
('established', 'The college was established in 2005.'),
('affiliation', 'The college is affiliated with JNTU.'),
('courses_offered', 'The college offers B.Tech, M.Tech, MBA, and diploma courses.'),
('btech_branches', 'The branches include CSE, ECE, EEE, Mechanical, and Civil Engineering.'),
('aicte', 'The college is approved by AICTE.'),
('online_fee_payment', 'Online fee payment options are available.'),
('scholarships', 'Scholarships are available for eligible students.'),
('education_loan', 'Education loan assistance is available.'),
('cafeteria', 'Hygienic food is available in the college cafeteria.'),
('library', 'The college has a central library with digital resources.'),
('sports', 'Indoor and outdoor sports facilities are available.'),
('wifi', 'Wi-Fi facility is available across the campus.'),
('transport', 'Bus transport facilities are available from nearby towns.'),
('placement_training', 'Placement training starts from second year.'),
('coding_classes', 'Coding and programming classes are conducted regularly.'),
('aptitude_training', 'Aptitude and reasoning training are provided.'),
('mock_interviews', 'Mock interviews and group discussions are conducted.'),
('internships', 'Internship opportunities are provided through industry collaborations.'),
('highest_package', 'Highest package varies every year based on recruitment.'),
('resume_guidance', 'Resume building guidance is provided for students.'),
('cultural_events', 'Annual cultural programs are conducted regularly.'),
('technical_workshops', 'Technical workshops are organized frequently.'),
('hackathons', 'Coding competitions and hackathons are conducted.'),
('student_clubs', 'Students can participate in different clubs and activities.'),
('chatbot_working', 'The chatbot processes user queries using database and keyword matching.'),
('mobile_support', 'The chatbot works on both mobile phones and laptops.'),
('voice_support', 'Future versions can support voice interaction.');

SELECT * FROM courses;
SELECT * FROM faq;

USE college_chatbot;
SHOW TABLES;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;

SHOW DATABASES;

USE college_chatbot;

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    specialization VARCHAR(100),
    duration VARCHAR(50),
    fees VARCHAR(50),
    seats INT
);

CREATE TABLE faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255),
    answer TEXT
);

CREATE TABLE student_queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_message TEXT,
    bot_response TEXT
);

INSERT INTO faq(question, answer)
VALUES
('fees', 'B.Tech fee is 1.2 lakh/year'),
('hostel', 'Hostel available for boys and girls'),
('admission', 'Admissions are open'),
('contact', 'Call us at 9876543210');


SELECT * FROM faq WHERE question='mca';
DELETE FROM faq WHERE question='mca';
DELETE FROM faq WHERE question LIKE '%mca%';
COMMIT;
SELECT id, question, answer FROM faq;
DELETE FROM faq WHERE id=27;
SELECT * FROM faq WHERE id=27;

TRUNCATE TABLE faq;

SELECT * FROM faq;






















USE college_chatbot;

TRUNCATE TABLE courses;
TRUNCATE TABLE faq;
TRUNCATE TABLE student_queries;

-- COURSES TABLE DATA
INSERT INTO courses(course_name, specialization, duration, fees, seats) VALUES
('B.Tech', 'CSE', '4 Years', '120000/year', 480),
('B.Tech', 'ECE', '4 Years', '110000/year', 240),
('B.Tech', 'AI & DS', '4 Years', '130000/year', 180),
('BCA', 'Computer Applications', '3 Years', '70000/year', 200),
('BBA', 'Business Administration', '3 Years', '65000/year', 150),
('MBA', 'Marketing & Finance', '2 Years', '150000/year', 120),
('MSC', 'Computer Science', '2 Years', '150000/year', 120),
('jjj', 'Computer Applications', '2 Years', '90000/year', 100),
('MCA', 'Computer Applications', '2 Years', '90000/year', 100);

DELETE FROM courses
WHERE id=200;

DELETE FROM courses
WHERE question='jjj';
SET SQL_SAFE_UPDATES = 0;

DELETE FROM courses
WHERE course_name='jjj';

COMMIT;

-- FAQ TABLE DATA
INSERT INTO faq(question, answer) VALUES
('hostel', 'Hostel facilities are available for boys and girls.'),
('admission', 'Admissions are open for 2026 batch.'),
('placements', '95% placement record with top companies.'),
('contact', 'Call us at 9876543210.'),
('college_name', 'The name of the college is XYZ Engineering College.'),
('location', 'The college is located outside the city in a peaceful environment.'),
('library', 'The college has a central library with digital resources.'),
('sports', 'Indoor and outdoor sports facilities are available.'),
('wifi', 'Wi-Fi facility is available across the campus.'),
('transport', 'Bus transport facilities are available from nearby towns.'),
('scholarships', 'Scholarships are available for eligible students.'),
('cafeteria', 'Hygienic food is available in the college cafeteria.'),
('coding_classes', 'Coding and programming classes are conducted regularly.'),
('mock_interviews', 'Mock interviews and group discussions are conducted.'),
('internships', 'Internship opportunities are provided for students.');

SELECT * FROM courses;
SELECT * FROM faq;
SELECT * FROM student_queries;
*/



/* 

TRUNCATE TABLE faq;
show databases;

USE college_chatbot;
SELECT * FROM faq;
TRUNCATE TABLE courses;
TRUNCATE TABLE faq;
TRUNCATE TABLE student_queries;

-- COURSES TABLE DATA
INSERT INTO courses(course_name, specialization, duration, fees, seats) VALUES
('B.Tech', 'CSE', '4 Years', '120000/year', 480),
('B.Tech', 'ECE', '4 Years', '110000/year', 240),
('B.Tech', 'AI & DS', '4 Years', '130000/year', 180),
('BCA', 'Computer Applications', '3 Years', '70000/year', 200),
('BBA', 'Business Administration', '3 Years', '65000/year', 150),
('MBA', 'Marketing & Finance', '2 Years', '150000/year', 120),
('MSC', 'Computer Science', '2 Years', '150000/year', 120),
('MCA', 'Computer Applications', '2 Years', '90000/year', 100);

DELETE FROM courses
WHERE id=20;

DELETE FROM courses
WHERE question='jjj';
SET SQL_SAFE_UPDATES = 0;

DELETE FROM courses
WHERE course_name='jjj';

COMMIT;

-- FAQ TABLE DATA
INSERT INTO faq(question, answer) VALUES
('hostel', 'Hostel facilities are not available.'),
('admission', 'Admissions are open for 2026 batch.'),
('placements', '78% placement record with top companies.'),
('contact', 'Call us at 8074342346.'),
('college_name', 'The name of the college is XYZ Engineering College.'),
('location', 'The college is located outside the city in a peaceful environment.'),
('library', 'The college has a central library with digital resources.'),
('sports', 'Indoor and outdoor sports facilities are available.'),
('wifi', 'Wi-Fi facility is available across the campus.'),
('transport', 'Bus transport facilities are not available.'),
('scholarships', 'Scholarships are not available for eligible students.'),
('cafeteria', 'Hygienic food is available in the college cafeteria.'),
('coding_classes', 'Coding and programming classes are conducted regularly.'),
('mock_interviews', 'Mock interviews and group discussions are conducted.'),
('internships', 'Internship opportunities are provided for students.');

SELECT * FROM courses;
SELECT * FROM faq;
SELECT * FROM student_queries;

DESCRIBE student_queries;

ALTER TABLE student_queries
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

SELECT * FROM faq
WHERE question='hostel';

SELECT * FROM faq
WHERE question='admission';

SELECT * FROM faq
WHERE question='placements';

SELECT question, COUNT(*) AS total
FROM faq
GROUP BY question
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM faq;
SELECT COUNT(DISTINCT question) FROM faq;

CREATE TABLE faq_backup AS
SELECT * FROM faq;

SET SQL_SAFE_UPDATES = 0;

DELETE f1
FROM faq f1
INNER JOIN faq f2
ON f1.question = f2.question
AND f1.id > f2.id;

SELECT question, COUNT(*) AS total
FROM faq
GROUP BY question
HAVING COUNT(*) > 1;

ALTER TABLE faq
ADD UNIQUE(question);

*/