#!/bin/bash

# Script para backup completo do n8n
# Autor: PeSzpak  
# Uso: ./scripts/backup.sh [nome_backup]

BACKUP_NAME=${1:-"backup-$(date +%Y%m%d-%H%M%S)"}
BACKUP_DIR="backups/$BACKUP_NAME"

echo "🔄 Iniciando backup: $BACKUP_NAME"

# Cria diretório de backup
mkdir -p "$BACKUP_DIR"

# Exporta workflows
echo "📤 Exportando workflows..."
./scripts/export-workflows.sh

# Backup do banco de dados
echo "💾 Fazendo backup do banco de dados..."
cp n8n_data/database.sqlite "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  Arquivo database.sqlite não encontrado"

# Backup das configurações
echo "⚙️  Fazendo backup das configurações..."
cp n8n_data/config "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  Arquivo config não encontrado"

# Copia workflows exportados
echo "📋 Copiando workflows..."
cp -r workflows/ "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  Pasta workflows não encontrada"

# Copia arquivos de configuração do projeto
echo "🛠️  Copiando configurações do projeto..."
cp docker-compose.yml "$BACKUP_DIR/"
cp .env.example "$BACKUP_DIR/"
cp Makefile "$BACKUP_DIR/" 2>/dev/null || echo "⚠️  Makefile não encontrado"

# Cria arquivo de informações do backup
cat > "$BACKUP_DIR/backup-info.txt" << EOF
Backup criado em: $(date)
Nome do backup: $BACKUP_NAME
Container n8n: $(docker ps --filter name=n8n --format "{{.Status}}" 2>/dev/null || echo "Não encontrado")
Versão do n8n: $(docker exec n8n n8n --version 2>/dev/null || echo "Não disponível")
EOF

# Compacta o backup
echo "🗜️  Compactando backup..."
tar -czf "${BACKUP_NAME}.tar.gz" -C backups "$BACKUP_NAME"

# Remove pasta temporária
rm -rf "$BACKUP_DIR"

echo "✅ Backup concluído: ${BACKUP_NAME}.tar.gz"
echo "📂 Localização: $(pwd)/${BACKUP_NAME}.tar.gz"