#!/bin/bash


## --------------------------------------------------
## Gabriela Q.  Pablo S. y Benjamín S. - IoTicos.org
## ---------------------------------------------------

rand-str()
{
    # Return random alpha-numeric string of given LENGTH
    #
    # Usage: VALUE=$(rand-str $LENGTH)
    #    or: VALUE=$(rand-str)

    local DEFAULT_LENGTH=64
    local LENGTH=${1:-$DEFAULT_LENGTH}

    LC_CTYPE=C  tr -dc A-Za-z0-9 </dev/urandom | head -c $LENGTH
    # -dc: delete complementary set == delete all except given set
}


clear
msg="
  _____     _____ _                   ___   __  
  \_   \___/__   (_) ___ ___  ___    / _ \ / /  
   / /\/ _ \ / /\/ |/ __/ _ \/ __|  / /_\// /   
/\/ /_| (_) / /  | | (_| (_) \__ \ / /_\\/ /___ 
\____/ \___/\/   |_|\___\___/|___/ \____/\____/ 

                                    ioticos.org                                                
"


tput setaf 128;
printf "$msg"
tput setaf 7;

printf "\n\n\nNecesitaremos algo de información para instalar este sistema\n\n"
printf "Verás entre paréntesis y en $(tput setaf 128)(este color)$(tput setaf 7) la opción por defecto que se selecciona presionando enter.\n"
printf "De lo contrario podrás ingresar manualmente la opción solicitada.\n"
printf "No te preocupes al final del cuestionario, verás un resumen antes de confirmar.\n\n\n"


read -p "Presiona enter para continuar..."
sleep 0




## ______________________________
## TIME ZONE
printf "\n\n⏳ Necesitamos configurar la zona horaria\n"
while [[ -z "$TZ" ]]
do
  read -p "   System Time Zone $(tput setaf 128)(UTC)$(tput setaf 7): "  TZ
  TZ=${TZ:-UTC}
  echo "      Selected Time Zone ► ${TZ} ✅"
done


## ______________________________
## MONGO

#username
printf "\n\n👤 Necesitamos crear un nombre de usuario para Mongo Db\n"
while [[ -z "$MONGO_USERNAME" ]]
do
  read -p "   Mongo User Name (admin): "  MONGO_USERNAME
  MONGO_USERNAME=${MONGO_USERNAME:-admin}
  echo "      Selected Mongo User Name ► ${MONGO_USERNAME} ✅"
done

#password
random_str=$(rand-str 20)
printf "\n\n🔐 Necesitamos crear una clave segura para Mongo Db\n"
while [[ -z "$MONGO_PASSWORD" ]]
do
  read -p "   Mongo Password $(tput setaf 128)(${random_str})$(tput setaf 7): "  MONGO_PASSWORD
  MONGO_PASSWORD=${MONGO_PASSWORD:-${random_str}}
  echo "      Selected Mongo Password ► ${MONGO_PASSWORD} ✅"
done

#port
printf "\n\n🔌 Selecciona un puerto para Mongo Db\n"
while [[ -z "$MONGO_PORT" ]]
do
  read -p "   Mongo Port $(tput setaf 128)(27017)$(tput setaf 7): "  MONGO_PORT
  MONGO_PORT=${MONGO_PORT:-27017}
  echo "      Selected Mongo Port ► ${MONGO_PORT} ✅"
done

## ______________________________
## EMQX

#MQTT NODE HOST
EMQX_NODE_HOST="emqx"

#Dashboard Password
random_str=$(rand-str 20)
printf "\n\n🔐 Necesitamos crear una clave para el Dashboard de EMQX \n"
while [[ -z "$EMQX_DEFAULT_USER_PASSWORD" ]]
do
  read -p "   EMQX Dashboard Password $(tput setaf 128)(${random_str})$(tput setaf 7): "  EMQX_DEFAULT_USER_PASSWORD
  EMQX_DEFAULT_USER_PASSWORD=${EMQX_DEFAULT_USER_PASSWORD:-${random_str}}
  echo "      Selected EMQX Dashboard Password ► ${EMQX_DEFAULT_USER_PASSWORD} ✅"
done



#API Password
random_str=$(rand-str 20)
printf "\n\n🔐 Necesitamos crear una clave para la API de EMQX \n"
while [[ -z "$EMQX_DEFAULT_APPLICATION_SECRET" ]]
do
  read -p "   EMQX API Password $(tput setaf 128)(${random_str})$(tput setaf 7): "  EMQX_DEFAULT_APPLICATION_SECRET
  EMQX_DEFAULT_APPLICATION_SECRET=${EMQX_DEFAULT_APPLICATION_SECRET:-${random_str}}
  echo "      Selected EMQX API Password ► ${EMQX_DEFAULT_APPLICATION_SECRET} ✅"
done



random_str=$(rand-str 20)
#MQTT SUPERUSER NAME
printf "\n\n👤 Necesitamos crear un superusuario para MQTT \n"
printf "   Estas credenciales te permitirán conectarte con privilegios totales al broker mqtt. \n"
printf "   Podrás publicar o suscribirte a cualquier tópico \n"
while [[ -z "$EMQX_NODE_SUPERUSER_USER" ]]
do
  read -p "   MQTT Superuser Name $(tput setaf 128)(${random_str})$(tput setaf 7): "  EMQX_NODE_SUPERUSER_USER
  EMQX_NODE_SUPERUSER_USER=${EMQX_NODE_SUPERUSER_USER:-${random_str}}
  echo "      Selected MQTT Superuser Name ► ${EMQX_NODE_SUPERUSER_USER} ✅"
done



#MQTT SUPERUSER PASSWORD
random_str=$(rand-str 20)
printf "\n\n🔐 Necesitamos crear la clave del superusuario MQTT \n"
while [[ -z "$EMQX_NODE_SUPERUSER_PASSWORD" ]]
do
  read -p "   MQTT Superuser Name $(tput setaf 128)(${random_str})$(tput setaf 7): "  EMQX_NODE_SUPERUSER_PASSWORD
  EMQX_NODE_SUPERUSER_PASSWORD=${EMQX_NODE_SUPERUSER_PASSWORD:-${random_str}}
  echo "      Selected MQTT Superuser Password ► ${EMQX_NODE_SUPERUSER_PASSWORD} ✅"
done


#EMQX API WEBHOOK TOKEN
random_str=$(rand-str 20)
printf "\n\n🔐 Necesitamos crear el token que enviará los requests desde EMQX a nuestros Webhooks \n"

while [[ -z "$EMQX_API_TOKEN" ]]
do
  read -p "   EMQX API WEBHOOK TOKEN $(tput setaf 128) (${random_str})$(tput setaf 7): "  EMQX_API_TOKEN
  EMQX_API_TOKEN=${EMQX_API_TOKEN:-${random_str}}
  echo "      Selected EMQX API WEB TOKEN  ► ${EMQX_API_TOKEN} ✅"
done




## ______________________________
## FRONT

#DOMAIN 
printf "\n\n🌐 Ingresa el dominio a donde se alojará este servicio. \n"
printf "   Si todavía no tienes uno podrás ingresar la ip fija del VPS a donde lo estés instalando. \n"
printf "   Luego podrás cambiarlo desde las variables de entorno. \n"

while [[ -z "$DOMAIN" ]]
do
  read -p "   (No http, No www | ex.-> mydomain.com) Dominio: "  DOMAIN
  echo "         Selected Domain ► ${DOMAIN} ✅"
done



#SSL?
printf "\n\n🔐 El sistema está pensado para que un balanceador de cargas gestione los certificados SSL. \n"
printf "   Si la plataforma estará bajo SSL utilizando balanceador de cargas o proporcionando certificados, selecciona 'Con SSL'. \n"
printf "   Esto forzará la redirección SSL, además, el cliente web, se conectará al broker mqtt mediante websocket seguro. \n"
printf "   Si de momento vas a acceder a la plataforma usando una ip, o un dominio sin ssl... selecciona 'Sin SSL'. \n\n"



PS3='   SSL?: '
options=("Con SSL" "Sin SSL")
select opt in "${options[@]}"
do
    case $REPLY in
        "1")
            echo "         SSL? ► ${character} ✅"
            break
            ;;
        "2")
            echo "         SSL? ► ${character} ✅"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


SSL=$REPLY
WSPREFIX=""
if [[ $SSL -eq 1 ]]
  then
    SSL="https://"
    WSPREFIX="ws://"
  else
    SSL="http://"
    WSPREFIX="wss://"
fi

msg="
   __                                      
  /__\ ___  ___ _   _ _ __ ___   ___ _ __  
 / \/// _ \/ __| | | | '_ \` _ \ / _ \ '_ \ 
/ _  \  __/\__ \ |_| | | | | | |  __/ | | |
\/ \_/\___||___/\__,_|_| |_| |_|\___|_| |_|                                                                                                                           
"

tput setaf 128;
printf "$msg"
tput setaf 7;

printf "\n\n\n"
printf "   🟢 TIMEZONE: $(tput setaf 128)${TZ}$(tput setaf 7)\n"
printf "   🟢 MONGO USER: $(tput setaf 128)${MONGO_USERNAME}$(tput setaf 7)\n"
printf "   🟢 MONGO PASS: $(tput setaf 128)${MONGO_PASSWORD}$(tput setaf 7)\n"
printf "   🟢 MONGO PORT: $(tput setaf 128)${MONGO_PORT}$(tput setaf 7)\n"
printf "   🟢 EMQX API PASSWORD: $(tput setaf 128)${EMQX_DEFAULT_APPLICATION_SECRET}$(tput setaf 7)\n"
printf "   🟢 MQTT SUPERUSER: $(tput setaf 128)${EMQX_NODE_SUPERUSER_USER}$(tput setaf 7)\n"
printf "   🟢 MQTT SUPER PASS: $(tput setaf 128)${EMQX_NODE_SUPERUSER_PASSWORD}$(tput setaf 7)\n"
printf "   🟢 EMQX API WEB TOKEN: $(tput setaf 128)${EMQX_API_TOKEN}$(tput setaf 7)\n"
printf "   🟢 DOMAIN: $(tput setaf 128)${DOMAIN}$(tput setaf 7)\n"
printf "   🟢 SSL?: $(tput setaf 128)${opt}$(tput setaf 7)\n"

printf "\n\n\n\n";
read -p "Presiona Enter para comenzar la instalación..."
sleep 2


## ______________________________
## INSALL INIT
filename='.appenv'



echo "environment=prod" >> $filename
echo "" >> $filename
echo "API_PORT:3001" >> $filename
echo "" >> $filename
echo "# M O N G O" >> $filename
echo "MONGO_USERNAME=${MONGO_USERNAME}" >> $filename
echo "MONGO_PASSWORD=${MONGO_PASSWORD}" >> $filename
echo "MONGO_HOST=mongo" >> $filename
echo "MONGO_PORT=${MONGO_PORT}" >> $filename
echo "MONGO_DATABASE=ioticos_god_level" >> $filename 
echo "" >> $filename
echo "# F R O N T" >> $filename
echo "APP_PORT=3000" >> $filename
echo "${SSL}${DOMAIN}:3001/api" >> $filename
echo "MQTT_PORT=8083" >> $filename
echo "EMQX_RESOURCES_DELAY=30000" >> $filename


filename='.servicesenv'

#SERVICES .ENV
echo "environment=prod" >> $filename
echo "" >> $filename
echo "# TIMEZONE (all containers)." >> $filename
echo "TZ=${TZ}" >> $filename
echo "" >> $filename
echo "# M O N G O" >> $filename
echo "MONGO_USERNAME=${MONGO_USERNAME}" >> $filename
echo "MONGO_PASSWORD=${MONGO_PASSWORD}" >> $filename
echo "MONGO_EXT_PORT=${MONGO_PORT}" >> $filename
echo "" >> $filename
echo "# E M Q X" >> $filename
echo "EMQX_DEFAULT_USER_PASSWORD=${EMQX_DEFAULT_USER_PASSWORD}" >> $filename
echo "EMQX_DEFAULT_APPLICATION_SECRET=${EMQX_DEFAULT_APPLICATION_SECRET}" >> $filename


sudo apt-get update
wget https://get.docker.com/
sudo mv index.html install_docker.sh
sudo chmod 777 install_docker.sh
sudo ./install_docker.sh
sudo rm install_docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo git clone https://github.com/ioticos/ioticos_god_level_services.git
sudo mv ioticos_god_level_services ioticos


cd ioticos

sudo git clone https://github.com/ioticos/ioticos_god_level_app.git
sudo mv ioticos_god_level_app  app
sudo docker-compose -f docker_node_install.yml up -d

cd ..

sudo docker-compose -f docker-compose-production.yml  up -d










