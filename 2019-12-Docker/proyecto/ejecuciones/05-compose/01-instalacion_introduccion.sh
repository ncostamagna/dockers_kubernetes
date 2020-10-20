#######################
##### Instalacion #####
#######################
# google -> docker compose install
#           > Install Compose > Linux

sudo su
#descargamos el binario
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#/usr/local/bin/docker-compose
docker-compose #ejecutamos de esta manera tambien y ya lo vemos funcionando


##########################
##### Primeros Pasos #####
##########################

# creamos un contenedor para que sea mas facil que trabajemos
mkdir docker-compose 
cd docker-compose
vi docker-compose.yml
    version:    #obligatoria
    services:   #obligatoria
    volumes:    #opcional
    networks:   #opcional

# google -> docker compose version, ahi vemos la version a utilizar
vi docker-compose.yml
    version: '3'
    services:
        web:
            container_name: nginx-nahuel
            ports:
                - "8080:80"
            image: nginx
docker-compose up -d #levantarlo
docker-compose down #eliminarlo

# Variables de entorno
echo "mivariable=vivalor" > common.env
vi docker-compose.yml
version: '3'
services:
    db:
        container_name: my-sql-nahuel
        ports:
            - "3306:3306"
        image: mysql:5.7
        environment:
            - "MYSQL_ROOT_PASSWORD=12345678" #variables en yml
        env_file: common.env #variables por archivo
docker-compose up -d # lo corremos
docker exec -ti my-sql-nahuel bash
    env #vemos las variables que generamos