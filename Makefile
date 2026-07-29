.PHONY: help build up down logs test lint clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build all production Docker images
	docker compose -f docker-compose.prod.yml build

up: ## Start full production stack
	docker compose -f docker-compose.prod.yml up -d

down: ## Stop production stack
	docker compose -f docker-compose.prod.yml down -v

logs: ## Tail all logs
	docker compose -f docker-compose.prod.yml logs -f

test-backend: ## Run backend tests
	cd deliverables/backend && DATABASE_URL=$${DATABASE_URL:-sqlite:///test.db} DJANGO_SECRET_KEY=test-key python manage.py test

test-frontend: ## Run frontend checks
	cd deliverables/frontend && npx tsc --noEmit && npm run build

lint-backend: ## Lint backend
	cd deliverables/backend && pip install flake8 black && flake8 . --max-line-length=100 --exclude=migrations,__pycache__ && black --check --diff .

clean: ## Clean Docker artifacts
	docker compose -f docker-compose.prod.yml down -v
	docker system prune -f --all-volumes
