.DEFAULT_GOAL = help
.PHONY        : help

# Executables
COMPOSER      = composer
DOCKER        = docker
DOCKER_COMP   = docker compose
PHP           = php
SYMFONY       = symfony
YARN          = yarn

# Alias
CONSOLE       = $(SYMFONY) console

# Vendor executables
PHPUNIT       = ./vendor/bin/phpunit
PHPSTAN       = ./vendor/bin/phpstan
PHP_CS_FIXER  = ./vendor/bin/php-cs-fixer
TWIG_CS_FIXER = ./vendor/bin/twig-cs-fixer

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

## —— 🎵 🐳 The Symfony Docker makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Project setup 🚀 ——————————————————————————————————————————————————————————
setup: ## Setup the whole project
	@$(COMPOSER) install --no-interaction

warmup: ## Warmup the whole project (e.g. after purge)
	@$(CONSOLE) asset-map:compile
	@$(CONSOLE) cache:warmup

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
start: build up ## Build and start the containers

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
vendor: composer.lock ## Install vendors according to the current composer.lock file
	@$(COMPOSER) install --prefer-dist --no-dev --no-progress --no-interaction

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
compile: ## Execute some tasks before deployment
	rm -rf public/assets/*
	@$(CONSOLE) asset-map:compile
	@$(CONSOLE) cache:clear
	@$(CONSOLE) cache:warmup

## —— Coding standards ✨ ——————————————————————————————————————————————————————
eslint: ## Run ESLint
	@$(YARN) run eslint assets

fix-js: ## Run ESLint with fixes
	@$(YARN) run eslint assets --fix

fix-php: ## Fix files with php-cs-fixer
	@$(PHP_CS_FIXER) fix --allow-risky=yes --config=php-cs-fixer.php

fix-twig: ## Fix files with php-cs-fixer
	@$(TWIG_CS_FIXER) --fix

lint-composer: ## Lint files with composer
	@$(COMPOSER) validate

lint-php: ## Lint files with php-cs-fixer
	@$(PHP_CS_FIXER) fix --allow-risky=yes --dry-run --config=php-cs-fixer.php

lint-symfony: ## Lint symfony project files
	@$(CONSOLE) lint:container --no-debug
	@$(CONSOLE) lint:yaml config
	@$(CONSOLE) lint:xliff translations
	@$(CONSOLE) doctrine:schema:validate --skip-sync -vvv --no-interaction

lint-twig: ## Lint files with php-cs-fixer
	@$(TWIG_CS_FIXER)

phpstan: ## Run PHPStan
	@$(PHPSTAN) analyse --memory-limit=-1

## —— Tests ✅ —————————————————————————————————————————————————————————————————
test: ## Run tests
	@$(PHPUNIT) --stop-on-failure -d memory_limit=-1

## —— Project pipelines 🚇 ——————————————————————————————————————————————————————
ci: lint-composer lint-symfony lint-php lint-twig eslint cs phpstan test ## Run CI pipeline

cs: fix-php fix-twig fix-js ## Run all coding standards checks

reset: purge warmup ## Reset pipeline for the whole project (caution!)

## —— Cleanup 🚮 ————————————————————————————————————————————————————————————————
purge: ## Purge temporary files
	@rm -rf public/assets/*
	@rm -rf var/cache/* var/logs/*

clear: ## Cleanup everything (except docker)
	@rm -rf vendor/*
	@rm -rf node_modules/*
	@rm -rf public/assets/*
	@rm -rf var/cache/* var/logs/*
