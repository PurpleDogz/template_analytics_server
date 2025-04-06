
# Use some sensible default shell settings
SHELL := /bin/bash
.ONESHELL:
.SILENT:

RED='\033[1;31m'
CYAN='\033[0;36m'
NC='\033[0m'

WORKING_DIR=/workspace/app

ifndef IMAGE_NAME
IMAGE_NAME=analytics-app
endif

ifndef IMAGE_TAG
IMAGE_TAG=latest
endif

export IMAGE_NAME_TAG = ${IMAGE_NAME}:${IMAGE_TAG}
export IMAGE_NAME_TAG_LATEST = ${IMAGE_NAME}:latest

export REVISION
export DEFAULT_DOCKER_REPO


.PHONY: install
install: ## Install the environment via npm
	@echo "🚀 Creating environment using npm"
	@npm install

.PHONY: check
check: ## Run code quality tools
	@echo "🚀 Checking..."
	@npm run lint
	@npm run typecheck

.PHONY: test
test: ## Run unit tests
	@echo "🚀 Run Tests"
	@npm test

.PHONY: run
run: ## Run the application
	@echo "🚀 Run"
	@npm run dev

.PHONY: build
build: ## Build the application distro folder
	@echo "🚀 Build the distro folder"
	@npm run build

.PHONY: build_image
build_image: build ## Build the docker image
	docker build --tag ${IMAGE_NAME_TAG} \
				 --build-arg REVISION=${REVISION} \
				 --build-arg DOCKER_REPO=${DEFAULT_DOCKER_REPO} .
				#  --build-arg ARTIFACTORY_URL=${ARTIFACTORY_URL} \
				#  --build-arg ARTIFACTORY_USERNAME=${ARTIFACTORY_USERNAME} \
				#  --build-arg ARTIFACTORY_ACCESS_TOKEN=${ARTIFACTORY_ACCESS_TOKEN} .

.PHONY: publish
publish:
	./scripts/publish-image.sh

.PHONY: help
help:
	@uv run python -c "import re; \
	[[print(f'\033[36m{m[0]:<20}\033[0m {m[1]}') for m in re.findall(r'^([a-zA-Z_-]+):.*?## (.*)$$', open(makefile).read(), re.M)] for makefile in ('$(MAKEFILE_LIST)').strip().split()]"

.DEFAULT_GOAL := help
