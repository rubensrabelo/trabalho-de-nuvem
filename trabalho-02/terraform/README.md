# Terraform

Este diretório contém toda a infraestrutura como código (Infrastructure as Code - IaC) utilizada para provisionar os recursos necessários na AWS.

O Terraform é responsável pela criação da infraestrutura, enquanto o Ansible é utilizado posteriormente para configurar o ambiente Docker e realizar o deploy da aplicação.

---

# Objetivo

Provisionar automaticamente os recursos necessários para o ambiente do projeto:

* Instância EC2 Linux (Ubuntu);
* Security Group configurado para tráfego web e gerencial.

---

# Recursos Provisionados

## EC2

Instância responsável por hospedar a infraestrutura Docker que será configurada posteriormente pelo Ansible.

Características:

* Sistema operacional Linux (Ubuntu)
* Tipo de instância `t2.micro`
* IP público exposto no output
* Acesso SSH utilizando chave privada
* Associada ao Security Group do projeto

---

## Security Group

Grupo de segurança utilizado para controlar o acesso à instância EC2.

Portas liberadas:

| Porta | Protocolo | Finalidade |
| ----- | --------- | ---------- |
| 22    | TCP       | SSH        |
| 80    | TCP       | HTTP (Tráfego da Aplicação / NGINX) |

*(Nota: O acesso ao banco de dados e a porta 5432 foram removidos nesta versão).*

---

## Estrutura do Diretório

```bash
terraform/
├── README.md
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfvars.example
│
└── modules/
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── security-group/
        ├── main.tf
        └── outputs.tf
```

*(Nota: O módulo `rds` foi completamente removido da estrutura do projeto).*

---

# Organização dos Módulos

## modules/ec2

Responsável pela criação da instância EC2.

Recursos:

* EC2 (`aws_instance`)
* Tags identificadoras
* Associação ao Security Group do projeto

Output:

```bash
public_ip
```

---

## modules/security-group

Responsável pela criação do Security Group da aplicação.

Regras configuradas:

* Entrada para SSH (22)
* Entrada para HTTP (80)
* Saída total liberada para a internet (`0.0.0.0/0`)

Output:

```bash
security_group_name
```

---

# Variáveis

As variáveis são declaradas em:

```bash
variables.tf
```

Os valores são definidos em:

```bash
terraform.tfvars
```

Exemplo:

```hcl
region        = "us-east-1"
ami           = "ami-091138d0f0d41ff90"
instance_type = "t2.micro"
key_name      = "vockey"
```

*(Nota: A variável `db_password` foi removida por não utilizarmos mais o RDS).*

---

# Arquivo de Exemplo

O projeto disponibiliza:

```bash
terraform.tfvars.example
```

Para criar sua configuração:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Depois edite os valores conforme necessário.

---

# Outputs

Após a execução do Terraform, o seguinte output estará disponível para integração com o inventário dinâmico do Ansible.

## IP Público da EC2

```bash
terraform output public_ip
```

Exemplo de retorno:

```bash
54.xxx.xxx.xxx
```

---

# Fluxo de Provisionamento

```bash
Terraform
│
├── Cria Security Group (Portas 22 e 80)
│
└── Cria EC2 (t2.micro Ubuntu)
```

Após o término do Terraform:

```bash
Terraform
    │
    ▼
Ansible
    │
    ├── Instala ecossistema Docker (Engine & Compose)
    ├── Copia arquivos locais para a EC2
    ├── Constrói imagem local da aplicação
    └── Inicializa contêineres via Docker Compose
```

---

# Arquivos Ignorados

Os seguintes arquivos não devem ser enviados para o repositório:

```bash
terraform.tfvars
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfplan
```

Esses arquivos já estão configurados no `.gitignore`.

---

# Execução

A documentação completa de execução encontra-se em:

[Saiba mais](../docs/SCRIPTS.md)

Nesse documento estão disponíveis:

* Inicialização do Terraform;
* Geração do plano;
* Aplicação da infraestrutura;
* Consulta de outputs;
* Testes;
* Destruição dos recursos.

---

# Execução Automatizada

O projeto possui scripts para automatizar todo o processo.

Provisionamento:

```bash
./scripts/deploy.sh
```

Destruição:

```bash
./scripts/destroy.sh
```

Esses scripts executam automaticamente:

* Terraform Init
* Terraform Fmt
* Terraform Validate
* Terraform Plan
* Terraform Apply
* Integração com Ansible
* Limpeza do ambiente

---

# Boas Práticas Utilizadas

* Modularização dos recursos;
* Remoção completa de recursos e variáveis obsoletas (RDS);
* Uso de variáveis externas para flexibilidade de infraestrutura;
* Uso de outputs para integração simplificada com o Ansible;
* Versionamento seguro de arquivos de estado;
* Infraestrutura reproduzível e previsível.

---

# Diferenças em Relação ao Trabalho Anterior

Para atender aos novos requisitos de conteinerização, as seguintes mudanças estruturais foram aplicadas nos arquivos do Terraform:

* **Remoção do Módulo RDS:** Toda a pasta `modules/rds/` foi excluída, eliminando o provisionamento do banco de dados PostgreSQL.
* **Simplificação do `main.tf` principal:** Foram removidas as chamadas para os blocos `aws_db_subnet_group` e `aws_db_instance`.
* **Ajuste no Security Group (`securitygroup.tf`):** A regra de ingresso que liberava a porta `5432` (PostgreSQL) foi removida. Apenas as portas `22` (SSH) e `80` (HTTP) permanecem ativas.
* **Limpeza de Variáveis (`variables.tf`):** A variável global `db_password` foi totalmente removida do escopo do projeto por se tornar obsoleta.
* **Ajuste nos Outputs (`outputs.tf`):** O output que exibia o `endpoint` do RDS foi removido, mantendo-se apenas o IP público da instância EC2.

---

# Documentação Relacionada

Documentação principal:

[Saiba mais](../README.md)

Documentação do Ansible:

[Saiba mais](../ansible/README.md)

Documentação da API:

[Sabia mais](arquivos_do_app/README.md)

Guia de execução:

[Saiba mais](../docs/SCRIPTS.md)
