## Conteúdo do arquivo `docs/terraform-comandos.md`

# Comandos Terraform - Guia Completo

Este documento reúne os principais comandos utilizados no projeto Terraform.

---

## 1. Inicializar o Terraform

Baixa os providers e prepara o ambiente:

```bash
terraform init
````

---

## 2. Formatar arquivos

Padroniza todos os arquivos `.tf`:

```bash
terraform fmt -recursive
```

---

## 3. Validar configuração

Verifica erros de sintaxe:

```bash
terraform validate
```

---

## 4. Criar plano de execução

Gera e salva o plano em um arquivo:

```bash
terraform plan -out=tfplan
```

---

## 5. Ver o plano gerado

Exibe o conteúdo do plano:

```bash
terraform show tfplan
```

---

## 6. Aplicar o plano

Executa exatamente o que foi planejado:

```bash
terraform apply -auto-approve tfplan
```

---

## 7. Ver outputs

Mostrar todos os outputs:

```bash
terraform output
```

Output específico:

```bash
terraform output ip_nginx
terraform output endpoint_postgres
```

---

## 8. Ver state

Listar recursos:

```bash
terraform state list
```

Detalhar recurso:

```bash
terraform state show <resource>
```

---

## 9. Atualizar state

Sincronizar estado com AWS:

```bash
terraform refresh
```

---

## 10. Destruir infraestrutura

Plano de destruição:

```bash
terraform plan -destroy -out=destroy.tfplan
```

Executar destruição:

```bash
terraform apply -auto-approve destroy.tfplan
```

Ou direto:

```bash
terraform destroy -auto-approve
```

---

## 11. Limpeza local

Remove arquivos locais do Terraform:

```bash
rm -rf .terraform
rm -f .terraform.lock.hcl
rm -f terraform.tfstate*
rm -f tfplan
rm -f destroy.tfplan
```