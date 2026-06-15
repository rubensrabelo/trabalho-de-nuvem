# Terraform

Este diretório contém toda a infraestrutura como código (Infrastructure as Code - IaC) utilizada para provisionar os recursos necessários na AWS.

O Terraform é responsável pela criação da infraestrutura, enquanto o Ansible é utilizado posteriormente para configurar a instância EC2.

---

# Objetivo

Provisionar automaticamente os recursos necessários para o ambiente do projeto:

* Instância EC2 Linux;
* Security Group;
* Banco de dados Amazon RDS PostgreSQL;
* DB Subnet Group.

---

# Recursos Provisionados

## EC2

Instância responsável por hospedar o servidor NGINX que será configurado posteriormente pelo Ansible.

Características:

* Sistema operacional Linux
* IP público
* Acesso SSH utilizando chave privada
* Associada ao Security Group do projeto

---

## Security Group

Grupo de segurança utilizado pela EC2 e pelo RDS.

Portas liberadas:

| Porta | Protocolo | Finalidade |
| ----- | --------- | ---------- |
| 22    | TCP       | SSH        |
| 80    | TCP       | HTTP       |
| 5432  | TCP       | PostgreSQL |

---

## Amazon RDS PostgreSQL

Banco de dados gerenciado pela AWS.

Características:

* PostgreSQL 16
* Instância `db.t3.micro`
* Armazenamento de 20 GB
* Subnet Group automático
* Associado ao Security Group do projeto

---

## DB Subnet Group

Utiliza automaticamente as subnets existentes na VPC padrão da AWS.

Necessário para a criação do banco de dados RDS.

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
    ├── rds/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── security-group/
        ├── main.tf
        └── outputs.tf
```

---

# Organização dos Módulos

## modules/ec2

Responsável pela criação da instância EC2.

Recursos:

* EC2
* Tags
* Associação ao Security Group

Output:

```bash
public_ip
```

---

## modules/security-group

Responsável pela criação do Security Group.

Regras configuradas:

* SSH (22)
* HTTP (80)
* PostgreSQL (5432)
* Saída liberada para internet

Output:

```bash
security_group_name
```

---

## modules/rds

Responsável pela criação do banco PostgreSQL.

Recursos:

* DB Subnet Group
* RDS PostgreSQL

Output:

```bash
endpoint
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
db_password   = "SenhaForte123!"
```

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

Após a execução do Terraform, os seguintes outputs estarão disponíveis.

## IP Público da EC2

```bash
terraform output ip_nginx
```

Exemplo:

```bash
54.xxx.xxx.xxx
```

---

## Endpoint do PostgreSQL

```bash
terraform output endpoint_postgres
```

Exemplo:

```bash
instancia-postgres.xxxxxxxxx.us-east-1.rds.amazonaws.com:5432
```

---

# Fluxo de Provisionamento

```bash
Terraform
│
├── Cria Security Group
│
├── Cria EC2
│
├── Obtém VPC padrão
│
├── Obtém Subnets padrão
│
├── Cria DB Subnet Group
│
└── Cria PostgreSQL RDS
```

Após o término do Terraform:

```bash
Terraform
    │
    ▼
Ansible
    │
    ├── Instala NGINX
    ├── Configura serviço
    └── Publica página HTML
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
* Separação de responsabilidades;
* Uso de variáveis externas;
* Uso de outputs para integração com Ansible;
* Versionamento seguro;
* Infraestrutura reproduzível;
* Estrutura organizada para manutenção futura.

---

# Documentação Relacionada

Documentação principal:

[Saiba mais](../README.md)

Documentação do Ansible:

[Saiba mais](../ansible/README.md)

Guia de execução:

[Saiba mais](../docs/SCRIPTS.md)
