# Ansible

Este diretório contém os arquivos responsáveis pela configuração automatizada da instância EC2 e pelo deploy da aplicação conteinerizada divididos em papéis estruturados (`roles`).

O Ansible é utilizado para preparar o ambiente (Engine do Docker) e orquestrar a inicialização dos contêineres após a criação da infraestrutura na AWS via Terraform.

---

# Objetivo

Após o Terraform criar a instância EC2, o Ansible assume o controle para realizar as seguintes operações divididas por responsabilidade:

* **Role `docker_install`**: Instala e configura o ecossistema Docker (`docker-ce`, `docker-ce-cli`, `containerd.io` e `docker-compose-plugin`) e adiciona o usuário `ubuntu` ao grupo do Docker.
* **Role `app_deploy`**: Copia os arquivos locais do projeto, constrói a imagem Docker customizada em Python (*showip*) e gerencia a inicialização dos serviços via Docker Compose.

---

# Estrutura do Diretório

A organização atual das receitas e automações segue a estrutura abaixo:

```bash
.
├── docker.yml
├── inventory.yml
├── nginx.yml
├── playbook.yml
├── README.md
└── roles
    ├── app_deploy
    │   ├── defaults
    │   │   └── main.yml
    │   └── tasks
    │       └── main.yml
    └── docker_install
        └── tasks
            └── main.yml
```

> **Aviso Importante:** Os arquivos `inventory.ini` e `ansible.cfg` são gerados automaticamente pelo script `deploy.sh` na raiz do projeto. Caso você opte por realizar a execução de forma manual, esses arquivos deverão ser criados e configurados manualmente na raiz deste diretório conforme detalhado na documentação contida em `docs/SCRIPTS.md`.

---

# Arquivos e Componentes

## playbook.yml
O arquivo principal de execução. Ele atua como um orquestrador de alto nível, importando os playbooks específicos na ordem cronológica correta para garantir que a aplicação só seja implantada após o motor do Docker estar pronto.

```yaml
- import_playbook: docker.yml
- import_playbook: nginx.yml
```

## docker.yml
Playbook intermediário responsável por aplicar as configurações de infraestrutura do Docker na instância chamando a role correspondente:

```yaml
- name: Instalar Docker
  hosts: ec2
  become: true
  roles:
    - docker_install
```

## nginx.yml
Playbook intermediário responsável por gerenciar o deploy da aplicação e do proxy reverso chamando a role de implantação:

```yaml
- name: Deploy da Aplicacao
  hosts: ec2
  become: true
  roles:
    - app_deploy
```

## roles/docker_install/tasks/main.yml
Contém as tarefas de sistema operacional executadas pelo playbook `docker.yml`:
* Atualização dos caches de pacotes (`apt`).
* Instalação das chaves GPG e repositórios oficiais do Docker.
* Instalação dos pacotes de runtime e do `docker-compose-plugin`.
* Configuração do usuário padrão `ubuntu` no grupo Unix `docker` para evitar a necessidade de privilégios de `sudo`.

## roles/app_deploy/tasks/main.yml
Gerencia o ciclo de vida e deploy da aplicação executado pelo playbook `nginx.yml`:
* Transferência dos arquivos necessários (`Dockerfile`, `requirements.txt`, códigos Flask, arquivo de proxy do NGINX e o `docker-compose.yml`) do ambiente local para o servidor de nuvem.
* Execução do build local da imagem customizada (`showip:latest`).
* Inicialização da stack de microsserviços em background com o comando `docker compose up -d`.

---

# Fluxo de Execução

```text
Terraform
    │
    └── Cria EC2 (Ubuntu) e Security Group (Portas 22 e 80)
            │
            ▼
Ansible (playbook.yml)
    │
    ├── Importa docker.yml ─── [Role: docker_install] ── Instala o Engine do Docker na EC2
    └── Importa nginx.yml  ─── [Role: app_deploy]     ── Envia arquivos e sobe o Docker Compose
```

---

# Resultado Esperado

Após a execução bem-sucedida do playbook, três contêineres estarão em execução na rede virtual isolada `devops`:
* O contêiner `nginx` escutando e gerenciando os acessos na porta pública 80.
* Os contêineres `app1` e `app2` processando de forma independente o backend em Python.

Acesso para validação:
```bash
curl http://<IP_DA_EC2>/app1
curl http://<IP_DA_EC2>/app2
```
O retorno em ambas as URLs deve exibir **endereços IPs internos diferentes**, validando o isolamento de rede e a correta distribuição efetuada pelo proxy reverso do NGINX.

---

# Diferenças em Relação ao Trabalho Anterior

Para atender aos novos critérios de conteinerização do projeto, as seguintes atualizações estruturais foram implementadas nesta pasta:

* **Modularização com Roles:** A lógica do projeto foi completamente encapsulada em duas sub-roles (`docker_install` e `app_deploy`), limpando a raiz do projeto e seguindo as boas práticas oficiais do Ansible.
* **Evolução dos Playbooks de Raiz:** Os arquivos `docker.yml` e `nginx.yml` deixaram de executar tarefas diretas na máquina física (*bare-metal*). Agora, eles funcionam como pontes organizacionais para engatilhar as novas roles conteinerizadas.
* **Automação do Ciclo Docker:** O Ansible deixou de configurar páginas HTML estáticas locais. Agora, ele lida com a transferência de receitas de infraestrutura, automação de `docker build` e orquestração de microsserviços via Docker Compose.
* **Gestão de Grupos e Permissões:** Foi adicionada a tratativa de usuários para o ecossistema Docker, garantindo que o deploy aconteça sem quebras de privilégios na EC2.

---

# Documentação Relacionada

Documentação principal:

[Saiba mais](../README.md)

Documentação do Terraform:

[Saiba mais](../terraform/README.md)

Documentação da API:

[Sabia mais](arquivos_do_app/README.md)

Guia de execução:

[Saiba mais](../docs/SCRIPTS.md)
