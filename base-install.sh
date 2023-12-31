#!/bin/bash

echo "Script de Instalação Básica Mobile"
echo "Atualizado em 15/06/2023 - Rafael Gonçalves"
echo "--------------------------------------------------------------------"

# Yes automático e diminui a saída pra facilitar o debug de erros
APT_FLAGS=" -y -qq "

# Partição do Linux
OS=$(lsb_release -i -s)

function remove () {
	npm uninstall -g expo-cli
	sudo apt-get purge --auto-remove nodejs
}

#
function checkout () {
	programas=('node' 'npm' 'expo-cli')
	
	for cmd in "${programas[@]}"; do
	
 		${cmd} --version &> /dev/null
		if [ $? -eq 0 ]; then
		    echo ">> ${cmd} está instalado"
		    ${cmd} --version

		else
		    echo "# ${cmd} não está instalado, remova tudo e instale denovo para garantir a corretude"
		fi
        
        	echo
    	done
}

function helpMsg () {
	echo -e "COMO USAR: sudo $0 <flag>"
	echo -e "[Opções]: "
	echo -e "\t-r --remove: remove todas as depêndencias instaladas"
	echo -e "\t-h --help: Exibe esta mensagem de ajuda"
	echo -e "\t-c --checkout: Testa se os programas estão instalados "
}

#########################################################################################

# verifica se o script foi rodado com sudo
if [ "$EUID" -ne 0 ]; then
    echo "# Por gentileza, execute como root."
    echo
    exit
fi

	
for var in "$@"; do
	# Desinstalar Expo e o NodeJS
    	if [[ ${var} = "-r" ]] || [[ ${var} = "--remove" ]]; then
		remove
		exit
    	# Consultar a instlação
    	elif [[ ${var} = "-c" ]] || [[ ${var} = "--checkout" ]]; then
    		checkout
		exit
	
	# Aperece a tabela com os comandos
    	elif [[ ${var} = "-h" ]] || [[ ${var} = "--help" ]]; then
    		helpMsg
		exit
	fi
done

echo "Iniciando instalação"
echo "Isso pode demorar alguns minutos..."
echo

# Atualizações básicas
echo "Atualizando a sua maquina"
apt-get ${APT_FLAGS} update && apt-get ${APT_FLAGS} upgrade

echo
# instalando o nodejs e suas dependencias
echo "Instalando o NodeJS 20.x"
echo

if   [[ OS -eq 'Ubuntu' ]] || [[ OS -eq 'LinuxMint' ]]; then
    	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
	sudo apt-get install -y nodejs

elif [[ OS -eq 'Debian' ]]; then
   	curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
	apt-get install -y nodejs
	
else 
    	echo "Seu sistema não é compatível com esse script"
    	exit
fi

# instalando Expo 
echo
echo "Instalando o Expo"
echo
npm install --global expo-cli

# instalando @expo/ngrok@^4.1.0 (verei se realmente precisa)
# sudo npm install @expo/ngrok@^4.1.0

echo
echo "<3 <3 <3 Aparentemente tudo certo <3 <3 <3"
