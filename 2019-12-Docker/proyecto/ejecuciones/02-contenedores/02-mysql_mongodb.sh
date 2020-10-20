vi Dockerfile1
    FROM centos

    RUN yum install httpd -y

    CMD apachectl -DFOREGROUND

docker build -t centos:v1 -f Dockerfile1 .

docker run -dti centos:v1

docker exec -ti {name | id} bash
    yum install mysql -y #instalar mysql adentro del docker centos
    apt-get install mysql-client #instalar en ubuntu

# Instalarlo en la maquina local
apt-get install mysql-client

docker pull mysql # descargar imagen oficial mysql
docker run -d --name mi-bd-1 -e "MYSQL_ROOT_PASSWORD=12345" mysql:5.7

docker logs -f {name | id}
docker inspect {name | id} # y tomamos la IPAddress

# 172.17.0.4 -> IP Address
# -p12345 -> 12345 es la password
mysql -u root -h 172.17.0.4 -p12345 

# levantamos un docker y exponemos un puerto 
# 3333 lo que larga el docker, 3006 puerto de mysql dentro del docker
docker run -d -p 3333:3006 --name mi-bd-2 -e "MYSQL_ROOT_PASSWORD=12345" -e "MYSQL_DATABASE=testDocker" -e "MYSQL_USER=nahuel" -e "MYSQL_PASSWORD=1234" mysql:5.7

mysql -u root -p12345 -h 172.0.0.1 --port 3333 # no pude hacer esta poronga, se va a la concha de su madre


# descargar MongoDB
docker pull mongo
docker run -d --name mi-mongo -p 27017:27017 mongo
docker run -d --name mi-mongo-2 -p 27018:27017 mongo
docker stats mi-mongo-2 #cuanta memoria esta consumiendo

docker pull nginx # nginx
docker run -d -p 8888:80 --name nginx nginx
docker pull httpd # apache
docker run -d -p 8889:80 --name apache httpd
docker pull postgres # postgress
docker run -d --name postgres -e "POSTGRES_PASSWORD=1234" -e "POSTGRES_USER=nahuel" -e "POSTGRES_DB=docker-db" -p 5432:5432 postgres
docker exec -ti postgres bash #ingresar
    psql -d docker-db -U nahuel
docker pull jenkins
docker run -d -p 8089:8080 --name jenkins jenkins