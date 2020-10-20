docker pull mysql
docker run -d --name mi-bd-1 -e "MYSQL_ROOT_PASSWORD=12345" mysql:5.7
docker run -d -p 3006:3006 --name mi-bd-2 -e "MYSQL_ROOT_PASSWORD=12345" -e "MYSQL_DATABASE=testDocker" -e "MYSQL_USER=nahuel" -e "MYSQL_PASSWORD=1234" mysql:5.7
mysql -u root -h 172.17.0.2 -p #ingresamos
    use testDocker

    CREATE  TABLE IF NOT EXISTS `prueba` (
    `id` INT ,
    `name` VARCHAR(150) NOT NULL ,
    `gender` VARCHAR(6) ,
    PRIMARY KEY (`id`) );

    insert into `prueba` values(1,'nahuel', 'H');
    insert into `prueba` values(2,'celeste', 'M');

    # Si elimino el contenedor se eliminaria toda la informacion de la base de datos

# Buscamos donde se guarda la informacion de mysql, la guarda en /var/lib/mysql

cd /opt
mkdir mysql
# -v /opt/mysql/:/var/lib/mysql -> generamos el volumen en la carpeta que generamos
docker run -d -p 3006:3006 --name mi-bd-2 -e "MYSQL_ROOT_PASSWORD=12345" -e "MYSQL_DATABASE=testDocker" -e "MYSQL_USER=nahuel" -e "MYSQL_PASSWORD=1234" -v /opt/mysql/:/var/lib/mysql mysql:5.7

cd /opt/mysql #vemos como se generan los archivos automaticamente
# Ahora si lo elimino y lo vuelvo a levantar
# mapeando lo mismo -v /opt/mysql/:/var/lib/mysql
# no perderiamos la informacion

docker run -d --name mi-bd-5 -e "MYSQL_ROOT_PASSWORD=12345" -v /opt/mysql/:/var/lib/mysql mysql:5.7

# -v /var/lib/mysql -> no defino donde guardarlo, va a ser al azar
docker run -d --name mi-bd-5 -e "MYSQL_ROOT_PASSWORD=12345" -v /var/lib/mysql mysql:5.7

#definimos un nuevo contenedor con VOLUME
vi Dockerfile1
    FROM centos
    VOLUME /opt/
docker build -t test-vol -f Dockerfile1 .
docker run -dti --name test test-vol # -dti para que no se muera
docker volume ls # vemos los volumenes
docker exec -ti test bash
    cd opt
    touch file1.txt
    touch file2.txt
    exit
docker volume ls
docker info | grep -i root
cd /opt/docker/volumes
cd ab82efff29f59a9f91b303ef2046910fe958e79c57ab93f4d14b6d6b4b4368b6
cd _data #ahi se encuentran ya file1 y file2, si borramos el container con -f esos arechivos quedan igual

# f -> elimina contenedor
# v -> elimina volumen
docker rm -fv {name}