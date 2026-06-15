# Repositório de Computação em Nuvem & DevOps

Este repositório reúne os projetos práticos desenvolvidos para a disciplina de Computação em Nuvem, focados na aplicação de **Infraestrutura como Código (IaC)**, **Automação de Configuração** e **Conteinerização** utilizando a nuvem da AWS.

A evolução do aprendizado está dividida e organizada em duas etapas principais:

---

## Projetos Desenvolvidos

### Trabalho 01 — Infraestrutura Tradicional com Banco de Dados
A primeira etapa foca no provisionamento de uma infraestrutura tradicional em nuvem (*bare-metal*), integrando uma camada de computação a um banco de dados gerenciado.
* **Infraestrutura:** Uma instância EC2 (Ubuntu) e um banco de dados relacional Amazon RDS (PostgreSQL 16) integrado na VPC padrão.
* **Automação:** Ansible utilizado para provisionar e configurar um servidor web NGINX clássico diretamente na máquina, publicando uma página HTML estática.

[Saiba mais](./trabalho-01/README.md)

---

### Trabalho 02 — Aplicação Conteinerizada com Docker & Proxy Reverso
A segunda etapa evolui a arquitetura para o modelo de microsserviços modernos, substituindo servidores físicos por contêineres isolados e independentes.
* **Infraestrutura:** Uma instância EC2 otimizada atuando estritamente como Host Docker. O banco de dados RDS foi removido para tornar a aplicação *stateless*.
* **Automação:** Ansible modificado para instalar o ecossistema Docker e gerenciar o ciclo de vida dos serviços.
* **Conteinerização:** Docker Compose orquestrando uma rede interna privada (`devops`) contendo 3 contêineres: um proxy reverso NGINX e duas instâncias de uma API dinâmica em Python Flask (*showip*).

[Saiba mais](./trabalho-02/README.md)

---

## Tecnologias e Conceitos Explorados

* **Provedor de Nuvem:** Amazon Web Services (AWS)
* **Infraestrutura como Código (IaC):** Terraform (Módulos reutilizáveis, Security Groups, EC2 e RDS)
* **Gerenciamento de Configuração:** Ansible (Playbooks, Roles estruturadas e Inventários Dinâmicos)
* **Conteinerização:** Docker, Dockerfile e Docker Compose
* **Desenvolvimento Web:** Python Flask, Gunicorn e NGINX Proxy Reverso

---

## Estrutura do Repositório

```bash
.
├── trabalho-01/     # Infraestrutura tradicional (EC2 + RDS + NGINX local)
│   ├── terraform/
│   └── ansible/
│
└── trabalho-02/     # Arquitetura conteinerizada (Docker + Compose + API Flask)
    ├── terraform/
    ├── ansible/
    └── arquivos_do_app/
```

---

## Observações Acadêmicas

Os projetos contidos neste repositório possuem finalidade puramente pedagógica e acadêmica, servindo para consolidar boas práticas de mercado no ciclo de vida de entrega de software (CI/CD), versionamento seguro, separação estrita de escopos de infraestrutura/aplicação e documentação técnica padronizada.
