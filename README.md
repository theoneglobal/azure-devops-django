# Azure DevOps Django

[![CI](https://github.com/theoneglobal/azure-devops-django/workflows/CI/badge.svg)](https://github.com/theoneglobal/azure-devops-django/actions)
[![Python Version](https://img.shields.io/badge/python-%3E%3D3.13-blue)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Azure DevOps Django is a production-ready Django application designed for deployment on Azure using Docker and Azure DevOps CI/CD pipelines. Hosted at [theoneglobal/azure-devops-django](https://github.com/theoneglobal/azure-devops-django), this project provides a reusable setup with Poetry for dependency management, Azure integrations (e.g., Azure Storage, Application Insights), and automated builds. All Django configuration overrides, including URLs, are defined in `azuredjango/settings/override.py` for seamless integration with automated deployment workflows. The project includes support for Visual Studio Code Dev Containers, ensuring a consistent development environment.

## Features
- **Dockerized Deployment**: Multi-stage Dockerfile for efficient builds and deployments.
- **Poetry Dependency Management**: Streamlined Python dependency handling with `pyproject.toml`.
- **Azure Integrations**:
  - Azure Storage for static and media files.
  - Azure Application Insights for logging and monitoring.
- **Health Checks**: Integrated `django-health-check` for application monitoring.
- **CI/CD Pipelines**:
  - Azure DevOps pipeline for building and pushing Docker images to Azure Container Registry (ACR).
  - GitHub Actions for linting, testing, and Docker build validation.
- **Dependency Updates**: Dependabot for automated dependency management.
- **VS Code Dev Containers**: Standardized development environment with Python, Poetry, and PostgreSQL tools.
- **Automated Builds**: All Django settings overrides in `azuredjango/settings/override.py`, applied via `entrypoint.sh`.

## Prerequisites
- **Docker**: For building and running the application.
- **Git**: For cloning the repository.
- **Python 3.13**: For local development or Dev Containers.
- **Visual Studio Code**: With the Dev Containers extension (optional, for Dev Container support).
- **Azure Account**: With Container Registry (ACR), Storage, and Application Insights.
- **Azure DevOps Account**: For CI/CD pipeline setup.
- **PostgreSQL Database**: For production database connectivity.

## Quick Start
1. **Clone the Repository**
   ```bash
   git clone https://github.com/theoneglobal/azure-devops-django.git
   cd azure-devops-django
   ```

2. **Install Dependencies**
   ```bash
   poetry install
   ```
   This installs dependencies defined in `pyproject.toml`, including Django, `django-storages`, and `opencensus-ext-azure`.

3. **Build the Docker Image**
   ```bash
   docker build -t myacr.azurecr.io/azure-devops-django:1.0.0 .
   ```
   Replace `myacr.azurecr.io` with your Azure Container Registry (ACR) URL.

4. **Run the Application**
   ```bash
   docker run -p 8000:8000 \
       -e DJANGO_SETTINGS_MODULE=azuredjango.settings.override \
       -e AZURE_APP_INSIGHTS_KEY=your-key \
       -e DJANGO_SECRET_KEY=your-secret-key \
       -e DB_HOST=your-db-host \
       -e DB_NAME=your-db-name \
       -e DB_USER=your-db-user \
       -e DB_PASSWORD=your-db-password \
       myacr.azurecr.io/azure-devops-django:1.0.0
   ```
   Access the application at `http://localhost:8000`.

## Using Dev Containers in VS Code
To develop Azure DevOps Django in a consistent, isolated environment using VS Code Dev Containers:
1. Install the **Dev Containers** extension in VS Code.
2. Open the repository in VS Code.
3. Use the Command Palette (`Ctrl+Shift+P`) and select **Dev Containers: Reopen in Container**.
4. The container will build using `.devcontainer/Dockerfile`, installing Python 3.13, Poetry, and PostgreSQL client tools.
5. Inside the container, run:
   ```bash
   poetry install
   ```
6. Start the Django development server:
   ```bash
   poetry run python manage.py runserver 0.0.0.0:8000
   ```
7. Access the application at `http://localhost:8000` (port 8000 is forwarded by `devcontainer.json`).

For more details, see [docs/usage.md](docs/usage.md#using-dev-containers-in-vs-code).

## Documentation
Detailed instructions are available in [docs/usage.md](docs/usage.md), covering:
- Dependency management with Poetry.
- Docker setup and customization.
- Azure DevOps pipeline for pushing to Azure Container Registry (ACR).
- VS Code Dev Containers setup and usage.
- Testing, linting, and deployment workflows.

## CI/CD
- **GitHub Actions**: The `.github/workflows/ci.yml` workflow runs linting (`ruff`, `black`), tests (`pytest`), and Docker build checks on pull requests and pushes to the `main` branch.
- **Dependabot**: The `.github/dependabot.yml` configuration monitors and updates dependencies in `pyproject.toml` weekly.
- **Azure DevOps**: A pipeline (e.g., `azure-pipelines.yml`) automates building and pushing the Docker image to ACR. See [docs/usage.md](docs/usage.md#pushing-to-azure-container-registry-acr-in-azure-devops) for setup instructions.

## Contributing
Contributions to Azure DevOps Django are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit changes:
   ```bash
   git commit -m 'Add your feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature
   ```
5. Open a pull request on the [GitHub repository](https://github.com/theoneglobal/azure-devops-django).

Please ensure your code passes linting (`ruff`, `black`) and tests (`pytest`) before submitting. Follow the coding style and structure outlined in the project.
