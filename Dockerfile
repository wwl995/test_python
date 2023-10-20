FROM python:3.8.17-buster

WORKDIR /root

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

# 安装依赖
RUN ssh -V && pi install Flask gunicorn

RUN chmod +x natapp

EXPOSE 6000

# 启动应用程序
CMD gunicorn -w 10 -b 0.0.0.0:6000 test:app
