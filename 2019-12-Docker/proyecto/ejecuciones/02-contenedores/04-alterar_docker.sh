# Docker commit -> congelar a un docker y convertirlo a una imagen
mkdir commit
cd commit
vi Dockerfile
    FROM centos
    VOLUME /opt/volumen
docker build -t centos-test .
docker run -dti --name centos centos-test
docker exec -ti centos bash #ingreso al contenedor  
    cd opt
    touch file1.txt #creamos archivos en opt
    touch volumen/file1.txt #creamos archivos opt/volumen
    exit
docker rm -fv centos #elimino contenedor
docker run -dti --name centos centos-test # lo creamos de nuevo
docker exec -ti centos bash #entramos y verificamos
    #no hay nada, volvemos a crear el archivo en volumen y en opt
    touch file1.txt
    exit

#Convertimos el docker en una imagen
docker commit centos centos-resultado

# Corremos la imagen resultante, es probable que el CMD se pierda asi que lo volvemos
# a ejecutar al final
docker run -dti --name centos centos-resultado /bin/bash 

docker exec -ti centos bash #entramos y verificamos
# el archivo esta en opt pero se borro de volumen
# cuando hagamos esto en el Dockerfile -> VOLUME /opt/volumen
# todo lo que este ahi adentro, al hacer un commit, no se va a guardar
# lo que hay en un volumen es algo que no queremos que se guarde

# -dti para que no deje de funcionar el contenedor
docker run -dti --name centos2 centos echo "Hola Mundo" # Sobreescribimos el CMD
docker run -d -p 8080:8080 centos python -m SimpleHTTPServer 8080 # Sobreescribimos el CMD

#creamos, entramos al contenedor y cuando salimos se destruye
docker run --rm -ti centos bash

##################### 
### Document root ###
#####################
docker info | grep -i root
sudo su
cd /var/lib/docker #todos los archivos que estan aca forman parte del docker root
vi /lib/systemd/system/docker.service
    #modificamos el ExecStart agregandole --data-root /opt para cambiar el destino root
    ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root /opt

systemctl daemon-reload # lee el cambio que acabo de hacer
systemctl restart docker # aplica el cambio que acabo de hacer

# cambio el Document root pero pierdo todas las imagenes ¿como hago para recuperarlas?
sudo systemctl stop docker #detenemos docker
rm -rf /opt/* #eliminamos todo lo que tengamos en opt
mv /var/lib/docker/ /opt/ #movemos todo lo que teniamos en el Document root al nuevo rot definido

# mejor lo editamos para que sea /opt/docker
vi /lib/systemd/system/docker.service
    #modificamos el ExecStart agregandole --data-root /opt para cambiar el destino root
    ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root /opt/docker

systemctl daemon-reload # lee el cambio que acabo de hacer
systemctl restart docker # aplica el cambio que acabo de hacer