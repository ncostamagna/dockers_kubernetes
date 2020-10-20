docker pull mongo #Descargar imagen oficial mongo
docker pull mongo:3.6.5-jessie #lo mismo pero con el tag 3.6.5-jessie

docker images #veo todas las imagenes que tengo
docker images | grep mongo #busco solo las de mongo

docker pull mysql #Descargar imagen oficial MySQL

#creamos una carpeta para trabajar
mkdir docker-images
cd docker-images

#creamos un archivo Dockerfile
vi Dockerfile
    FROM centos

    RUN yum install httpd -y

# apache-cenco es el nombre que le definimos, puede ser cualquiera
docker build --tag apache-cenco .
docker build --tag apache-cenco:primera . #creamos otra y le definimos un tag


docker history -H apache-cenco:latest #ver los comandos que se ejecutaron
docker rm -fv nervous_sanderson #eliminamos contenedor nervous_sanderson
docker ps -a #vemos los contenedores

#googleamos en apache 'run apache in foreground' para saber como se corre
vi Dockerfile
    FROM centos

    RUN yum install httpd -y

    CMD apachectl -DFOREGROUND

#volvemos a generar la imagen
docker build --tag apache-cenco:apache-cmd .

#corremos el docker
docker run -d --name apache apache-cenco:apache-cmd

#corremos el docker en el puerto 80
docker run -d --name apache1 -p 80:80 apache-cenco:apache-cmd
docker exec apache1 bash -c "echo 'Hello world' > /var/www/html/index.html" #creamos un index.html

#generamos un copi de esa carpeta en /var/www/html
vi Dockerfile
    FROM centos
    RUN yum install httpd -y
    COPY beryllium /var/www/html
    CMD apachectl -DFOREGROUND

# generamos variable de entorno
vi Dockerfile
    FROM centos
    RUN yum install httpd -y
    COPY beryllium /var/www/html
    ENV contenido prueba
    RUN echo "$contenido" > /var/www/html/prueba.html
    CMD apachectl -DFOREGROUND


docker rm -f {name} #Eliminamos contenedor 
docker run -d -p 80:80 apache1 #Corremos nuevamente con la imagen de apache1 que es la que usamos

# WORKDIR -> donde estamos trabajando actualmente
vi Dockerfile
    FROM centos
    RUN yum install httpd -y
    WORKDIR /var/www/html
    COPY beryllium .
    ENV contenido prueba
    RUN echo "$contenido" > prueba.html
    CMD apachectl -DFOREGROUND

# EXPOSE -> Exponer puerto distinto
vi Dockerfile
    FROM centos
    RUN yum install httpd -y
    WORKDIR /var/www/html
    COPY beryllium .
    ENV contenido prueba
    RUN echo "$contenido" > prueba.html
    EXPOSE 81
    CMD apachectl -DFOREGROUND

vi Dockerfile
    FROM centos

    LABEL version=1.0 #Etiqueta
    LABEL description="Curso de Docker Nahuel"
    
    RUN yum install httpd -y

    COPY beryllium /var/www/html

    RUN echo "$(whoami)" > /var/www/html/user1.html #Para saber que usuario ejecuta la tarea
    
    RUN useradd nahuel
    USER nahuel # Cambiamos de usuario
    RUN echo "$(whoami)" > /tmp/user2.html 

    USER root
    RUN cp /tmp/user2.html /var/www/html/user2.html

    CMD apachectl -DFOREGROUND

# Creamos un pequeño script para correr CMD
vi run.sh
    echo "iniciando container..."
    apachectl -DFOREGROUND

# Agremamos en el fondo
vi Dockerfile
    ...
    COPY run.sh /run.sh #Copiamos el run.sh en el raiz
    CMD sh /run.sh # Lo ejecutamos

docker logs -f {nombre}

vi .dockerignore #podemos ignorar archivos para no enviar
    startbootstrap-freelancer-master #ignoramos este archivo