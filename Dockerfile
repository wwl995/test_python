FROM python:3.8.15

WORKDIR /root

RUN apt-get -qq -y -q update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y -q install apt-utils wget curl openssh-server

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

# 安装依赖
RUN pip3 install Flask && pip3 install gunicorn

RUN wget "https://cdn.natapp.cn/assets/downloads/clients/2_3_9/natapp_linux_amd64/natapp" && chmod +x natapp

RUN echo "AllowUsers root" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd

EXPOSE 6000

# 启动应用程序
CMD nohup /usr/sbin/sshd -D > /app/sshd.log 2>&1 & gunicorn -w 10 -b 0.0.0.0:6000 test:app
