up:
	docker compose -f ./docker-compose.yml up -d

all: up

build-up:
	docker compose -f ./docker-compose.yml up --build -d

down:
	docker compose -f ./docker-compose.yml down

rebuild: down build-up

restart: down up

cert-gen:
	mkdir -p ./nginx/certs
	openssl genpkey -algorithm RSA -out ./nginx/certs/server.key
	openssl req -new -x509 -key ./nginx/certs/server.key -out ./nginx/certs/server.crt -days 365

clean:
	docker system prune -f