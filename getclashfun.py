import requests
import json
import random
import string
from datetime import datetime, timedelta

newhost = requests.get('https://x-zy.shop').url

registerUrl = f'{newhost}/api/v1/passport/auth/register'
loginUrl = f'{newhost}/api/v1/passport/auth/login'
subscribeUrl = f'{newhost}/api/v1/user/getSubscribe'


def getEXPTime():
    # 获取当前时间
    exp_time = datetime.now() + timedelta(hours=24)
    print("订阅过期时间:", exp_time)
    return exp_time


def generate_random_email():
    # 生成随机字符串
    letters = string.ascii_letters + string.digits
    random_string = ''.join(random.choice(letters) for _ in range(12))
    email = random_string + "@gmail.com"
    return email

def generate_random_password():
    # 生成随机字符
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(characters) for _ in range(12))
    return password

def generate_random_ip():
    ip = '.'.join(str(random.randint(1, 254)) for _ in range(4))
    return ip

def register(email, password, proxyIP):
    registerHeaders = {
        'User-Agent': 'Mozilla/5.0',
        'Content-Language': 'zh-CN',
        'X-Forwarded-For': '{}'.format(proxyIP)
    }
    registerData = {'email': email, 'password': password}
    registerResponse = requests.post(registerUrl, headers=registerHeaders, data=registerData)
    # print("注册响应：", registerResponse.text)


def login(email, password):
    data = {'email': email, 'password': password}
    loginResponse = requests.post(loginUrl, data=data)
    if loginResponse.status_code == 200:
        print("登录成功！")
        return json.loads(loginResponse.text).get("data").get("auth_data")
    else:
        print("登录失败！")
        return False


def getSubscribe(authorization):
    subscribeHeaders = {
        'User-Agent': 'Mozilla/5.0',
        'Content-Language': 'zh-CN',
        'Authorization': '{}'.format(authorization)
    }

    subscribeResponse = requests.get(subscribeUrl, headers=subscribeHeaders)
    return json.loads(subscribeResponse.text).get("data").get("subscribe_url")


# email = generate_random_email()
# password = generate_random_password()
# ip = generate_random_ip()

# register(email, password, ip)
# getEXPTime()
# authorization = login(email, password)
# if authorization:
#     print("订阅地址yaml文件：", getSubscribe(authorization))
#     input("输入任意键关闭窗口")
