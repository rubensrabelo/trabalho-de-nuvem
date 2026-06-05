# Terraform AWS - Projeto Acadêmico

Este projeto utiliza **Terraform (Infrastructure as Code)** para provisionar infraestrutura na AWS de forma automatizada e modular.

---

## Objetivo

Demonstrar a criação e organização de infraestrutura na AWS utilizando:

- Infraestrutura como Código (IaC)
- Modularização no Terraform
- Uso de variáveis e outputs
- Boas práticas com arquivos `.tfvars`
- Estrutura de projeto profissional

---

## Recursos provisionados

### Compute
- EC2 (instância Linux para servidor Nginx)

### Rede e Segurança
- Security Group com regras:
  - SSH (22)
  - HTTP (80)
  - PostgreSQL (5432)

### Banco de Dados
- RDS PostgreSQL 16
- DB Subnet Group (usando subnets da VPC padrão da AWS)

---

## Estrutura do projeto

```text
.
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfvars.example
├── .gitignore
│
├── modules/
│   ├── ec2/
│   ├── rds/
│   └── security-group/
│
└── docs/
    └── SCRIPTS.md
````

---

## Variáveis

As variáveis são definidas em:

* `variables.tf`
* `terraform.tfvars`

### Exemplo:

```hcl
region        = "us-east-1"
ami           = "ami-091138d0f0d41ff90"
instance_type = "t2.micro"
key_name      = "vockey"
db_password   = "sua_senha_segura"
```

---

## Boas práticas de segurança

* `terraform.tfvars` está no `.gitignore`
* Nunca deve ser enviado ao repositório
* Senhas e credenciais devem ser protegidas
* Security Group apenas para ambiente acadêmico

---

## Variáveis de ambiente (opcional)

```bash
export TF_VAR_region="us-east-1"
export TF_VAR_ami="ami-091138d0f0d41ff90"
export TF_VAR_instance_type="t2.micro"
export TF_VAR_key_name="vockey"
export TF_VAR_db_password="sua_senha_segura"
```

---

## Como executar o projeto

Toda a sequência de comandos está documentada em:

👉 **[`docs/SCRIPTS.md`](docs/SCRIPTS.md)**

---

## Observação final

Este projeto foi desenvolvido para fins acadêmicos com foco em:

* Automação de infraestrutura na AWS
* Modularização com Terraform
* Organização profissional de projetos IaC
* Separação clara entre código e documentação