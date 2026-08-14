from flask import Flask, jsonify
import os

app = Flask(__name__)


@app.route("/health")
def health():
    return jsonify(status="healthy"), 200


@app.route("/")
def index():
    return jsonify(
        message="Secure Deploy App running on AKS",
        environment=os.environ.get("ENVIRONMENT", "unknown"),
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
