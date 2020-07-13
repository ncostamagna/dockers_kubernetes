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

# Minikube

### Pods

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