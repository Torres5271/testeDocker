#!/bin/bash

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Olá, te ajudarei a instalar nossa aplicação!"
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Primeiro irei atualizar os pacotes do seu sistema."
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Se o sistema operacional que você está utilizando for linux, será necessário informar sua senha SUDO agora."
sleep 2

sudo apt upgrade && sudo apt update -y

echo "Instalando o Docker..."
if ! command -v docker &> /dev/null; then
    if [ -x "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install -y docker.io
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y docker
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y docker
    else
        echo "Não foi possível instalar o Docker. Verifique o gerenciador de pacotes do seu sistema."
        exit 1
    fi
fi
sudo docker run -d --safesync -e MYSQL_USER=aluno -e MYSQL_PASSWORD=sptech -p 3306:3306 mysql:latest

sudo docker exec -i meu-banco mysql -u aluno -p < comandos.sql

CREATE TABLE IF NOT EXISTS empresas (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nomeFantasia VARCHAR(100) NOT NULL,
    razaoSocial VARCHAR(100) NOT NULL,
    cnpj CHAR(18) NOT NULL UNIQUE,
    cep CHAR(9) NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(10),
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    senhaEmpresa VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS funcionarios (
    idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nomeFuncionario VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    senha VARCHAR(20),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa) REFERENCES empresas(idEmpresa)
);

create table if not exists hardwares(
    id int primary key auto_increment,
    sistemaOperacional varchar(50),
    totalCpu double not null,
    totalDisco double NOT NULL,
    totalRam double not null,
    fkFuncionario int,
    foreign key (fkFuncionario) references funcionarios(idFuncionario)
);

create table volateis(
    id int primary key auto_increment,
    consumoCpu double not null,
    consumoDisco double not null,
    consumoRam double not null,
    totalJanelas int not null,
    dataHora datetime,
    fkHardware int,
    foreign key (fkHardware) references hardwares(id)
);

create table if not exists limitador(
    id int primary key auto_increment,
    tipoComponente varchar(45),
    min int,
    max int,
    fkEmpresa int not null,
    foreign key (fkEmpresa) references empresas(idEmpresa)
);

CREATE TABLE IF NOT EXISTS arquivos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_arquivo LONGTEXT NOT NULL,
    tipo_arquivo VARCHAR(100) NOT NULL,
    tamanho_arquivo INT NOT NULL,
    dados_arquivo LONGBLOB NOT NULL,
    data_upload TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fkFuncionario INT not null,
    FOREIGN KEY (fkfuncionario) REFERENCES funcionarios(idFuncionario)
);




echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0) $(tput setaf 10)Para utilizar nossa aplicação é necessário ter o Java instalado"
sleep 2

echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0) $(tput setaf 10)Irei verificar se você já tem o Java."
sleep 2

java -version 2>&1 | grep "openjdk" > /dev/null
if [ $? -eq 0 ]
then
    echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Você já tem o Java instalado!"
else
    echo "Java não instalado." # Exibe a mensagem no terminal
    echo "Gostaria de instalar o Java? [s/n]" # Exibe a mensagem no terminal
    read get # Variável que guarda a resposta do usuário
    if [ "$get" == "s" ]; then
        echo "$(tput setaf 5)[Instalador DataSync]: $(tput sgr0)$(tput setaf 10)Iniciando a instalação do Java..."
        sudo apt install openjdk-17-jre -y
    fi
fi
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
    echo "$(tput setaf 5)[Inst
