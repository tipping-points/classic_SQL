.PHONY: up down restart clean logs

up:
	docker compose up

down:
	docker compose down

restart:
	docker compose down && docker compose up

logs:
	docker compose logs -f

clean:
	docker compose down --rmi local --volumes
