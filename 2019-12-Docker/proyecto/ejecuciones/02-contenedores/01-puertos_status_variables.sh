# Buscamos la imagen oficial de jenkins
docker pull jenkins

docker run -d jenkins # -d -> corremos en segundo plano
docker run -d -p 8080:8080 jenkins #corremos otro contenedor
docker ps #vemos que tenemos 2 contenedores
docker run -d -p 9090:8080 jenkins # exponemos el puerto de la imagen (8080) al puerto 9090

docker rename {name1} {name2} #renombrar dockers
docker stop {name | id} # detener docker
docker start {name | id} # iniciar docker
docker restart {name | id} # reiniciar docker

# poder entrar adentro del contenedor
docker exec -ti {name | id} bash
    whoami # Usuario del contenedor
    hostname # el ID actua como hostname del contenedor
    cat /var/jenkins_home/secrets/initialAdminPassword #encontramos el archivo que pide jenkins
    echo $variable_de_entorno

# Ingresamos con usuario root
docker exec -u root -ti {name | id} bash

# Creamos una variable de entorno en el contenedor,
# para crearla en la imagen es agregarla al ENV
docker run -d -e "prueba1=123" jenkins



