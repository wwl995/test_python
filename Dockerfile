FROM centos:8 # 将基础镜像更改为 CentOS 8

WORKDIR /root

RUN yum -y update && \
    yum -y install wget curl git sudo bash-completion tree vim openssh-server openssh-clients python3 python3-pip && \
    mv /usr/bin/lsb_release /usr/bin/lsb_release.bak && \
    yum clean all && \
    rm -rf /var/cache/yum/*

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
