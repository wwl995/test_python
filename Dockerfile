FROM ubuntu:23.04

WORKDIR /root

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

RUN export PATH="/root/.local/bin:$PATH"

# 安装依赖
RUN apt-get update && apt-get install -y -q wget python3 pipx && pipx ensurepath && pipx install Flask && pipx install gunicorn

RUN chmod +x natapp

EXPOSE 6000

# 启动应用程序
CMD gunicorn -w 10 -b 0.0.0.0:6000 test:app
