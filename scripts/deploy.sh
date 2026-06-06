#!/bin/bash

set -e

echo ""
echo "=================================="
echo "Terraform + Ansible Deploy"
echo "=================================="
echo ""

PEM_FILE="$HOME/Downloads/labsuser.pem"

if [ ! -f "$PEM_FILE" ]; then
    echo "ERRO: Chave SSH não encontrada:"
    echo "$PEM_FILE"
    exit 1
fi

chmod 400 "$PEM_FILE"

echo "Entrando na pasta terraform..."
cd terraform

echo ""
echo "Inicializando Terraform..."
terraform init

echo ""
echo "Formatando arquivos..."
terraform fmt -recursive

echo ""
echo "Validando configuração..."
terraform validate

echo ""
echo "Gerando plano..."
terraform plan -out=tfplan

echo ""
echo "Aplicando infraestrutura..."
terraform apply -auto-approve tfplan

echo ""
echo "Obtendo outputs..."

IP=$(terraform output -raw ip_nginx)
RDS_ENDPOINT=$(terraform output -raw endpoint_postgres)

echo ""
echo "IP da EC2: $IP"
echo "Endpoint RDS: $RDS_ENDPOINT"

cd ..

echo ""
echo "Criando configuração do Ansible..."

cat > ansible/ansible.cfg << EOF
[defaults]
host_key_checking = False
inventory = inventory.ini
EOF

echo ""
echo "Gerando inventory automaticamente..."

cat > ansible/inventory.ini << EOF
[ec2]
$IP ansible_user=ubuntu ansible_ssh_private_key_file=$PEM_FILE ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF

echo ""
echo "Aguardando a EC2 ficar acessível via SSH..."

SSH_OK=false

for i in {1..30}; do

    if ssh \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o ConnectTimeout=5 \
        -i "$PEM_FILE" \
        ubuntu@"$IP" "echo SSH_OK" >/dev/null 2>&1
    then
        SSH_OK=true
        echo "SSH disponível!"
        break
    fi

    echo "Tentativa $i/30..."
    sleep 10

done

if [ "$SSH_OK" = false ]; then
    echo ""
    echo "ERRO: Não foi possível conectar via SSH."
    echo ""
    echo "Teste manualmente:"
    echo "ssh -i $PEM_FILE ubuntu@$IP"
    exit 1
fi

echo ""
echo "Testando comunicação com Ansible..."

ANSIBLE_HOST_KEY_CHECKING=False \
ansible \
    -i ansible/inventory.ini \
    ec2 \
    -m ping

echo ""
echo "Executando playbook..."

ANSIBLE_HOST_KEY_CHECKING=False \
ansible-playbook \
    -i ansible/inventory.ini \
    ansible/playbook.yml

echo ""
echo "=================================="
echo "Deploy concluído com sucesso!"
echo "=================================="
echo ""

echo "NGINX:"
echo "http://$IP"
echo ""

echo "PostgreSQL:"
echo "$RDS_ENDPOINT"
echo ""