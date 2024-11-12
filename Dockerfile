# FROM python:3.12

# # Set the working directory
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Install any needed packages specified in requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt

# # Make port 80 available to the world outside this container
# EXPOSE 8000

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /code

# Copy the requirements file and install dependencies
COPY requirements.txt .

# Install system dependencies required for PostgreSQL, etc.
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the Django app into the container
COPY . .

# Expose the port that Gunicorn will run on
EXPOSE 8000

# Collect static files (needed for production)
RUN python manage.py collectstatic --noinput

# Define the default command to run the application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django_project.wsgi:application"]
