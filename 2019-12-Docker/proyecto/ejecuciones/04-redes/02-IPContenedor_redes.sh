#################################
#### Asignar IP a Contenedor ####
#################################

docker network create --subnet 172.128.10.0/24 --gateway 172.128.10.1 -d bridge my-net
docker run --network my-net -d --name nginx1 -ti centos

# como hago para definirle una IP
# Copio la Subnet de la network (my-net)
docker network inspect my-net # es -> 172.128.10.0/24
docker run --network my-net --ip 172.128.10.50 -d --name nginx2 -ti centos # Le metemos .50 porque quiero, puede ser cualquier numero
docker inspect nginx2 # Ahora tiene asociado 172.128.10.50
# MUY IMPORTANTE
# Nosotros antes de asignar la IP debemos crear la subnet y definirle una subnet y un gateway


# Red HOST
# host es una red que ya existe en mi network
docker run --network host -d -ti centos
docker ps
docker exec -ti competent_morse bash
    hostname #Hereda el mismo nombre de mi maquina
# HOST: Hereda las mismas conexiones que mi maquina local

# Red None
# Para que los contenedores que metamos ahi no tengan red
docker run --network none --name example-none -d -ti centos
docker inspect example-none # No va a tener red