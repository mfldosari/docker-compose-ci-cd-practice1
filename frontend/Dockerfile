# Use official Python base image
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements if you have one (recommended)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all app files into the container
COPY . .

# Expose the default Streamlit port
EXPOSE 8501


# Command to run the app
CMD ["streamlit", "run", "chatbot.py"]
