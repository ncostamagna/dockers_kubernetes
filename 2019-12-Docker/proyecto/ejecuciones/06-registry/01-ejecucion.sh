# Creamos el directorio
mkdir registry
cd registry

# El Registry se crea como un contenedor,
# necesitamos un volumen para que la data persista
docker run -d -p 5000:5000 --name registry -v $PWD/data:/var/lib/registry registry:2
docker ps

# Supongamos que queremos subir una imagen, tomamos la de hello-world para probar
docker pull hello-world

# Antes de subir la imagen al registry tenemos que tagearla
docker tag hello-world localhost:5000/hello-world

# La subimos
docker push localhost:5000/hello-world

# eliminamos las que tenemos
docker rmi hello-world localhost:5000/hello-world

# Podemos bajar la imagen que subimos de la misma manera que las oficiales
docker pull localhost:5000/hello-world


###########################################
#### Como subir la imagen usando la IP ####
###########################################
# Vamos a un archivo del sistema de Dokcers
vi /lib/systemd/system/docker.service
    # en la linea 
    ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --data-root /opt/docker
    # le agregamos un --insecure-registry {la ip de nuestra red}:{el puerto que le definimos}
    --insecure-registry 3.20.11.124:5000

sudo systemctl daemon-reload #Informarle al OS que hicimos un cambio
docker stop registry # lo detenemos
sudo systemctl restart docker # hacemos un restart de Docker
docker start registry # Iniciamos nuestro registry

# Probamos hacerlo en la red, ahora que modificamos el archivo de Docker
docker pull hello-world
docker tag hello-world 3.20.11.124:5000/hello-world
docker push 3.20.11.124:5000/hello-world
# ya tenemos el push en la red

# las eliminamos todas con docker rmi y hacemos un pull para probar
docker pull 3.20.11.124:5000/hello-world