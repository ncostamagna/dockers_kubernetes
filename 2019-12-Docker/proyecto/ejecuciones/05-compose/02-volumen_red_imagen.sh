#########################
####### Volumenes #######
#########################

vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: nginx-nahuel
            ports:
                - "8080:80"
            volumes:
                - "vol2:/usr/share/nginx/html"
            image: nginx
    volumes:
        vol2: #creamos un volumen

docker-compose up -d

docker info | grep -i root # /opt/docker
cd /opt/docker/volumes/docker-compose_vol2/_data
vi index.html
    #lo modificamos

docker-compose down # eliminamos, pero no se elimina el volumen
docker-compose up -d # levantamos de nuevo, y toma el volumen con las modificaciones que habiamos hecho

# volumen de host
vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: nginx-nahuel
            ports:
                - "8080:80"
            volumes:
                - "/home/ubuntu/docker-compose/html:/usr/share/nginx/html"
            image: nginx
docker-compose up -d

#########################
#######   Redes   #######
#########################


vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: nginx-nahuel
            ports:
                - "8080:80"
            image: nginx
            networks:
                - net-test
    networks:
        net-test:
docker-compose up -d
docker inspect nginx-nahuel # vemos como tiene la red docker-compose_net-test

vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: nginx-nahuel-1
            ports:
                - "8081:80"
            image: httpd
            networks:
                - net-test
        web2:
            container_name: nginx-nahuel-2
            ports:
                - "8082:80"
            image: httpd
            networks:
                - net-test
    networks:
        net-test:
docker-compose up -d
docker ps #tengo 2 corriendo ahora en la misma red
docker inspect nginx-nahuel 
docker exec -ti nginx-nahuel-2 bash -c "ping nginx-nahuel-1" # me responde
docker exec -ti nginx-nahuel-2 bash -c "ping web" # tambien con el nombre del tag


############################
#######   Imagenes   #######
############################

# usamos un directorio para el laboratorio
mkdir build-imagenes
cd build-imagenes

vi Dockerfile
    FROM centos
    RUN mkdir /opt/test
vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: web
            image: web-test
            build: . #nos sirve para construir la imagen, busca un Dockerfile en el directorio
docker-compose build # construyo imagen


vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: web
            image: web-test
            build:
                context: . # En que carpeta esta el Dockerfile
                dockerfile: Dockerfile1 # Le damos el nombre del Dockerfile


###############################################
#######   Modificar CMD de una Imagen   #######
###############################################

#creamos un contenedor con centos para comparar
docker run -dti centos # el comando es  "/bin/bash"

vi docker-compose-cmd.yml
version: '3'
services:
    web:
        container_name: web
        image: centos
        command: mkdir nahuelito # el comando es "mkdir nahuelito" ahora
        ports:
            - "8080:8080"
docker-compose -f docker-compose-cmd.yml up -d 

vi docker-compose-memory.yml
version: '2'
services:
    web:
        container_name: nginx
        mem_limit: 20m # Limitar memoria
        cpuset: "0" # cuantas cpu queremos
        image: nginx:alpine
