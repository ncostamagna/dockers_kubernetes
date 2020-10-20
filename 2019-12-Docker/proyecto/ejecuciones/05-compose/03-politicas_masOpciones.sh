############################################
### Politicas de reinicio de componentes ###
############################################
# google -> docker restart policy
mkdir restart
cd restart
vi Dockerfile
    FROM centos
    COPY start.sh /start.sh
    RUN chmod +x /start.sh
    CMD /start.sh

vi start.sh
    #!/bin/bash
    echo "Estoy vivo"
    sleep 5
    echo "Estoy detenido"

# restart always -> cada vez que se detiene se vuelve a iniciar
# restart: unless-stop -> a menos que yo haya reiniciado el servidor se va a 
#                          volver a iniciar siempre, si lo detenemos manualmente
#                          no va a volver a correr
# restart: on-failure -> a menos que ocurra el error va a volver a iniciarse siempre,
#                       si le ponemos un exit 1 al start.sh, porque 1 es codigo de error
vi docker-compose.yml
    version: '3'
    services:
        test:
            container_name: test
            image: restart-image
            build: .
            restart: always # Por defecto es no
docker-compose build # creo la imagen
docker-compose up -d # lo levanto
docker logs -f test

# podemos hacerlo tambien en la ejecucion del docker
docker run -dti --restart always redis

### --- Modificar Prefijo --- ###
# ejecutamos un docker compose
docker-compose -f mi-docker-compose.yml up -d
# Creating network "dockercompose_default" -> como modificar ese prefijo (dockercompose)
docker-compose -p putamadre -f mi-docker-compose.yml up -d
# Creating network "putamadre_default" -> modificamos el prefijo