# 使用Ubuntu 18.04作为基础镜像
FROM ubuntu:18.04

# 更新软件包列表并安装依赖
RUN apt-get update && apt-get install -y software-properties-common && apt-get clean && rm -rf /var/lib/apt/lists/*

# 更新软件包列表以获取PPA存储库中的信息
RUN apt-get update

# 安装Python 3.7及其依赖项
RUN apt-get install -y python3.7 python3.7-dev  python3-pip

# 验证安装结果
RUN python3 --version && pip3 --version
    
# 将当前目录中的所有文件复制到容器的/app目录中
COPY . /app

# 设置工作目录为/app
WORKDIR /app

# 安装依赖
RUN pip3 install Flask && pip3 install gunicorn

EXPOSE 6000

# 启动应用程序
CMD gunicorn -w 10 -b 0.0.0.0:6000 test:app
