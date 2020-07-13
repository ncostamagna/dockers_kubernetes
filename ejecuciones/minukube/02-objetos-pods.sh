vi example1.yaml

apiVersion: apps/v1
kind: Deployment #Tipo de objetos
metadata: #metadatos de uso interno
    name: nginx-deployment
spec:   #Especificacion
    selector:
        matchLabels:
            app: nginx
    replicas: 2 #2 pods
    template:
        metadata:
            labels:
                app: nginx
        spec:
            containers:
            -   name: nginx #contenedor nginx
                image: nginx:1.7.9 #va a descargar de docker hub
                ports:
                -   containerPort: 80



kubectl apply -f example1.yaml 

sudo kubectl get all #Vemos que estan corriendo

sudo kubectl delete -f example1.yaml

#por comando seria
kubectl run --image=nginx:1.7.9 --port=80 --replicas=2 nginx-deployment



vi pod-test1.yaml

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

kubectl apply -f pod-test1.yaml 
sudo kubectl get all
sudo kubectl get pods
sudo kubectl get pods -o wide

sudo kubectl describe pod {nombre}
kubectl delete -f {nombre}
kubectl delete pod {nombre}