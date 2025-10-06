# n8n Docker Setup

Este repositório contém uma configuração completa do n8n usando Docker, pronta para uso em desenvolvimento e produção.

## 📋 Pré-requisitos

- Docker
- Docker Compose (ou `docker compose` plugin)
- Git

## 🚀 Quick Start

### 1. Clone o repositório
```bash
git clone https://github.com/PeSzpak/n8n-docker.git
cd n8n-docker
```

### 2. Configure as variáveis de ambiente
```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:
- `N8N_USER`: Seu email para login
- `N8N_PASSWORD`: Sua senha (use uma senha forte!)
- `N8N_ENCRYPTION_KEY`: Chave para criptografia (mude em produção!)

### 3. Inicie o n8n
```bash
docker compose up -d
```

### 4. Acesse o n8n
Abra seu navegador e acesse: [http://localhost:5678](http://localhost:5678)

## 📁 Estrutura do Projeto

```
.
├── docker-compose.yml      # Configuração do Docker Compose
├── .env.example           # Exemplo de variáveis de ambiente
├── .env                   # Suas variáveis de ambiente (não versionado)
├── Makefile              # Comandos úteis
├── workflows/            # Workflows exportados do n8n (versionados)
├── scripts/              # Scripts auxiliares
├── configs/              # Arquivos de configuração
├── templates/            # Templates reutilizáveis
├── docs/                 # Documentação adicional
└── n8n_data/            # Dados persistentes do n8n (não versionado)
```

## 🔧 Comandos Úteis

### Usando Make (recomendado)
```bash
make start      # Inicia os containers
make stop       # Para os containers
make logs       # Mostra os logs
make restart    # Reinicia os containers
make clean      # Para e remove containers
```

### Usando Docker Compose diretamente
```bash
docker compose up -d        # Inicia em background
docker compose down         # Para e remove containers
docker compose logs -f      # Acompanha os logs
docker compose restart      # Reinicia os serviços
```

## 📤 Exportar/Importar Workflows

### Exportar workflows existentes
```bash
# Exporta todos os workflows para a pasta workflows/
docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/workflows_export/
cp n8n_data/workflows_export/* workflows/
```

### Importar workflows
```bash
# Copia workflows para dentro do container
docker cp workflows/ n8n:/home/node/.n8n/import/
# Importa workflows
docker exec n8n n8n import:workflow --input=/home/node/.n8n/import/ --separate
```

## 🔒 Segurança

- **Produção**: Altere `N8N_ENCRYPTION_KEY` para uma chave única e segura
- **Senhas**: Use senhas fortes e considere usar gerenciadores de senha
- **HTTPS**: Configure HTTPS em produção (não incluído neste setup)
- **Backup**: Faça backup regular do `n8n_data/database.sqlite`

## 🛠 Troubleshooting

### Container não inicia
1. Verifique se as portas 5678 estão livres: `lsof -i :5678`
2. Verifique os logs: `docker compose logs`
3. Reinicie o Docker se necessário

### Problemas de permissão
```bash
# Corrige permissões da pasta de dados
sudo chown -R 1000:1000 n8n_data/
```

### Reset completo
```bash
make clean
rm -rf n8n_data/
docker compose up -d
```

## 🌐 Variáveis de Ambiente

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `N8N_HOST` | Host do n8n | `localhost` |
| `N8N_USER` | Email para login | - |
| `N8N_PASSWORD` | Senha para login | - |
| `N8N_ENCRYPTION_KEY` | Chave de criptografia | - |
| `DB_SQLITE_POOL_SIZE` | Pool de conexões SQLite | `5` |
| `N8N_RUNNERS_ENABLED` | Ativar task runners | `true` |

## 📝 Contribuição

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🆘 Suporte

- [Documentação oficial do n8n](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Issues do projeto](https://github.com/PeSzpak/n8n-docker/issues)