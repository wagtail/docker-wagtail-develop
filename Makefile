.PHONY: help
.DEFAULT_GOAL := help

help: ## ⁉️ - Display help comments for each make command
	@grep -E '^[0-9a-zA-Z_-]+:.*? .*$$'  \
		$(MAKEFILE_LIST)  \
		| awk 'BEGIN { FS=":.*?## " }; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'  \
		| sort

build: ## Build the backend Docker image
	docker-compose build web

start: ## Bring the backend Docker container up
	docker-compose up

stop: ## Stop the backend Docker container
	docker-compose stop

ssh: ## Enter the running backend Docker container for the wagtail bakery site
	docker-compose exec web bash

ssh-shell: ## Enter the running Docker container shell
	docker-compose exec web python manage.py shell

ssh-fe: ## Open a shell to work with the frontend code (Node/NPM)
	docker-compose exec frontend bash

ssh-wagtail: ## Enter the running Docker container for the wagtail development environment
	docker-compose exec -w /code/wagtail web bash

ssh-db: ## Open a PostgreSQL shell session
	docker-compose exec web python manage.py dbshell

down: ## Stop and remove all Docker containers
	docker-compose down

migrations: ## Make migrations to the wagtail bakery site
	docker-compose exec web python manage.py makemigrations

migrate: ## Migrate the wagtail bakery site migrations
	docker-compose exec web python manage.py migrate

test: ## Run all wagtail tests or pass in a file with `make test file=wagtail.admin.tests.test_name`
	docker-compose exec -w /code/wagtail web python runtests.py $(file) $(FILE)

format-wagtail: ## Format Wagtail repo
	docker-compose exec -w /code/wagtail web make format-server
	docker-compose exec frontend make format-client

lint-wagtail: ## Lint the Wagtail repo (server, client, docs)
	docker-compose exec -w /code/wagtail web make lint-server
	docker-compose exec -w /code/wagtail web make lint-docs
	docker-compose exec frontend make lint-client
