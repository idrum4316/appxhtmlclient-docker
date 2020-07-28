FROM ubuntu

# To prevent hanging at tzdata install
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Dependencies
RUN apt update && apt upgrade -y
RUN apt install -y mongodb-server nginx supervisor nodejs npm
RUN sed -i '1idaemon off;' /etc/nginx/nginx.conf
RUN mkdir -p /data/db
RUN mkdir -p /logs

# Copy files
COPY serverConnector /opt/appx/connector
COPY webhost /opt/appx/webhost
COPY appx-client-settings.js /opt/appx/webhost/js/appx-client-settings.js
COPY supervisord.conf /root/.config/supervisord/supervisord.conf
COPY nginx.conf /etc/nginx/sites-enabled/default

# Install server connector dependencies
WORKDIR /opt/appx/connector
RUN npm install

# Set environment
ENV APPX_CONNECTOR_PORT 3014
ENV APPX_MONGO_CONNECTOR_PORT 3015

EXPOSE 80
CMD supervisord -c /root/.config/supervisord/supervisord.conf
