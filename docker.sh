#!/bin/bash

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Olá, te ajudarei a instalar nossa aplicação!"
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Primeiro irei atualizar os pacotes do seu sistema."
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Se o sistema operacional que você está utilizando for linux, será necessário informar sua senha SUDO agora."
sleep 2

sudo apt upgrade && sudo apt update -y

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0) $(tput setaf 10)Para utilizar nossa aplicação é necessário ter o Java instalado"
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0) $(tput setaf 10)Irei verificar se você já tem o Java."
sleep 2

java --version
if [ $? -eq 0 ]
then
    echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput sgr0)$(tput setaf 10)Você já tem o Java instalado!"
sudo apt install openjdk-17-jre -y #executa instalacao do java
fi #fecha o 2º if
    sleep 2

    echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Então iremos prosseguir com a instalação da DataSync..."
    sleep 2 

    echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Posso instalar a DataSync pra você? (Y/n)"
    read installDataSync
    if [ "$installDataSync" == "Y" ]
    then
        echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Irei iniciar a instalação..."
        sleep 2

        if [ -d "data-sync2" ]
        then
            echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)A pasta 'data-sync2' já existe. Atualizando..."
            cd DataSync2.0
            git pull
            cd ..
        else
            git clone https://github.com/Safe-Sync/DataSync2.0.git
		cd DataSync2.0/data-sync2
        fi
	
	cd DataSync2.0/data-sync2
        cd target

        chmod 777 data-sync2-1.0-jar-with-dependencies.jar
        sleep 2

        echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Obrigado por instalar a nossa aplicação!"
        sleep 2

        echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Você quer executar a aplicação agora? (Y/n)"
        read execDataSync
        if [ "$execDataSync" == "Y" ]
        then
            echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Iniciando a aplicação... Até logo!"
            sleep 2
            java -jar data-sync2-1.0-jar-with-dependencies.jar
        else
            echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Você pode iniciar a aplicação quando desejar! Até logo!"
            sleep 2
            exit 0
        fi
    else
        echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Tudo bem, você pode tentar instalar quando quiser. Até logo!"
        sleep 2
        exit 0
    fi
else
    echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Você pode voltar aqui quando quiser instalar. Até logo!"
    sleep 2
    exit 0
fi
