# Scripts

Esta pasta contém scripts auxiliares para automação e manutenção do ambiente n8n.

## Scripts disponíveis

### Backup e Restore

- `backup.sh` - Script para backup completo dos dados
- `restore.sh` - Script para restaurar backup

### Manutenção

- `export-workflows.sh` - Exporta todos os workflows
- `import-workflows.sh` - Importa workflows desta pasta
- `cleanup.sh` - Limpeza de arquivos temporários

### Monitoramento

- `health-check.sh` - Verifica se o n8n está funcionando
- `logs.sh` - Mostra logs formatados

## Como usar

Torne os scripts executáveis:
```bash
chmod +x scripts/*.sh
```

Execute um script:
```bash
./scripts/backup.sh
```