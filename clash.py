from flask import Flask, request, render_template
import os, subprocess, base64, json, getclashfun as cl

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    # 显示一个简单的表单，让用户输入一些数据
    return render_template('clash.html')

@app.route('/', methods=['POST'])
def process_form():
    passwd = request.form['c']
    if passwd != 'wwl':
        return json.dumps({'code':1, 'mes':'恭喜你获得奖励！'})
    email = cl.generate_random_email()
    password = cl.generate_random_password()
    ip = cl.generate_random_ip()
    
    cl.register(email, password, ip)
    time = cl.getEXPTime()
    authorization = cl.login(email, password)
    if authorization:
        url = cl.getSubscribe(authorization)
        print("订阅地址yaml文件：", url)
        return json.dumps({'code':1, 'url': url, 'time': str(time), 'authorization': authorization, 'mes': '获取成功！', 'email': email, 'password': password, 'ip': ip})
    else:
        return json.dumps({'code':2, 'mes':'出现错误，请稍后再试！'})

if __name__ == '__main__':
    app.run(debug=True)
