# 使用Ubuntu 18.04作为基础镜像
FROM ubuntu

WORKDIR /root

RUN apt-get -qq -y -q update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y -q install apt-utils wget curl git sudo bash-completion tree vim openssh-server openssh-client software-properties-common && mv /usr/bin/lsb_release /usr/bin/lsb_release.bak && apt-get -y -q autoclean && apt-get -y -q autoremove && apt-get install -y -q python3 python3-pip && rm -rf /var/lib/apt/lists/*

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
CMD /usr/sbin/sshd -D && gunicorn -w 10 -b 0.0.0.0:6000 test:app
