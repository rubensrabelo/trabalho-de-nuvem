# API — Aplicação Conteinerizada (showip)

Este diretório contém o código-fonte da aplicação Python (*showip*), as configurações do proxy reverso NGINX e as receitas de conteinerização responsáveis por empacotar e orquestrar os serviços na nuvem.

Toda a stack é transferida para a instância EC2 pelo Ansible e inicializada de forma isolada dentro de uma rede interna do Docker.

---

# Objetivo

Disponibilizar um serviço web resiliente e escalável que:
* Executa múltiplas instâncias independentes da aplicação Flask backend (*app1* e *app2*).
* Expõe publicamente apenas a porta HTTP 80 por meio do NGINX.
* Retorna o endereço IP interno do contêiner correspondente para validar o isolamento de rede e o balanceamento de carga.

---

# Estrutura do Diretório

A organização dos arquivos do aplicativo segue a estrutura abaixo:

```bash
arquivos_do_app/
├── Dockerfile
├── requirements.txt
├── wsgi.py
├── default.conf
├── docker-compose.yml
└── showip/
    └── __init__.py
```

---

# Arquivos e Componentes

## Dockerfile
Instruções de build para empacotamento da aplicação Python. Utiliza uma imagem leve (`python:3.10-alpine`) e configura o servidor de aplicação WSGI **Gunicorn** para rodar o Flask de forma estável em ambiente de produção.

## requirements.txt
Lista de dependências do ecossistema Python necessárias para a execução do projeto:
* `Flask` (Framework web corporativo).
* `gunicorn` (Servidor HTTP WSGI para produção).

## showip/\_\_init\_\_.py
Código-fonte da aplicação desenvolvido em Flask. Contém a rota principal que captura e retorna textualmente o endereço IP da interface de rede local interna do próprio contêiner.

## wsgi.py
Ponto de entrada oficial (*entrypoint*) da aplicação utilizado pelo Gunicorn para instanciar e servir o app Flask.

## default.conf
Arquivo de configuração do **NGINX**. Atua como Proxy Reverso escutando na porta 80 do host e mapeando os caminhos de URL da seguinte forma:
* Requisições para `/app1` são direcionadas internamente para o contêiner `app1`.
* Requisições para `/app2` são direcionadas internamente para o contêiner `app2`.

## docker-compose.yml
O manifesto de orquestração de toda a aplicação. Ele declara:
1. A rede isolada chamada `devops`.
2. O serviço `nginx` exposto na porta pública `80`.
3. Os serviços de backend `app1` e `app2` baseados na mesma imagem customizada local, operando sem exposição direta de portas para a internet.

---

# Fluxo de Inicialização na EC2

```text
Ansible (Role: app_deploy)
    │
    ├── 1. Copia a pasta 'arquivos_do_app/' para a EC2
    ├── 2. Executa o build da imagem customizada (showip:latest)
    └── 3. Dispara o Docker Compose em background
            │
            ▼
┌───────────────────────────────────────────────┐
│              Host Docker (EC2)                │
│  Rede Virtual: devops                         │
│                                               │
│   ┌─────────────┐   /app1   ┌─────────────┐   │
│   │   contêiner │ ────────▶ │  contêiner  │   │
│   │    nginx    │           │    app1     │   │
│   │  (Porta 80) │ ────────▶ ├─────────────┤   │
│   └─────────────┘   /app2   │  contêiner  │   │
│                             │    app2     │   │
│                             └─────────────┘   │
└───────────────────────────────────────────────┘
```

---

# Validação do Ambiente

Após o deploy, a API pode ser testada diretamente através do IP público da sua instância AWS:

```bash
curl http://<IP_PUBLICO_DA_EC2>/app1
curl http://<IP_PUBLICO_DA_EC2>/app2
```

### Comprovação de Sucesso:
Cada rota deve responder com sucesso (`200 OK`) exibindo uma string de IP interno diferente (ex: `172.18.0.3` e `172.18.0.4`). Isso garante que o NGINX está roteando o tráfego de maneira correta através da rede de contêineres `devops`.

---

# Diferenças em Relação ao Trabalho Anterior

* **Substituição da Página Estática por API:** O projeto deixou de servir um arquivo HTML plano e estático (`index.html`) diretamente na máquina física para fornecer uma API dinâmica em Python Flask.
* **Introdução da Conteinerização:** Toda a stack da aplicação agora roda empacotada em contêineres Docker, eliminando a instalação de pacotes como Python ou NGINX diretamente no sistema operacional do host da EC2.
* **Isolamento de Redes:** Criação de uma rede de microsserviços privada gerenciada pelo Docker Compose, impossibilitando acessos externos diretos aos backends (`app1` e `app2`) sem passar pelo crivo de segurança do proxy do NGINX.
* **Remoção de Persistência:** Eliminação completa de conexões e dependências de banco de dados (PostgreSQL/RDS), tornando a API totalmente *stateless*.

---

# Documentação Relacionada

Documentação principal:

[Saiba mais](../README.md)

Documentação do Terraform:

[Saiba mais](../terraform/README.md)

Documentação do Ansible:

[Saiba mais](../ansible/README.md)
