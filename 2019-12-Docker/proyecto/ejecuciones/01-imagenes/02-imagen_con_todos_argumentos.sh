# nginx nativo
vi Dockerfile
    FROM nginx
    RUN useradd nahuel
    COPY beryllium /usr/share/nginx/html
    ENV archivo docker
    WORKDIR /usr/share/nginx/html
    EXPOSE 90
    LABEL version=1
    USER nahuel
    RUN echo "Yo soy $(whoami)" > /tmp/yo.html
    USER root
    RUN cp /tmp/yo.html /usr/share/nginx/html/docker.html
    VOLUME /var/log/nginx
    CMD nginx -g 'daemon off;'
 
 # otro ejemplo
vi Dockerfile
FROM nginx

#lo tenemos en 3 lineas en lugar de hacer 3 RUN y generar mas capas
RUN echo "1" >> /usr/share/nginx/html/test.txt && echo "2" >> /usr/share/nginx/html/test.txt && echo "3" >> /usr/share/nginx/html/test.txt

#mejoro la maera visual, salto de linea con un \
RUN \
    echo "1" >> /usr/share/nginx/html/test.txt && \
    echo "2" >> /usr/share/nginx/html/test.txt && \
    echo "3" >> /usr/share/nginx/html/test.txt

#mejoro MAS la maera visual
ENV dir /usr/share/nginx/html/test.txt
RUN \
    echo "1" >> $dir && \
    echo "2" >> $dir && \
    echo "3" >> $dir
    
##########################################################################
##########################################################################
##########        Ejemplo con SSL para entrar por https       ############
##########################################################################
##########################################################################

#generamos un certificado ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nahuel.key -out nahuel.crt # en Common Name le agregamos localhost

#configuracion, buscamos en google 'https vhost apache'
vi ssl.conf
    <VirtualHost *:443>
    ServerName localhost
    DocumentRoot /var/www/html
    SSLEngine on
    SSLCertificateFile /nahuel.crt
    SSLCertificateKeyFile /nahuel.key
    </VirtualHost>

vi Dockerfile
    FROM centos:7
    RUN \
        yum -y install httpd php php-cli php-common \
            mod_ssl openssl

    RUN echo "<?php phpinfo(); ?>" > /var/www/html/hola.php

    COPY beryllium /var/www/html
    COPY ssl.conf /etc/httpd/conf.d/default.conf
    COPY nahuel.key /nahuel.key
    COPY nahuel.crt /nahuel.crt

    EXPOSE 443 #exponemos el puerto que usamos

    CMD apachectl -DFOREGROUND

docker run -d -p 443:443 apache:ssl



# Eliminar todas las imagens
docker images -q | xargs docker rmi