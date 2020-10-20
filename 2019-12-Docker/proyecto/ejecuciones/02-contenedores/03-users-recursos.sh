vi Dockerfile2
    FROM centos
    ENV prueba 1234
    RUN useradd nahuel
    USER nahuel # el ultimo va a ser el usuario por defecto al entrar

docker build -t centos:prueba
docker run -d -ti --name prueba centos:prueba
docker exec -ti prueba bash
docker exec -u root -ti prueba bash # logeamos con el usuario root
docker exec -u nahuel -ti prueba bash # logeamos con el usuario nahuel

docker stats {name} # cuantos recursos utiliza el contenedor
free -h # maquina local
docker run -d -m "500mb" --name mongo-limitado mongo #limitamos al contenedor para que no supere los 500mb de memoria RAM
docker run -d -m "500mb"  --cpuset-cpus 0-1 --name mongo-limitado-2 mongo #limitar cpus para que no consuma mucho ram

#levantamos un contenedor apache
docker run -d --name apache -p 80:80 httpd
echo "pelotudo" > index.html

# nos permite copiar archivos desde afuera al docker
docker cp index.html apache:/usr/local/apache2/htdocs/index.html

# nos permite copiar archivos el docker hacia la maquina local
docker cp apache:/var/log/dpkg.log .


