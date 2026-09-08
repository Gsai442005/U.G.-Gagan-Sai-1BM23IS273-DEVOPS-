FROM python:3.9-slim
WORKDIR /app
COPY app.py .
RUN pip install flask==2.2.5 werkzeug==2.2.3
EXPOSE 5000
CMD ["python", "app.py"]
