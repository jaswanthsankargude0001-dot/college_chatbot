from flask import Flask, render_template, request, jsonify, redirect, session
import mysql.connector


def detect_intent(user_message):
    message = user_message.lower()

    if "fee" in message or "fees" in message:
        return "fees"

    elif "admission" in message:
        return "admission"

    elif "placement" in message:
        return "placement"

    else:
        return "unknown"

app = Flask(__name__)
app.secret_key = "secret123"

ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin123"

# DATABASE
db = mysql.connector.connect(
    host="127.0.0.1",
    user="chatbot",
    password="chatbot123",
    database="college_chatbot"
)

cursor = db.cursor(dictionary=True)

# HOME PAGE
@app.route('/')
def home():

    cursor.execute("SELECT * FROM faq")
    faqs = cursor.fetchall()

    return render_template("index.html", faqs=faqs)

# CHATBOT
@app.route('/chat', methods=['POST'])
def chat():

    from chatbot import get_bot_response

    data = request.get_json()

    msg = data.get("message", "")

    response = get_bot_response(msg)

    return jsonify({"response": response})



@app.route('/history-page')
def history_page():

    db = mysql.connector.connect(
        host="127.0.0.1",
        user="chatbot",
        password="chatbot123",
        database="college_chatbot"
    )

    cursor = db.cursor(dictionary=True)

    cursor.execute("""
    SELECT user_message,
           bot_response,
           created_at
    FROM student_queries
    ORDER BY id DESC
""")

    history = cursor.fetchall()

    db.close()

    return render_template(
        "history.html",
        history=history
    )
@app.route('/clear-history', methods=['POST'])
def clear_history():

    db = mysql.connector.connect(
        host="127.0.0.1",
        user="chatbot",
        password="chatbot123",
        database="college_chatbot"
    )

    cursor = db.cursor()

    cursor.execute("DELETE FROM student_queries")

    db.commit()
    db.close()

    return redirect('/history-page')
# ADMIN LOGIN
@app.route('/admin-login', methods=['GET', 'POST'])
def admin_login():

    if request.method == 'POST':

        username = request.form['username']
        password = request.form['password']

        if username == ADMIN_USERNAME and password == ADMIN_PASSWORD:

            session['admin'] = True

            return redirect('/admin')

    return render_template('admin_login.html')

# ADMIN PANEL
@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if not session.get('admin'):
        return redirect('/admin-login')

    if request.method == 'POST':

        q = request.form.get('question')
        a = request.form.get('answer')

        if q and a:

            cursor.execute(
                "INSERT INTO faq(question,answer) VALUES(%s,%s)",
                (q, a)
            )

            db.commit()

            return '''

<h2 style="text-align:center;
margin-top:100px;
color:green;
font-family:Arial;">

FAQ Added Successfully ✅

</h2>

<script>

setTimeout(function(){

window.location.href="/admin";

},2000)

</script>

'''

    cursor.execute("SELECT * FROM faq")
    faqs = cursor.fetchall()

    return render_template("admin.html", faqs=faqs)

@app.route('/delete-faq/<int:id>')
def delete_faq(id):

    if not session.get('admin'):
        return redirect('/admin-login')

    cursor.execute(
        "DELETE FROM faq WHERE id=%s",
        (id,)
    )

    db.commit()

    return redirect('/admin')

@app.route('/edit-faq/<int:id>', methods=['GET', 'POST'])
def edit_faq(id):

    if not session.get('admin'):
        return redirect('/admin-login')

    if request.method == 'POST':

        question = request.form['question']
        answer = request.form['answer']

        cursor.execute(
            "UPDATE faq SET question=%s, answer=%s WHERE id=%s",
            (question, answer, id)
        )

        db.commit()

        return redirect('/admin')

    cursor.execute(
        "SELECT * FROM faq WHERE id=%s",
        (id,)
    )

    faq = cursor.fetchone()

    return render_template(
        "edit_faq.html",
        faq=faq
    )

@app.route('/logout')
def logout():

    session.pop('admin', None)

    return redirect('/admin-login')

# RUN
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
   
   
   
