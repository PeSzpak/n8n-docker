.PHONY: up down restart logs status shell clean diagnostico logs-nginx logs-n8n

up:
	@echo "🚀 Subindo containers..."
	docker compose up -d
	@echo "✅ Containers iniciados!"
	@echo "   - Nginx Admin: http://localhost:81"
	@echo "   - n8n Direto:  http://localhost:5678"

down:
	@echo "🛑 Parando containers..."
	docker compose down

restart:
	@echo "🔄 Reiniciando containers..."
	docker compose restart

logs:
	@echo "📋 Logs de todos os containers..."
	docker compose logs -f

logs-nginx:
	@echo "📋 Logs do Nginx Proxy Manager..."
	docker compose logs app -f

logs-n8n:
	@echo "📋 Logs do n8n..."
	docker compose logs n8n -f

pull:
	@echo "⬇️  Baixando última versão do n8n..."
	docker compose pull n8n

status:
	@echo "📊 Status dos containers..."
	docker compose ps
	@echo ""
	@echo "📈 Uso de recursos..."
	docker stats --no-stream n8n nginx-proxy

shell:
	@echo "🐚 Abrindo shell no container n8n..."
	docker compose exec n8n sh

diagnostico:
	@echo "🔍 Executando diagnóstico completo..."
	@./diagnostico.sh

clean:
	@echo "🧹 Limpando tudo..."
	docker compose down -v
	docker system prune -f
	@echo "✅ Limpeza concluída!"

help:
	@echo "📖 Comandos disponíveis:"
	@echo "  make up          - Sobe os containers"
	@echo "  make down        - Para os containers"
	@echo "  make restart     - Reinicia os containers"
	@echo "  make logs        - Ver logs de todos"
	@echo "  make logs-nginx  - Ver logs do Nginx"
	@echo "  make logs-n8n    - Ver logs do n8n"
	@echo "  make status      - Ver status e recursos"
	@echo "  make diagnostico - Diagnóstico completo"
	@echo "  make shell       - Abrir shell no n8n"
	@echo "  make clean       - Limpar tudo"
	@echo "  make pull        - Atualizar imagem do n8n"