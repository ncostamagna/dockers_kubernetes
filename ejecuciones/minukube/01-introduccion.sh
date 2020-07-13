minikube version

#Iniciar el Cluster - se va a descargar una ISO
#esta ISO contiene un linux
minikube start
sudo minikube start --vm-driver=none
sudo apt-get install htop -y # ver recursos de nuestra maquina

cat .kube/config # archivo con toda la configuracion

minikube stop # Parar el cluster, la VM
minikube delete # No solo para el cluster sino que lo elimina
rm -rf .minikube/ #Eliminamos directorio completo

minikube start #volvemos a levantar la VM

minikube addons list #ver los addons disponibles
minikube addons disable dashboard #desactivo dashboard
minikube addons enable dashboard #habilito dashboard
minikube ssh #nos conectamos a la maquina que esta corriendo de minikube

kubectl get nodes #Nodos que estan corriendo
sudo kubectl get all #Todos los servicios