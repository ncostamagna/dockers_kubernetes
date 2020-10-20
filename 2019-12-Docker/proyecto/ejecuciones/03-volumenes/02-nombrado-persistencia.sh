docker volume create mydata #crear volumen
docker volume ls
docker volume rm mydata  #eliminar volumen

docker volume create mydata
# -v mydata:/var/lib/mysql
# hacemos referencia al volumen que creamos 
docker run -d --name mi-bd-6 -e "MYSQL_ROOT_PASSWORD=12345" -v mydata:/var/lib/mysql mysql:5.7

#de esta manera si usamos el volumen no se va a eliminar
docker rm -fv mi-bd-6

# volumenes que no estan referenciados a ningun contenedor
docker volume ls -f dangling=true
docker volume ls -f dangling=true -q #para poner los id
docker volume ls -f dangling=true -q | xargs docker volume rm # Eliminamos todo


#########################
### Persistir MongoDB ###
#########################

# que todo lo que se genere lo guarde aca
cd /opt
mkdir mongo

#buscamos donde guarda la info mongo es en /data/db/
docker pull mongo
docker run -d -p 27017:27017 -v /opt/mongo/:/data/db mongo

# para jenkins /var/jenkins_home

# sin necesidad de entrar al bash
docker exec jenkins bash -c "cat {ruta de jenkis}"


#######################
### Persistir Nginx ###
#######################
docker pull nginx

#creamos carpeta /opt/nginx
docker run -d -p 80:80 -v /opt/nginx/:/var/log/nginx/ nginx # salvamos los logs por mas que borremos el contenedor



###########################
### Compartir volumenes ###
###########################

mkdir common # en la carpeta volumen
vi Dockerfile
    FROM centos
    COPY start.sh /start.sh
    RUN chmod +x /start.sh
    CMD /start.sh

#generamos un archiv bash
vi start.sh
    #!/bin/bash

    while true; do
        echo $(date +%H:%M:%S) >> /opt/index.html && \
        sleep 10
    done

docker build -t test .

# compartimos en ambos la carpeta $PWD/common
# $PWD -> en el directorio donde estoy parado
docker run -v $PWD/common:/opt/ -d --name gen test # $PWD directorio actual
docker run -v $PWD/common:/usr/share/nginx/html -d --name nginx -p 80:80 nginx:alpine # generamos otro contenedor con nginx 
