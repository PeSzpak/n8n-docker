# Scripts

Scripts auxiliares do ambiente n8n. Rode a partir da raiz do repositório, com o container `n8n` de pé.

| Script | O que faz |
|---|---|
| `backup.sh [nome]` | Roda `export-workflows.sh`, copia `n8n_data/database.sqlite`, `n8n_data/config`, `workflows/`, `docker-compose.yml`, `.env.example` e `Makefile` e gera `<nome>.tar.gz` na raiz (padrão `backup-AAAAMMDD-HHMMSS`) |
| `export-workflows.sh` | Sobe o compose se o container não estiver rodando, exporta todos os workflows com `n8n export:workflow --backup` e copia os JSON para `workflows/` |

```bash
chmod +x scripts/*.sh
./scripts/backup.sh
```

O `.tar.gz` contém o banco SQLite do n8n, que guarda credenciais criptografadas: trate o arquivo como sensível.
