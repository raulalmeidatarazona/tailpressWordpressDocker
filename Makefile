# Makefile for Tailpress WordPress Development Environment

SHELL := /bin/bash

.PHONY: init up down clean install-theme install-deps configure-vite wp-install theme-activate dev cli wp help

# Default command: show help
default: help

# Main initialization command
init:
	@make up
	@make install-theme
	@make install-deps
	@make configure-vite
	@make wp-install
	@make theme-activate
	@echo "✅ Environment initialized. WordPress is running and the theme is active."
	@echo "🚀 Starting development server... (Press Ctrl+C to stop)"
	@make dev

# Start Docker containers
up:
	@echo "🐳 Starting Docker containers..."
	@mkdir -p wp-content/themes
	@docker-compose up -d --build

# Stop and remove Docker containers
down:
	@echo "🛑 Stopping Docker containers..."
	@docker-compose down

# Stop containers and remove volumes (full clean)
clean:
	@echo "🔥 Stopping containers and removing all data (volumes)..."
	@docker-compose down -v

# Install Tailpress theme using Composer
install-theme:
	@echo "🎨 Installing Tailpress theme..."
	@if [ ! -d "wp-content/themes/tailpress-theme" ]; then \
		composer create-project tailpress/tailpress wp-content/themes/tailpress-theme; \
	else \
		echo "👍 Theme directory already exists. Skipping installation."; \
	fi

# Install theme's npm dependencies
install-deps:
	@echo "📦 Installing npm dependencies..."
	@npm --prefix ./wp-content/themes/tailpress-theme install

# Configure Vite for Docker HMR
configure-vite:
	@echo "⚡ Configuring Vite for Docker..."
	@cp ./.devcontainer/vite.config.js ./wp-content/themes/tailpress-theme/vite.config.js

# Install WordPress using WP-CLI
wp-install:
	@echo "⏳ Waiting for database to be ready..."
	@until docker-compose exec -T db mysqladmin ping -h"db" -u"wordpress" -p"password" --silent; do \
		sleep 1; \
	done
	@echo "🚀 Installing WordPress..."
	@docker-compose exec -T wordpress wp core install --url=http://localhost:8000 --title="Tailpress Dev" --admin_user=admin --admin_password=password --admin_email=admin@example.com --skip-email

# Activate the theme using WP-CLI
theme-activate:
	@echo "🎨 Activating Tailpress theme..."
	@docker-compose exec -T wordpress wp theme activate tailpress-theme

# Run the Vite development server
dev:
	@echo "🚀 Starting Vite development server..."
	@npm --prefix ./wp-content/themes/tailpress-theme run dev

# Get a shell inside the WordPress container
cli:
	@echo "💻 Entering WordPress container shell..."
	@docker-compose exec wordpress bash

# Run WP-CLI commands from the host
wp:
	@docker-compose exec wordpress wp $(filter-out $@,$(MAKECMDGOALS))

# Display help
help:
	@echo "Makefile Commands:"
	@echo "  make init            - Initializes the entire environment from scratch."
	@echo "  make up              - Starts the Docker containers."
	@echo "  make down            - Stops the Docker containers."
	@echo "  make clean           - Stops containers and deletes database data."
	@echo "  make dev             - Starts the Vite development server."
	@echo "  make cli             - Opens a shell inside the WordPress container."
	@echo "  make wp [command]    - Executes a WP-CLI command (e.g., \'make wp plugin list\')."
