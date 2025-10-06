.PHONY: up down restart logs status shell clean

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

pull:
	docker compose pull n8n

status:
	docker compose ps
	docker stats --no-stream n8n

shell:
	docker compose exec n8n sh

clean:
	docker compose down -v
	docker system prune -f