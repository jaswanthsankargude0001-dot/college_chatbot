import mysql.connector

def get_bot_response(message):

    db = mysql.connector.connect(
        host="127.0.0.1",
        user="chatbot",
        password="chatbot123",
        database="college_chatbot"
    )

    cursor = db.cursor()

    msg = message.lower().replace("_", " ").strip()

    # ======================
    # COURSES TABLE
    # ======================

    cursor.execute("""
        SELECT course_name, specialization, fees, duration, seats
        FROM courses
    """)

    courses = cursor.fetchall()

    for course in courses:

        course_name = str(course[0]).lower().strip()
        specialization = str(course[1]).lower().strip()

        if course_name in msg or specialization in msg:

            response = f"""
Course: {course[0]}
Specialization: {course[1]}
Duration: {course[3]}
Fees: {course[2]}
Seats: {course[4]}
"""

            cursor.execute(
                "INSERT INTO student_queries(user_message, bot_response) VALUES(%s,%s)",
                (message, response)
            )

            db.commit()
            db.close()

            return response

    # ======================
    # FAQ TABLE
    # ======================

    cursor.execute("SELECT question, answer FROM faq")

    faqs = cursor.fetchall()

    for faq in faqs:

        question = str(faq[0]).lower().replace("_", " ").strip()
        answer = str(faq[1]).strip()

        if answer == "":
            continue

        msg_words = msg.split()
        question_words = question.split()

        if any(word in question_words for word in msg_words):

            cursor.execute(
                "INSERT INTO student_queries(user_message, bot_response) VALUES(%s,%s)",
                (message, answer)
            )

            db.commit()
            db.close()

            return answer

    # ======================
    # UNKNOWN QUESTIONS
    # ======================

    response = "Please contact admin for more details."

    cursor.execute(
        "INSERT INTO student_queries(user_message, bot_response) VALUES(%s,%s)",
        (message, response)
    )

    db.commit()
    db.close()

    return response