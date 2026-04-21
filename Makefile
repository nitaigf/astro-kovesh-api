PYTHON ?= python3
API_DIR := api

.PHONY: help api-install api-run api-test install test run docker-up docker-down git-init git-remote-origin git-flow-init git-flow-feature-start git-flow-feature-finish git-flow-release-start git-flow-release-finish git-flow-hotfix-start git-flow-hotfix-finish

help:
	@echo "Targets available:"
	@echo "  make install     - Install API dependencies"
	@echo "  make run         - Show run commands for API"
	@echo "  make test        - Run API tests"
	@echo "  make api-install - Install API dependencies"
	@echo "  make api-run     - Run FastAPI with reload"
	@echo "  make api-test    - Run API tests"
	@echo "  make docker-up   - Start Docker Compose"
	@echo "  make docker-down - Stop Docker Compose"
	@echo "  make git-init                    - Initialize git repository"
	@echo "  make git-remote-origin ORIGIN_URL=git@github.com:user/repo.git"
	@echo "  make git-flow-init               - Initialize Git Flow defaults"
	@echo "  make git-flow-feature-start NAME=feature-name"
	@echo "  make git-flow-feature-finish NAME=feature-name"
	@echo "  make git-flow-release-start NAME=0.1.0"
	@echo "  make git-flow-release-finish NAME=0.1.0"
	@echo "  make git-flow-hotfix-start NAME=0.1.1"
	@echo "  make git-flow-hotfix-finish NAME=0.1.1"

api-install:
	cd $(API_DIR) && $(PYTHON) -m pip install -r requirements-dev.txt

api-run:
	cd $(API_DIR) && $(PYTHON) -m app.run

api-test:
	cd $(API_DIR) && pytest -q

install: api-install

test: api-test

run:
	@echo "Run API: cd api && python3 -m app.run"

docker-up:
	docker compose up --build

docker-down:
	docker compose down

git-init:
	git init

git-remote-origin:
	@test -n "$(ORIGIN_URL)" || (echo "Use ORIGIN_URL=git@github.com:user/repo.git" && exit 1)
	git remote add origin $(ORIGIN_URL)

git-flow-init:
	@command -v git-flow >/dev/null 2>&1 || (echo "git-flow not found. Install first (macOS: brew install git-flow-avh)" && exit 1)
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || (echo "Not a git repository. Run: make git-init" && exit 1)
	git flow init -d

git-flow-feature-start:
	@test -n "$(NAME)" || (echo "Use NAME=<feature-name>" && exit 1)
	git flow feature start $(NAME)

git-flow-feature-finish:
	@test -n "$(NAME)" || (echo "Use NAME=<feature-name>" && exit 1)
	git flow feature finish $(NAME)

git-flow-release-start:
	@test -n "$(NAME)" || (echo "Use NAME=<version> (ex: 0.1.0)" && exit 1)
	git flow release start $(NAME)

git-flow-release-finish:
	@test -n "$(NAME)" || (echo "Use NAME=<version> (ex: 0.1.0)" && exit 1)
	git flow release finish $(NAME)

git-flow-hotfix-start:
	@test -n "$(NAME)" || (echo "Use NAME=<version> (ex: 0.1.1)" && exit 1)
	git flow hotfix start $(NAME)

git-flow-hotfix-finish:
	@test -n "$(NAME)" || (echo "Use NAME=<version> (ex: 0.1.1)" && exit 1)
	git flow hotfix finish $(NAME)
