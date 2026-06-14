#!/bin/bash

set -e

echo ""
echo "=================================="
echo "Terraform Destroy"
echo "=================================="
echo ""

cd terraform

echo "Inicializando Terraform..."
terraform init

echo ""
echo "Gerando plano de destruição..."

terraform plan -destroy -out=destroy.tfplan

echo ""
echo "Executando destruição..."

terraform apply -auto-approve destroy.tfplan

echo ""
echo "Removendo arquivos temporários..."

rm -rf .terraform

rm -f .terraform.lock.hcl
rm -f terraform.tfstate
rm -f terraform.tfstate.backup

rm -f tfplan
rm -f destroy.tfplan

cd ..

echo ""
echo "Removendo arquivos gerados pelo Ansible..."

rm -f ansible/inventory.ini
rm -f ansible/ansible.cfg

echo ""
echo "=================================="
echo "Infraestrutura removida"
echo "Ambiente limpo"
echo "=================================="