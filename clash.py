from flask import Flask, request, render_template
import os, subprocess, base64, json, getclash as cl

app = Flask(__name__)

@app.route('/')
def process_form():
    email = cl.generate_random_email()
    password = cl.generate_random_password()
    ip = cl.generate_random_ip()
    
    cl.register(email, password, ip)
    time = cl.getEXPTime()
    authorization = cl.login(email, password)
    if authorization:
        url = cl.getSubscribe(authorization)
        print("订阅地址yaml文件：", url)
        return json.dumps({code:1, 'url': url, 'time': time, 'authorization': authorization})
    else:
        return json.dumps({code:2, msg:'出现错误，请稍后再试！'})

if __name__ == '__main__':
    app.run(debug=True)
