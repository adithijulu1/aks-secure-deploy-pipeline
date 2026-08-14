FROM python:3.12-slim

WORKDIR /app

COPY app/ .

RUN pip install --no-cache-dir flask==3.0.3

EXPOSE 8080

USER 1000

CMD ["python", "server.py"]
