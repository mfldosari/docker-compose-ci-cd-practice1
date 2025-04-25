import base64
import os
import uuid
from fastapi import FastAPI, File, UploadFile, HTTPException, Query
from openai import OpenAI
from azure.storage.blob import BlobClient
from dotenv import load_dotenv

load_dotenv()

# Config
OPENAI_API_KEY         = os.getenv("OPENAI_API_KEY")
AZURE_STORAGE_SAS_URL  = os.getenv("AZURE_STORAGE_SAS_URL")       # e.g. https://<acct>.blob.core.windows.net?<sas>
AZURE_STORAGE_CONTAINER= os.getenv("AZURE_STORAGE_CONTAINER")     # e.g. "my-container"

# Parse once at startup
_storage_account_url, _sas_token = AZURE_STORAGE_SAS_URL.split("?", 1)
_blob_base_url = f"{_storage_account_url}/{AZURE_STORAGE_CONTAINER}"

# OpenAI client
client = OpenAI(api_key=OPENAI_API_KEY)

app = FastAPI()


@app.post("/upload_image/")
async def upload_image(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Only image files allowed.")

    # generate unique blob name
    ext       = os.path.splitext(file.filename)[1]
    image_uuid= str(uuid.uuid4())
    blob_name = f"{image_uuid}{ext}"

    # stream-upload directly to Azure blob
    blob_url = f"{_blob_base_url}/{blob_name}?{_sas_token}"
    blob     = BlobClient.from_blob_url(blob_url)
    contents = await file.read()
    blob.upload_blob(contents, overwrite=True)

    # return the URL (with SAS) so frontend can render it directly
    return {
        "image_uuid":  image_uuid,
        "image_name":  file.filename,
        "image_url":   blob_url
    }


@app.post("/image_recognition/")
async def image_recognition(
    question:  str  = Query(..., description="Your question about the image"),
    image_url: str  = Query(..., description="Full URL (with SAS) to the blob")
):
    # ask GPT-4o with an image_url instead of embedding the bytes
    try:
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": f"{question}\n\nRespond briefly and concisely."},
                        {"type": "image_url", "image_url": {"url": image_url}}
                    ]
                }
            ]
        )
        answer = response.choices[0].message.content.strip()
        return {"answer": answer}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image QA error: {e}")
