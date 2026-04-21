PYTHON ?= python3
API_DIR := api
WEB_DIR := web

.PHONY: help api-install api-run api-test web-install web-run web-build web-test install test run dev docker-up docker-down

help:
	@echo "Targets available:"
	@echo "  make install     - Install API and web dependencies"
	@echo "  make run         - Show run commands for API and web"
	@echo "  make test        - Run API and web tests"
	@echo "  make api-install - Install API dependencies"
	@echo "  make api-run     - Run FastAPI with reload"
	@echo "  make api-test    - Run API tests"
	@echo "  make web-install - Install web dependencies"
	@echo "  make web-run     - Run web dev server"
	@echo "  make web-build   - Build web"
	@echo "  make web-test    - Run web tests"
	@echo "  make dev         - Run API and web together"
	@echo "  make docker-up   - Start Docker Compose"
	@echo "  make docker-down - Stop Docker Compose"

api-install:
	cd $(API_DIR) && $(PYTHON) -m pip install -r requirements.txt

api-run:
	cd $(API_DIR) && $(PYTHON) -m app.run

api-test:
	cd $(API_DIR) && pytest -q

web-install:
	cd $(WEB_DIR) && bun install

web-run:
	cd $(WEB_DIR) && bun run dev

web-build:
	cd $(WEB_DIR) && bun run build

web-test:
	cd $(WEB_DIR) && bun run test

install: api-install web-install

test: api-test web-test

run:
	@echo "Run API: cd api && python3 -m app.run"
	@echo "Run WEB: cd web && bun run dev"

dev:
	@$(MAKE) -j2 api-run web-run

docker-up:
	docker compose up --build

docker-down:
	docker compose down
