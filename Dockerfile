# 基础镜像
FROM infiniflow/ragflow-base:v2.0

# 切换到 root 用户
USER root

# 设置工作目录
WORKDIR /ragflow

# 复制并构建前端代码
ADD ./web ./web

# 分步骤构建，先安装依赖，再运行构建命令
RUN cd ./web && npm i --force && npm run build

# 复制后端代码及配置文件到容器中
ADD ./api ./api
ADD ./conf ./conf
ADD ./deepdoc ./deepdoc
ADD ./rag ./rag
ADD ./agent ./agent
ADD ./graphrag ./graphrag

# 复制并设置入口脚本和环境文件
ADD docker/entrypoint.sh ./entrypoint.sh
ADD docker/.env ./
RUN chmod +x ./entrypoint.sh

# 设置环境变量
ENV PYTHONPATH=/ragflow/
ENV HF_ENDPOINT=https://hf-mirror.com

# 设置容器启动时的默认入口点
ENTRYPOINT ["./entrypoint.sh"]
