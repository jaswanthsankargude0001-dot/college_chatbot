import spacy
import nltk
from nltk.corpus import stopwords
import mysql.connector
nlp = spacy.load("en_core_web_sm")

nltk.download("stopwords")

stop_words = set(stopwords.words("english"))

def preprocess(text):

    doc = nlp(text.lower())

    words = []

    for token in doc:

        if token.text not in stop_words and not token.is_punct:
            words.append(token.lemma_)

    return " ".join(words)

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

    user_doc = nlp(preprocess(msg))

    best_answer = None
    best_score = 0

    for faq in faqs:

        question = str(faq[0]).lower().replace("_", " ").strip()
        answer = str(faq[1]).strip()

        if answer == "":
            continue

        faq_doc = nlp(preprocess(question))

        score = len(
    set(preprocess(msg).split())
    &
    set(preprocess(question).split())
)
        if question in msg:
            score += 0.5

        if score > best_score:
            best_score = score
            best_answer = answer

    if best_score >= 1:

        cursor.execute(
            "INSERT INTO student_queries(user_message, bot_response) VALUES(%s,%s)",
            (message, best_answer)
        )

        db.commit()
        db.close()

        return best_answer

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