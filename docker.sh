#!/bin/bash

# Cores para as mensagens (opcional)
VERDE="\e[32m"
AMARELO="\e[33m"
NORMAL="\e[0m"

# Função para exibir mensagens com cor
print_msg() {
    echo -e "$1$2$NORMAL"
}

print_msg "$VERDE" "[Instalador DataSync]: Olá, te ajudarei a instalar nossa aplicação!"
sleep 2

print_msg "$VERDE" "[Instalador DataSync]: Primeiro, vou atualizar os pacotes do seu sistema."
sleep 2

# Verifica se o sistema é baseado no Debian (como o Ubuntu)
if [ -x "$(command -v apt)" ]; then
    sudo apt update -y
    sudo apt upgrade -y
elif [ -x "$(command -v dnf)" ]; then
    sudo dnf update -y
else
    print_msg "$AMARELO" "[Instalador DataSync]: Sistema não suportado. Verifique o gerenciador de pacotes do seu sistema."
    exit 1
fi

print_msg "$VERDE" "[Instalador DataSync]: Instalando o Docker..."
if ! command -v docker &> /dev/null; then
    if [ -x "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install -y docker.io
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y docker
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y docker
    else
        print_msg "$AMARELO" "[Instalador DataSync]: Não foi possível instalar o Docker. Verifique o gerenciador de pacotes do seu sistema."
        exit 1
    fi
fi

# Inicializa e habilita o serviço Docker
sudo systemctl start docker
sudo systemctl enable docker

# Instalação do Java
print_msg "$VERDE" "[Instalador DataSync]: Verificando se o Java está instalado..."
if ! command -v java &> /dev/null; then
    print_msg "$AMARELO" "Java não instalado."
    read -p "Gostaria de instalar o Java? (s/n) " installJava
    if [ "$installJava" == "s" ]; then
        print_msg "$VERDE" "Iniciando a instalação do Java..."
        if [ -x "$(command -v apt)" ]; then
            sudo apt install openjdk-17-jre -y
        elif [ -x "$(command -v dnf)" ]; then
            sudo dnf install java-17-openjdk -y
        else
            print_msg "$AMARELO" "[Instalador DataSync]: Não foi possível instalar o Java. Verifique o gerenciador de pacotes do seu sistema."
            exit 1
        fi
    else
        print_msg "$AMARELO" "[Instalador DataSync]: Java é necessário para a aplicação. A instalação foi cancelada."
        exit 1
    fi
fi

# Criação do banco de dados e tabelas
print_msg "$VERDE" "[Instalador DataSync]: Criando o banco de dados e tabelas..."
mysql -u aluno -psptech <<EOF
CREATE DATABASE IF NOT EXISTS safesync;
USE safesync;

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

CREATE TABLE IF NOT EXISTS hardwares (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sistemaOperacional VARCHAR(50),
    totalCpu DOUBLE NOT NULL,
    totalDisco DOUBLE NOT NULL,
    totalRam DOUBLE NOT NULL,
    fkFuncionario INT,
    FOREIGN KEY (fkFuncionario) REFERENCES funcionarios(idFuncionario)
);

CREATE TABLE IF NOT EXISTS volateis (
    id INT PRIMARY KEY AUTO_INCREMENT,
    consumoCpu DOUBLE NOT NULL,
    consumoDisco DOUBLE NOT NULL,
    consumoRam DOUBLE NOT NULL,
    totalJanelas INT NOT NULL,
    dataHora DATETIME,
    fkHardware INT,
    FOREIGN KEY (fkHardware) REFERENCES hardwares(id)
);

CREATE TABLE IF NOT EXISTS limitador (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipoComponente VARCHAR(45),
    min INT,
    max INT,
    fkEmpresa INT NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresas(idEmpresa)
);

CREATE TABLE IF NOT EXISTS arquivos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_arquivo LONGTEXT NOT NULL,
    tipo_arquivo VARCHAR(100) NOT NULL,
    tamanho_arquivo INT NOT NULL,
    dados_arquivo LONGBLOB NOT NULL,
    data_upload TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fkFuncionario INT NOT NULL,
    FOREIGN KEY (fkFuncionario) REFERENCES funcionarios(idFuncionario)
);

EOF

# Instalação do DataSync
print_msg "$VERDE" "[Instalador DataSync]: Iniciando a instalação do DataSync..."
sleep 2

# Verifica se o repositório DataSync já existe
if [ -d "DataSync2.0" ]; then
    print_msg "$VERDE" "[Instalador DataSync]: O repositório DataSync2.0 já existe. Atualizando..."
    cd DataSync2.0
    git pull
    cd ..
else
    git clone https://github.com/Safe-Sync/DataSync2.0.git
    cd DataSync2.0/data-sync2
fi

cd DataSync2.0/data-sync2/target

chmod
