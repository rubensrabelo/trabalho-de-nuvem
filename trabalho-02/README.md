# Trabalho de Computação em Nuvem

Projeto desenvolvido utilizando **Terraform** e **Ansible** para provisionamento e configuração automatizada de infraestrutura na AWS.

---

# Objetivo

O objetivo deste projeto é demonstrar a utilização de ferramentas de **Infraestrutura como Código (IaC)** e automação de configuração para provisionar um ambiente composto por:

* Uma instância EC2 na AWS;
* Um banco de dados PostgreSQL utilizando Amazon RDS;
* Um servidor NGINX instalado e configurado automaticamente via Ansible.

---

# Arquitetura

A infraestrutura provisionada é composta pelos seguintes recursos:

## Compute

* Instância EC2 Linux

## Rede e Segurança

* Security Group

  * SSH (porta 22)
  * HTTP (porta 80)
  * PostgreSQL (porta 5432)

## Banco de Dados

* Amazon RDS PostgreSQL 16
* DB Subnet Group utilizando a VPC padrão da AWS

## Configuração

Após a criação da infraestrutura pelo Terraform, o Ansible é responsável por:

* Atualizar os pacotes do sistema operacional;
* Instalar o NGINX;
* Iniciar e habilitar o serviço;
* Publicar uma página HTML personalizada.

---

# Estrutura do Projeto

```bash
.
├── README.md
├── .gitignore
│
├── docs/
│   └── SCRIPTS.md
│
├── scripts/
│   ├── deploy.sh
│   └── destroy.sh
│
├── terraform/
│   ├── README.md
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── main.tf
│   ├── terraform.tfvars
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── ec2/
│       ├── rds/
│       └── security-group/
│
└── ansible/
    ├── README.md
    ├── playbook.yml
    ├── nginx.yml
    ├── inventory.ini  
    └── ansible.cfg
```

> **Observação:** Os arquivos `inventory.ini` e `ansible.cfg` são gerados automaticamente pelos scripts `deploy.sh` e `destroy.sh`. Caso a execução seja realizada manualmente, eles deverão ser criados conforme a documentação em `docs/SCRIPTS.md`.

---

# Tecnologias Utilizadas

## Terraform

Responsável pelo provisionamento da infraestrutura AWS:

* EC2
* Security Group
* RDS PostgreSQL
* DB Subnet Group

Documentação específica:


[Saiba mais](./terraform/README.md)

---

## Ansible

Responsável pela configuração da instância EC2:

* Instalação do NGINX
* Configuração do serviço
* Criação da página inicial

Documentação específica:

[Saiba mais](./ansible/README.md)

---

# Pré-requisitos

Antes de executar o projeto, é necessário possuir:

* Conta AWS ou AWS Academy Lab
* AWS CLI configurada
* Terraform instalado
* Ansible instalado
* Chave SSH utilizada pela instância EC2
* Linux ou macOS (recomendado)

---

# Arquivos de Configuração

As variáveis do Terraform são definidas em:

```text
terraform/terraform.tfvars
```

Caso o arquivo não exista, copie o modelo:

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Depois edite os valores conforme necessário.

---

# Execução do Projeto

O projeto pode ser executado de duas formas:

## Utilizando os Scripts

Deploy completo:

```bash
./scripts/deploy.sh
```

Remoção completa:

```bash
./scripts/destroy.sh
```

---

## Execução Manual

Todos os comandos necessários para:

* Terraform
* Ansible
* Testes
* Verificação dos recursos
* Destruição da infraestrutura

estão documentados em:

[Saiba mais](docs/SCRIPTS.md)


---

# Fluxo de Execução

1. Configurar credenciais AWS;
2. Configurar variáveis do Terraform;
3. Executar Terraform;
4. Provisionar EC2 e RDS;
5. Obter o IP da EC2;
6. Executar o Ansible;
7. Instalar e configurar o NGINX;
8. Validar acesso via navegador;
9. Destruir a infraestrutura ao final dos testes.

---

# Resultados Esperados

Após a execução do projeto:

## EC2

Uma instância EC2 deve estar disponível e acessível via SSH.

## PostgreSQL

Uma instância Amazon RDS PostgreSQL deve estar disponível.

## NGINX

Ao acessar o IP público da EC2 no navegador:

```bash
http://IP_DA_EC2
```

deve ser exibida uma página HTML informando que o servidor foi provisionado com Terraform e configurado com Ansible.

---

# Observações

Este projeto possui finalidade acadêmica e foi desenvolvido para demonstrar:

* Infraestrutura como Código (IaC);
* Provisionamento automatizado com Terraform;
* Automação de configuração com Ansible;
* Modularização de projetos;
* Boas práticas de organização e documentação.

---

# Documentação Complementar

Documentação geral de execução:

[Saiba mais](./docs/SCRIPTS.md)


Documentação do Terraform:

[Sabia mais](terraform/README.md)


Documentação do Ansible:

[Sabia mais](ansible/README.md)
