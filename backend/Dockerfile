# Use a lightweight Python image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install system dependencies for pip packages
RUN apt-get update && apt-get install -y 

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose FastAPI default port
EXPOSE 5000

# Run the FastAPI app using uvicorn
CMD ["uvicorn", "your_script_name:app", "--host", "0.0.0.0", "--port", "5000"]
