# Guia de Execução - Terraform + Ansible

Este documento apresenta a sequência completa de comandos para provisionar, configurar, validar e destruir a infraestrutura do projeto.

---

# 1. Pré-requisitos

Verifique se as ferramentas estão instaladas:

```bash
terraform --version
aws --version
ansible --version
ssh -V
```

---

# 2. Configurar credenciais AWS

Validar acesso à AWS:

```bash
aws sts get-caller-identity
```

Se necessário:

```bash
aws configure
```

---

# 3. Configurar variáveis do Terraform

Copiar o arquivo de exemplo:

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Editar:

```bash
nano terraform/terraform.tfvars
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

# 4. Configurar chave SSH

Verificar se a chave existe:

```bash
ls ~/Downloads/labsuser.pem
```

Ajustar permissões:

```bash
chmod 400 ~/Downloads/labsuser.pem
```

---

# 5. Entrar na pasta Terraform

```bash
cd terraform
```

---

# 6. Inicializar o Terraform

```bash
terraform init
```

---

# 7. Formatar arquivos

```bash
terraform fmt -recursive
```

---

# 8. Validar configuração

```bash
terraform validate
```

---

# 9. Gerar plano de execução

```bash
terraform plan -out=tfplan
```

---

# 10. Revisar o plano

```bash
terraform show tfplan
```

Verifique:

* EC2
* Security Group
* RDS PostgreSQL
* DB Subnet Group

---

# 11. Aplicar infraestrutura

```bash
terraform apply -auto-approve tfplan
```

---

# 12. Verificar outputs

Mostrar todos:

```bash
terraform output
```

Obter IP da EC2:

```bash
terraform output -raw ip_nginx
```

Obter endpoint do PostgreSQL:

```bash
terraform output -raw endpoint_postgres
```

Exemplo:

```text
ip_nginx = 54.xxx.xxx.xxx

endpoint_postgres =
instancia-postgres.xxxxxxxxx.us-east-1.rds.amazonaws.com:5432
```

---

# 13. Testar acesso SSH

Substitua pelo IP retornado:

```bash
ssh \
-i ~/Downloads/labsuser.pem \
ubuntu@IP_DA_EC2
```

Se conectar com sucesso:

```bash
exit
```

---

# 14. Voltar para a raiz do projeto

```bash
cd ..
```

---

# 15. Criar inventory do Ansible

Arquivo:

```text
ansible/inventory.ini
```

Conteúdo:

```ini
[ec2]
IP_DA_EC2 ansible_user=ubuntu ansible_ssh_private_key_file=/home/SEU_USUARIO/Downloads/labsuser.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
```

---

# 16. Criar configuração do Ansible

Arquivo:

```text
ansible/ansible.cfg
```

Conteúdo:

```ini
[defaults]
host_key_checking = False
inventory = inventory.ini
```

---

# 17. Testar comunicação do Ansible

```bash
ansible \
-i ansible/inventory.ini \
ec2 \
-m ping \
-e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"'
```

Resultado esperado:

```text
pong
```

---

# 18. Executar o Playbook

```bash
ansible-playbook \
-i ansible/inventory.ini \
ansible/playbook.yml \
-e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"'
```

---

# 19. Verificar NGINX

Abrir no navegador:

```text
http://IP_DA_EC2
```

Deve aparecer:

```text
Servidor NGINX rodando na AWS
Provisionado com Terraform e configurado com Ansible
```

---

# 20. Validar recursos criados

Verificar outputs:

```bash
cd terraform

terraform output
```

Verificar recursos no state:

```bash
terraform state list
```

---

# 21. Destruir a infraestrutura

Entrar na pasta Terraform:

```bash
cd terraform
```

Gerar plano de destruição:

```bash
terraform plan -destroy -out=destroy.tfplan
```

Aplicar destruição:

```bash
terraform apply -auto-approve destroy.tfplan
```

---

# 22. Limpar arquivos locais

```bash
rm -rf .terraform

rm -f .terraform.lock.hcl

rm -f terraform.tfstate
rm -f terraform.tfstate.backup

rm -f tfplan
rm -f destroy.tfplan
```

---

# 23. Remover arquivos gerados pelo Ansible

Na raiz do projeto:

```bash
rm -f ansible/inventory.ini
rm -f ansible/ansible.cfg
```

---

# Execução Automatizada

Caso deseje executar tudo automaticamente:

## Deploy

```bash
chmod +x scripts/deploy.sh

./scripts/deploy.sh
```

## Destroy

```bash
chmod +x scripts/destroy.sh

./scripts/destroy.sh
```

Esses scripts executam automaticamente todos os passos descritos neste guia.
