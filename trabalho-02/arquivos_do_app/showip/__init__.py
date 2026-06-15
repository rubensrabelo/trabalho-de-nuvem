import socket
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    hostname = socket.gethostname()
    ip_interno = socket.gethostbyname(hostname)
    return f"Conteiner Ativo! IP Interno: {ip_interno}\n"
