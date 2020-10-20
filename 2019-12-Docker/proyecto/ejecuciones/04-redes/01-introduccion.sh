ip a | grep docker # se genera una interfaz por defecto para dockers
#por defecto es 0

docker network ls # vemos todas las redes 
docker network inspect bridge # Tenemos la subnet y el gateway
# los contenedores con esa red van a estar dentro de esa subnet

#########################
##### Crear una Red #####
#########################

docker network create mi-red
docker network ls
docker network create -d bridge --subnet 172.124.10.0/24 --gateway 172.124.10.1 mi-red-2
docker network ls | grep mi-red
docker network inspect mi-red-2 # tenemos lo mismo que creamos


##################################################
### asociar la red que creamos a un contenedor ###
##################################################

docker run --network mi-red-2 -d --name test-red -ti centos
docker inspect test-red

#############################################
### asociar varios contenedores a una red ###
#############################################

docker run -d --network mi-red-2 --name cont1 -ti centos
docker run -d --network mi-red-2 --name cont2 -ti centos

docker inspect cont1 # IP 3
docker inspect cont1 # IP 4

# Podemos hacer ping y comunicarnos con el container
docker exec cont1 bash -c "ping 172.124.10.4" # 172.124.10.4 -> IP contenedor 2
docker exec cont2 bash -c "ping 172.124.10.3" # 172.124.10.4 -> IP contenedor 2

# al crear nuestra propia red podemos pegarle con el nombre, 
# cosas que no podemos hacer si no la creamos
# si o si, para hacer esto, tienen que estar en la misma red
docker exec cont1 bash -c "ping cont2" 


#############################################
### conectar conectores a distintas redes ###
#############################################

# Definimos un cont3 en otra red, no podemos comunicarnos a cont1 ni cont2
docker run -d --network mi-red --name cont3 -ti centos

docker exec cont1 bash -c "ping cont3" # No hay comunicacion 

# docker network connect -> conectar contenedor a una red existente
# conecta el contenedor 3 a la red 2, (cont3 la asociamos a mi-red anteriormente)
# de esta manera podemos conectarnos
docker network connect mi-red-2 cont3 
docker inspect cont3 # ahora tiene ambas redes
docker exec cont1 bash -c "ping cont3" # Ahora si hay comunicacion

# Desconectar red de cont3
docker network disconnect mi-red-2 cont3
docker exec cont1 bash -c "ping cont3" # Ahora vuelve a no haber comunicacion, desconectamos la red
docker inspect cont3 # ahora solo pertenece a mi-red

########################
##### Eliminar Red #####
########################
# No puedo eliminar una red que esta asociada a un contenedor,
# primero debo eliminar el contenedor, sino generara error y no me 
# permitira eliminar la red
docker rm -fv cont1 cont2 # Eliminamos los contenedores que tienen esa red
docker network rm mi-red-2 # Eliminarmos la red
docker network ls | grep mi-red # Ya no esta
