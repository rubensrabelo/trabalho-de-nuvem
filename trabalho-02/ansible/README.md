# Ansible

Este diretório contém os arquivos responsáveis pela configuração automática da instância EC2 provisionada pelo Terraform.

O Ansible é utilizado para instalar e configurar o servidor NGINX após a criação da infraestrutura na AWS.

---

# Objetivo

Após o Terraform criar a instância EC2, o Ansible é responsável por:

* Conectar na EC2 via SSH;
* Atualizar o cache de pacotes do sistema;
* Instalar o NGINX;
* Iniciar o serviço;
* Habilitar a inicialização automática do NGINX;
* Criar uma página HTML personalizada.

Dessa forma, a responsabilidade do projeto fica dividida entre:

## Terraform

Provisionamento da infraestrutura:

* EC2
* Security Group
* RDS PostgreSQL
* DB Subnet Group

## Ansible

Configuração da instância:

* Instalação do NGINX
* Configuração do serviço
* Publicação da página web

---

# Estrutura do Diretório

```bash
meu-projeto-iac/
├── inventario.yml
├── playbook.yml
├── docker.yml
├── nginx.yml
└── roles/
    ├── docker_install/     # ROLE 1: Instala o motor do Docker
    │   └── tasks/
    │       └── main.yml
    └── app_deploy/         # ROLE 2: Copia os arquivos e sobe o Docker Compose
        ├── defaults/
        │   └── main.yml
        └── tasks/
            └── main.yml
```

---

# Arquivos

## playbook.yml

Playbook principal do projeto.

Responsável por executar o arquivo:

```yaml
- import_playbook: nginx.yml
```

---

## nginx.yml

Contém todas as tarefas executadas pelo Ansible:

* Atualização do cache do sistema;
* Instalação do NGINX;
* Inicialização do serviço;
* Habilitação do serviço no boot;
* Criação da página HTML.

---

## inventory.ini

Arquivo que contém os hosts gerenciados pelo Ansible.

Exemplo:

```ini
[ec2]
54.xxx.xxx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/usuario/Downloads/labsuser.pem
```

> **Observação:** Este arquivo não é versionado no repositório.
>
> * Na execução manual, deve ser criado conforme descrito em `docs/SCRIPTS.md`.
> * Na execução automatizada, é criado automaticamente pelo script `deploy.sh`.

---

## ansible.cfg

Arquivo de configuração do Ansible.

Exemplo:

```ini
[defaults]
host_key_checking = False
inventory = inventory.ini
```

> **Observação:** Este arquivo também é gerado automaticamente pelo script `deploy.sh` e removido pelo script `destroy.sh`.

---

# Fluxo de Execução

```text
Terraform
    │
    ├── Cria EC2
    ├── Cria Security Group
    └── Cria RDS
            │
            ▼
Ansible
    │
    ├── Conecta na EC2
    ├── Instala NGINX
    ├── Inicia serviço
    └── Cria página HTML
```

---

# Resultado Esperado

Após a execução do playbook:

* O NGINX estará instalado;
* O serviço estará em execução;
* O serviço será iniciado automaticamente após reboot;
* A página HTML personalizada estará disponível.

Acesso:

```bash
http://IP_DA_EC2
```

Página exibida:

```bash
Servidor NGINX rodando na AWS
Provisionado com Terraform e configurado com Ansible
```

---

# Execução

A documentação completa de execução do projeto encontra-se em:

[Saiba mais](docs/SCRIPTS.md)


Neste documento estão descritos:

* Configuração do ambiente;
* Criação do inventory;
* Testes de conectividade;
* Execução dos playbooks;
* Provisionamento com Terraform;
* Destruição da infraestrutura.

---

# Execução Automatizada

O projeto disponibiliza scripts para automatizar todo o processo.

Deploy completo:

```bash
./scripts/deploy.sh
```

Destruição completa:

```bash
./scripts/destroy.sh
```

Esses scripts realizam automaticamente:

* Provisionamento da infraestrutura;
* Geração do inventory;
* Configuração do Ansible;
* Instalação do NGINX;
* Limpeza do ambiente.

---

# Boas Práticas

* Não versionar arquivos contendo informações específicas do ambiente (`inventory.ini`);
* Não versionar chaves SSH (`*.pem`);
* Utilizar playbooks pequenos e organizados;
* Separar provisionamento (Terraform) de configuração (Ansible);
* Manter a documentação atualizada.

---

# Documentação Relacionada

Documentação principal:

[Saiba mais](../README.md)


Documentação do Terraform:

[Saiba mais](../terraform/README.md)

Guia de execução:

[Saiba mais](../docs/SCRIPTS.md)
