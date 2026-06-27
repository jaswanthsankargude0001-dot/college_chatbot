function sendMessage() {

    let input = document.getElementById("userInput");
    let msg = input.value.trim();

    if (!msg) return;

    let chatBox = document.getElementById("chatBox");

    // User message
    chatBox.innerHTML += `
        <div class="user-msg">${msg}</div>
    `;

    fetch("/chat", {
        method: "POST",

        headers: {
            "Content-Type": "application/json"
        },

        body: JSON.stringify({
            message: msg
        })
    })

    .then(r => r.json())

    .then(d => {

        chatBox.innerHTML += `
            <div class="bot-msg">${d.response}</div>
        `;

        chatBox.scrollTop = chatBox.scrollHeight;
    });

    input.value = "";
}


// OPEN / CLOSE CHAT
function openChat() {

    let chat = document.getElementById("chatContainer");
    let nav = document.querySelector("nav");

    if(chat.style.display === "flex"){

        chat.style.display = "none";

    }else{

        chat.style.display = "flex";

        let navHeight = nav.offsetHeight;

        chat.style.top = (navHeight + 10) + "px";
    }
}

// ENTER KEY
document.getElementById("userInput")
.addEventListener("keypress", e => {

    if(e.key === "Enter"){

        e.preventDefault();
        sendMessage();
    }
});

function maximizeChat(){

    let chat = document.getElementById("chatContainer");

    if(chat.classList.contains("full-screen")){

        chat.classList.remove("full-screen");

        // Clear inline styles
        chat.style.top = "";
        chat.style.left = "";
        chat.style.right = "";
        chat.style.bottom = "";
        chat.style.width = "";
        chat.style.height = "";
        chat.style.transform = "";

    }else{

        chat.classList.add("full-screen");
    }
}
// FAQ TOGGLE
document.querySelectorAll(".faq-question").forEach(btn => {

    btn.onclick = () => {

        let ans = btn.nextElementSibling;

        ans.style.display =
        ans.style.display === "block"
        ? "none"
        : "block";
    };
});

// SIDEBAR

function openSidebar(){

    document
    .getElementById("sidebar")
    .classList.add("active");

    document
    .getElementById("sidebarOverlay")
    .classList.add("active");
}

function closeSidebar(){

    document
    .getElementById("sidebar")
    .classList.remove("active");

    document
    .getElementById("sidebarOverlay")
    .classList.remove("active");
}
function loadHistory(){

    fetch("/history")

    .then(response => response.json())

    .then(data => {

        let historyContainer =
        document.getElementById("historyContainer");

        historyContainer.innerHTML = "";

        data.forEach(item => {

            historyContainer.innerHTML += `

            <div style="
                background:#1e293b;
                color:white;
                padding:10px;
                margin:10px;
                border-radius:10px;
            ">

                <b>You:</b>
                ${item.user_message}

                <br><br>

                <b>Bot:</b>
                ${item.bot_response}

            </div>
            `;
        });
    });
}