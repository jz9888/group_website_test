FROM node:16 as node_modules

LABEL MAINTAINER zhouxy<zhouxy1298@gmail.com>
    
ENV LANG en_US.UTF-8
    
ENV LANGUAGE en_US.UTF-8
    
ENV LC_ALL=en_US.UTF-8
    
RUN echo "Asia/Singapore" > /etc/timezone
    
WORKDIR /app
    
COPY ./package.json /app
    
RUN  npm i --registry=https://registry.npmjs.org
    
#build hugo 生成静态文件
    
FROM klakegg/hugo:0.107.0 as hugo
    
WORKDIR /src
    
COPY . /src/
    
# COPY --from=node_modules /app/node_modules /src/node_modules
    
# 生成静态文件
RUN hugo
    
# nginx web 服务器
FROM nginx:1.19.7-alpine
    
RUN  rm -rf /usr/share/nginx/html/*
    
COPY --from=hugo /src/public /usr/share/nginx/html

