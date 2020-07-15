# Indice
- [Initial](#initial)
- [CI Fundamentals](#ci-fundamentals)
- [YAML Basic](#yamlbasic)
- [GitLab CI in AWS](#gitlabciinaws)
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

### Pods

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
kubectl apply -f pod-test1.yaml 
sudo kubectl get all
sudo kubectl get pods
sudo kubectl get pods -o wide

sudo kubectl describe pod {nombre}
kubectl delete -f {nombre}
kubectl delete pod {nombre}
```

Cuando levantemos un Pods no vamos a poder verlo desde afuera hasta que levantemos un servicio