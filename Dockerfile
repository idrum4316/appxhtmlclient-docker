FROM ubuntu

RUN apt update && apt upgrade -y
RUN apt install -y mongodb-server nginx supervisor nodejs npm
RUN sed -i '1idaemon off;' /etc/nginx/nginx.conf
RUN mkdir -p /data/db
RUN mkdir -p /logs

WORKDIR /opt/appx/connector
RUN npm install atob hexy iconv-lite mongodb node-cryptojs-aes semver-compare streamifier string ws node-linux mime

COPY appx-server-connector /opt/appx/connector
COPY appx-webhost /opt/appx/webhost
COPY appx-client-settings.js /opt/appx/webhost/js/appx-client-settings.js
COPY supervisord.conf /root/.config/supervisord/supervisord.conf
COPY nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 80

ENV APPX_CONNECTOR_PORT 3014
ENV APPX_MONGO_CONNECTOR_PORT 3015

CMD supervisord -c /root/.config/supervisord/supervisord.conf
