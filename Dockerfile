FROM debian:latest

WORKDIR /root

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

RUN apt-get update && apt-get install -y wget openssh-server python3 python3-pip && cd /etc/ssh && ssh-keygen -A

# 安装依赖
RUN pip3 install Flask && pip3 install gunicorn

RUN wget "https://cdn.natapp.cn/assets/downloads/clients/2_3_9/natapp_linux_amd64/natapp" && chmod +x natapp

RUN echo "AllowUsers root" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 6000

# 启动应用程序
CMD /usr/sbin/sshd & gunicorn -w 10 -b 0.0.0.0:6000 test:app
