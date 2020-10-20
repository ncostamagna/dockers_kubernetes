#Eliminar imagenes
docker rmi apache-cenco apache-cenco:primera

#ejecutar otro dockerfile
vi my-dockerfile
docker build -t test -f my-dockerfile .

docker images -q | xargs docker images rmi
docker ps -a -q | xargs docker rm -f