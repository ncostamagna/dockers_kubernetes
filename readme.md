# Indice
- [Instalaciones](#instalaciones)
- [Minikube 101](#minikube-101)
- [Minikube](#minikube)

<br />

# Instalaciones


```sh
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

#Instalamos Kubernetes
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

### Minikube
```sh
#instalamos minikube
egrep --color 'vmx|svm' /proc/cpuinfo
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube
sudo apt-get install -y virtualbox
```
<br />

# Minikube 101

Asignamos 2 cpu, 1G de RAM y el virtualbox que instalamos como driver<br />
Inicializamos la maquina que vamos a usar
```sh
minikube start --cpus=2 --memory=1G --driver=virtualbox
```

Vamos a usar el de Dockers que es el que nos interesa
```sh
minikube start --cpus=2 --memory=1G --driver=docker
```

```sh
minikube status # Estado de varios componentes
kubectl get nodes # Muestra los nodos que se estan ejecunado
kubectl get all # Todos los objetos que estan creados

minikube pause # Esto va a pausar el clouster, si ejecuto ahora un get node no va a responder
minikube unpause # Restauro el estado del clouster (pause y unpause medio al pedo)

minikube stop # Para el closter directamente, todos los componentes, para volver a levantarlo start
```

En el archivo **./minikube/config/config.json**<br />
podemos fichar opciones, generamos una con el comando
```sh
minikube config set cpus 2
```
Vemos que el json queda asi ahora, si hago un delete y un start, arrancaria ya con esas opciones
```json
{
    "cpus": 2
}
```
Eliminamos una opcion
```sh
minikube config unset cpus
```

### Troubleshooting
```sh
minikube ip # Obtener IP
minikube ssh # Nos conectamos al cluster, podemos ver todos los dockers dentro
minikube logs # Logs del sistema
minikube logs f --problems=true # Logs solo de los errores
minikube update-check # Ultima version de minikube
```

```sh
minikube addons list # Podemos ver todos los addons
minikube addons enable nombre-del-addons # Activamos el addons
# Los componentes van a arrancar en forma de contenedor en nuestro cluster

minikube nombre-del-addons # Nos abre el addons, en este caso lo hicimos con dashboard
```
<br />


# Minikube

**Minikube** nos va a permitir crear un cluster de kubernetes en una pequeña maquina virtual, de esta forma podemos practicar los comandos de Kubernetes sin necesidad de crear un gran cluster

```sh
sudo apt-get install htop -y # ver recursos  de nuestra maquina, version avanzada de top
htop

```

**Addons**: Componentes de kubernetes
- **dashboard**: Nos va a mostrat informacion de todo lo que esta corriendo

```yaml
apiVersion: apps/v1
kind: Deployment # Tipo de objetos
metadata: # metadatos de uso interno
    name: nginx-deployment
spec:   # Especificacion
    selector:
        matchLabels:
            app: nginx
    replicas: 2 # 2 pods
    template:
        metadata:
            labels:
                app: nginx
        spec:
            containers:
            -   name: nginx # contenedor nginx
                image: nginx:1.7.9 # va a descargar de docker hub
                ports:
                -   containerPort: 80 # puerto expuesto
```
```sh
# Podemos hacerlo de esta manera tambien, pero es muy propensa a errores
kubectl run --image=nginx:1.7.0 --port:80 --replicas=2 nginx-deployment
```

### Pods

Va a indicar un contenedor o un grupo de contenedores, no podemos ejecutar un contenedor a secas
como lo hacemos con Docker, debemos hacerlo mediante un pod<br />
Un Pod estara en ejecucion el tiempo que su proceso principal este en ejecucion, un pod por lo general sera un servidor web, una base de datos, etc..<br />

![Pods](imagenes/111.png)

Generamos un archivo **pod-test1.yaml**

```yaml
apiVersion: v1
kind: Pod #Tipo de objetos
metadata: #metadatos de uso interno
    name: nginx
spec:   #Especificacion
    containers:
    -   name: nginx #contenedor nginx
        image: nginx:1.7.9 #va a descargar de docker hub
        ports:
        -   containerPort: 80
```

```sh
kubectl apply -f 
sudo kubectl get all # Objeto de pod-test1.yaml tipo Pod que esta corriendo
sudo kubectl get pods
sudo kubectl get pods -o wide # Vemos en que nodo se esta ejecutando los Pods

sudo kubectl describe pod {nombre} # detalle del pod
kubectl delete -f {nombre} # eliminamos por el nombre pod-test1.yaml 
kubectl delete pod {nombre} # o por el tipo de objeto (pod) y el nombre del objeto (nginx)
```
Si vemos la IP del pod y tratamos de acceder no vamos a poder desde afuera, para verlo debemos entrar
```sh
minikube ssh
docker ps # Listamos dentro de minikube los dockers que estan corriendo
```
Cuando levantemos un Pods no vamos a poder verlo desde afuera hasta que levantemos un servicio

```sh
kubectl apply -f pod-test1.yaml # ejecutamos el yaml que habiamos generado
kubectl exec -it nginx bash # Entramos al pod, nginx es el nombre del pod

#instalamos curl
curl localhost # vemos como nos devuelve el html por defecto de nginx

kubectl port-forward nginx 8080:80 # nginx (nombre pod), del 80 de nginx al 8080 de nuestra maquina
# De esta manera haciendo un
curl localhost
# en nuestra maquina, podriamos acceder sin entrar al cluster
```

**Metadatos**
```yaml
apiVersion: v1
kind: Pod #Tipo de objetos
metadata: #metadatos de uso interno
    name: nginx
    labels:
      project: aplicacion1
      environment: testing # Podriamos identificar en los diferentes ambientes
spec:   #Especificacion
    containers:
    -   name: nginx #contenedor nginx
        image: nginx:1.7.9 #va a descargar de docker hub
        ports:
        -   containerPort: 80
```
**Selector**<br />
Podemos filtrar y buscar los pods generados
```sh
kubectl get pods -o wide --show-labels --selector project=aplicacion1
```
**Replication Controllers**<br />
Escalabilidad horizontal, podemos generar replicas y darle escalabilidad horizontal, esto genera un replication controller, lo podemos ver con **kubectl get all -o wide --show-labels**
```yaml
apiVersion: v1
kind: Pod #Tipo de objetos
metadata: #metadatos de uso interno
    name: nginx
    labels:
      project: aplicacion1
      environment: testing # Podriamos identificar en los diferentes ambientes
spec:   #Especificacion
    replicas: 2 # ejecutamos 2 replicas
    containers:
    -   name: nginx #contenedor nginx
        image: nginx:1.7.9 #va a descargar de docker hub
        ports:
        -   containerPort: 80
```
**Servicios**<br />
Para acceder desde afuera al puerto 80, un servicio es una abstraccion que define como va a ser el acceso externo, el pod que va a acceder en un servicio lo a va ser mediante un selector<br />
Pods -> Selection -> Servicio <br />

```sh
kubectl apply -f pod-test1.yaml 
```
Generamos un service
```yaml
apiVersion: v1
kind: Service #Tipo de objetos
metadata: #metadatos de uso interno
    name: my-service
    labels:
      project: aplicacion1
      environment: testing # Podriamos identificar en los diferentes ambientes
spec:
    type: NodePort 
    selector: # el servicio va a enviar el trafico a los que esten usando este selector
      project: aplicacion1
      environment: testing # Podriamos identificar en los diferentes ambientes
    ports:
      - protocol: TCP
        port: 80 # envia el trafico al puerto 80
```
```sh
kubectl apply -f servicio.yaml 
kubectl get all -o wide --show-labels # tiene que mandar a los labels que definimos,
                                      # sino va a mandar a un pod que no existe

minikube ip # nos devuelve la IP
curl 192.168.98.101.31318 # a la IP de minikube y al puerto servicio
```

En este caso si elimino el pod-ejempli1.yml no me afecaria el puerto del servicio
- ClusterIP: Expone servicio en ip interna del cluster
- NodePort: Expone servicio en cada ip de los nodos, puerto estatico
- LoadBalancer: Expone el servicio externamente usando un load balancer

**Replica Set**<br />
va a soportar el nuevo modo de selectores, la recomendacion es no usar la Replica Set sino es su lugar utilizar los tipos **deployment**
![112](imagenes/112.png)
![113](imagenes/113.png)
```sh
kubectl get rs # listarlo
hubectl describe rs frontend # descripcion del replica set frontend
hubectl delete rs frontend # Eliminar
hubectl delete rs frontend --cascade=false # se elimina sin eliminar todo lo que RS haya creado
kubectl delete pod --all # Elimina todos los pods
```

**Deployments**<br />
Va a ser un emboltorio, tiene unos metadatos y el numero de replicas, viene bien
usarlo cuando queremos que un objeto deployment gestione sus mediaset y pods.<br />
```yaml
apiVersion: app/v1
kind: Deployment #Tipo de objetos
metadata: #metadatos de uso interno
    name: nginx-deployment
    labels:
      app: nginx
spec:
    replicas: 3
    selector: 
        matchLabels:
            app: nginx

    template:
        metadata:
            labels:
                app: nginx
        spec:
            containers:
            -   name: nginx
                image: nginx:1.7.9
                ports:
                -   containerPort: 80
```

```sh
kubectl set image deployment/nginx-deployment nginx=nginx:1.15;

# Nos va a mostrar el estado del rollout
kubectl rollout status deployment/nginx-deployment
```
<br />

**Volumenes**<br />
Podemos asociar volumenes a Pods (manera por defecto), pero existen otros tipos de volumenes (este seria el volumen local), veremos otros tipos en AWS<br /><br />
**ConfigMaps**<br />
Vaalores de configuracion o ficheros que le vamos a pasar a nuestros contenedores
```sh
kubectl create configmap test-cm --from-literal variable1=valor1
kubectl descrive cm test-cm
```
<br />

**Secrets** <br />
PArecida a los ConfigMaps pero para almacenar cosas sensibles (password, token, etc), se van a almacenar de forma encriptada a travez de variables de entorno

```sh
kubectl get secrets # listar secrets
kubectl create secret generic nombre_credeciales --from-file=./file.txt --from-file=./otro_file.txt # los codifica en base64
kubectl describe secrets nombre_credeciales
kubectl get secrets nombre_credeciales -o yaml
```
<br />

**Request Limits** <br />

- request: cuanos recursos necesitaran los povs como minimo
- limit: maximo recursos que nuestro povs van a utilizar
<br />
tipos de recursos: memoria o cpu
<br /><br />

**Escalamiento**<br />
Cuanto trabajemos con kubernetes utilizaremos horizontal pod autoscaler (HPA)
<br /><br />

**Annotations**<br />
Igual que un label pero cambia donde lo usaremos, nos va a permitir agregar a los objetos datos para leer por otros kubernetes. Label nos permiten filtrar, Annotations nos permite agregar notas para detallar
<br /><br />

**RBAC**<br />
nos permite la autorizacion, permisos basados a roles