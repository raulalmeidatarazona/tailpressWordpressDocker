# Tailpress WordPress Docker Environment

A ready-to-use Docker environment for developing WordPress themes with [Tailpress](https://tailpress.io/), which uses Tailwind CSS and Vite with Hot Module Replacement (HMR) for PHP and JS files.

The goal of this template is to clone it, run one command, and start developing immediately.

## Prerequisites

Before you begin, ensure you have the following installed on your system:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)
- [Node.js & npm](https://nodejs.org/en/)
- [Composer](https://getcomposer.org/)

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone git@github.com:raulalmeidatarazona/tailpressWordpressDocker.git your-project-name
   cd your-project-name
   ```

2. **Initialize the environment:**
   ```bash
   make init
   ```

That's it! The `make init` command will build the Docker containers, install the Tailpress theme, install all dependencies, and set up WordPress.

Once it's finished, it will start the Vite development server. You can now access your new WordPress site:

- **WordPress Site:** [http://localhost:8000](http://localhost:8000)
- **WordPress Admin:** [http://localhost:8000/wp-admin](http://localhost:8000/wp-admin)
  - **User:** `admin`
  - **Password:** `password`
- **MailHog (Email Catcher):** [http://localhost:8025](http://localhost:8025)

Your theme files are located in `wp-content/themes/tailpress-theme`. Start editing, and enjoy Hot Module Replacement!

## Makefile Commands

This project uses a `Makefile` to simplify common tasks.

| Command              | Description                                                              |
|----------------------|--------------------------------------------------------------------------|
| `make init`          | **(Start here)** Initializes the entire environment from scratch.        |
| `make up`            | Starts the Docker containers in the background.                          |
| `make down`          | Stops and removes the Docker containers.                                 |
| `make clean`         | Stops containers and **deletes all data** (including the database).      |
| `make dev`           | Starts the Vite development server for HMR.                              |
| `make cli`           | Opens a `bash` shell inside the WordPress container for debugging.       |
| `make wp [command]`  | Executes any WP-CLI command. E.g., `make wp plugin list`.                |
