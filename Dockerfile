# 使用Ubuntu 18.04作为基础镜像
FROM ubuntu

USER root

WORKDIR /root

RUN apt-get -qq -y -q update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y -q install wget curl git sudo bash-completion tree vim openssh-server software-properties-common && mv /usr/bin/lsb_release /usr/bin/lsb_release.bak && apt-get -y -q autoclean && apt-get -y -q autoremove && apt-get install -y -q python3 python3-pip && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

# 安装依赖
RUN pip3 install Flask && pip3 install gunicorn

RUN wget "https://cdn.natapp.cn/assets/downloads/clients/2_3_9/natapp_linux_amd64/natapp" && chmod +x natapp

RUN sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && /etc/init.d/ssh restart

EXPOSE 6000

# 启动应用程序
CMD gunicorn -w 10 -b 0.0.0.0:6000 test:app
