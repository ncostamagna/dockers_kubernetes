#####################################
#####       Instalaciones       #####
#####################################

#### LOS ARCHIVOS ESTAN EN docker-compose > apps
docker-compose up -d

# on-depende: db -> depende del servicio db, 
#                   primero se instala db para poder instalar este.
#                   db es el nombre que le pusimos,
#                   ejemplo en apps > wp