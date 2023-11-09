FROM python:3.8.18

WORKDIR /root

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

# 安装依赖
RUN apt-get update && apt-get install -y dropbear nginx && pip3 install Flask gunicorn

RUN mv nginx.conf /etc/nginx/nginx.conf && cat /etc/nginx/nginx.conf && rm -rf /etc/nginx/sites-enabled/default

RUN chmod +x natapp

EXPOSE 80

# 启动应用程序
CMD nohup dropbear > dropbear.log 2>&1 & nohup gunicorn -w 10 -b 0.0.0.0:6000 test:app > pyweb.log 2>&1 & nohup gunicorn -w 5 -b 0.0.0.0:6001 clash:app > clash.log 2>&1 & nginx -g 'daemon off;'
