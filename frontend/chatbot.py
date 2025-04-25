from datetime import datetime
import streamlit as st
import requests
from PIL import Image

# ------------------------------
# Backend endpoints
# ------------------------------
UPLOAD_IMAGE_URL      = "http://127.0.0.1:5000/upload_image/"
IMAGE_RECOGNITION_URL = "http://127.0.0.1:5000/image_recognition/"

# ------------------------------
# Avatar helper
# ------------------------------
def avatar_updater(role):
    """
    Return the appropriate avatar image path.
    """
    if role == "assistant":
        return "Image_gallery/bot.png"
    else:
        return "Image_gallery/user.png"

# ------------------------------
# Session state
# ------------------------------
if "image_url" not in st.session_state:
    st.session_state["image_url"]  = None
    st.session_state["image_name"] = None
    st.session_state["messages"]   = []

# ------------------------------
# Inject CSS for fixed layout and hide preview
# ------------------------------

# ------------------------------
# Sidebar: upload & reset
# ------------------------------
with st.sidebar:
    st.title("🖼️ Image Chat")

    img = st.file_uploader("Upload image", type=["png", "jpg", "jpeg", "webp"])
    if img:
        with st.spinner("Uploading…"):
            files = {"file": (img.name, img.getvalue(), img.type)}
            r = requests.post(UPLOAD_IMAGE_URL, files=files)
        if r.status_code == 200:
            data = r.json()
            st.session_state["image_url"]  = data["image_url"]
            st.session_state["image_name"] = data["image_name"]
            st.session_state["messages"].clear()
            st.success("Image uploaded!")
        else:
            st.error("Upload failed.")

    if st.button("🔄 Reset Chat"):
        st.session_state["image_url"]  = None
        st.session_state["image_name"] = None
        st.session_state["messages"].clear()

# ------------------------------
# Main UI: Image & Chat
# ------------------------------
st.header("🖼️ Image Chatbot")

if st.session_state["image_url"]:
    # display image
    st.image(
        st.session_state["image_url"],
        use_container_width=True
    )

    # chat history in its own scrollable div
    st.markdown("<div class='chat-container'>", unsafe_allow_html=True)
    for msg in st.session_state["messages"]:
        avatar_path = avatar_updater(msg["role"])
        avatar_img  = Image.open(avatar_path)
        with st.chat_message(msg["role"], avatar=avatar_img):
            st.caption(msg["time"])
            st.markdown(msg["content"])
    st.markdown("</div>", unsafe_allow_html=True)

    # fixed chat input at bottom
    prompt = st.chat_input("💬 Your Message:")
    if prompt:
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        st.session_state["messages"].append({
            "role":    "user",
            "content": prompt,
            "time":    now
        })
        # echo user message immediately
        with st.chat_message("user", avatar=Image.open(avatar_updater("user"))):
            st.caption(now)
            st.markdown(prompt)

        # call backend
        params = {
            "question":  prompt,
            "image_url": st.session_state["image_url"]
        }
        r = requests.post(IMAGE_RECOGNITION_URL, params=params)
        answer = r.json().get("answer", "No result") if r.status_code == 200 else "Error!"

        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        st.session_state["messages"].append({
            "role":    "assistant",
            "content": answer,
            "time":    now
        })
        with st.chat_message("assistant", avatar=Image.open(avatar_updater("assistant"))):
            st.caption(now)
            st.markdown(answer)

else:
    st.info("Upload an image to start chatting.")
