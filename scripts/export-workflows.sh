#!/bin/bash

# Script para exportar workflows do n8n
# Autor: PeSzpak
# Uso: ./scripts/export-workflows.sh

echo "🚀 Exportando workflows do n8n..."

# Verifica se o container está rodando
if ! docker ps | grep -q "n8n"; then
    echo "❌ Container n8n não está rodando. Iniciando..."
    docker compose up -d
    sleep 5
fi

# Cria diretório de export dentro do container
docker exec n8n mkdir -p /home/node/.n8n/workflows_export

# Exporta todos os workflows
echo "📤 Exportando workflows..."
docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/workflows_export/

# Cria pasta workflows se não existir
mkdir -p workflows

# Copia arquivos exportados para a pasta workflows
echo "📁 Copiando arquivos para pasta workflows/..."
cp n8n_data/workflows_export/* workflows/ 2>/dev/null || echo "Nenhum workflow encontrado"

# Lista arquivos exportados
echo "✅ Workflows exportados:"
ls -la workflows/*.json 2>/dev/null || echo "Nenhum arquivo JSON encontrado"

echo "🎉 Export concluído! Os workflows estão na pasta 'workflows/'"