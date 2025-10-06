# Workflows n8n

Esta pasta contém os workflows exportados do n8n em formato JSON.

## Como usar

### Importar workflows
Para importar estes workflows em uma nova instância do n8n:

```bash
# Método 1: Via interface web
# 1. Acesse http://localhost:5678
# 2. Vá em "Workflows"
# 3. Clique em "Import from File"
# 4. Selecione os arquivos .json desta pasta

# Método 2: Via linha de comando
docker cp workflows/ n8n:/home/node/.n8n/import/
docker exec n8n n8n import:workflow --input=/home/node/.n8n/import/ --separate
```

### Exportar novos workflows
Para adicionar novos workflows a esta pasta:

```bash
# Exporta todos os workflows
docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/workflows_export/
cp n8n_data/workflows_export/* workflows/

# Ou exportar workflow específico por ID
docker exec n8n n8n export:workflow --id=WORKFLOW_ID --output=/home/node/.n8n/workflow.json
cp n8n_data/workflow.json workflows/
```

## Estrutura dos Arquivos

Cada arquivo `.json` representa um workflow completo com:
- Configurações do workflow
- Nós e suas configurações
- Conexões entre os nós
- Credenciais (sem dados sensíveis)

## ⚠️ Importante

- Os arquivos aqui **NÃO** contêm credenciais sensíveis (senhas, tokens)
- Você precisará reconfigurar as credenciais após importar
- Mantenha esta pasta versionada para backup dos seus workflows