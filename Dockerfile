# Build stage
FROM python:3.13-slim AS builder

ENV PATH="/home/docker/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    postgresql-client \
    libpq-dev \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libssl-dev \
    libffi-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user and group
RUN groupadd --system docker && \
    useradd --system --create-home --gid docker docker && \
    usermod -aG sudo docker && \
    echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up application directory
RUN mkdir -p /home/docker/azuredjango && chown -R docker:docker /home/docker && chmod -R 755 /home/docker

USER docker

ENV PATH="/home/docker/azuredjango/.venv/bin:$PATH"

# Install Poetry and upgrade pip
RUN python -m pip install --upgrade pip --user && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    poetry --version

WORKDIR /home/docker/azuredjango
COPY --chown=docker:docker ./azuredjango ./

# Install dependencies
RUN poetry config virtualenvs.in-project true && \
    poetry install --no-interaction --no-ansi

# Create media and static directories
RUN mkdir -p /home/docker/azuredjango/media && chmod -R 775 /home/docker/azuredjango/media && \
    mkdir -p /home/docker/azuredjango/staticfiles && chmod -R 775 /home/docker/azuredjango/staticfiles

# Verify Django installation
RUN python -m django --version || (echo "Django not installed" && exit 1)

# Final stage
FROM python:3.13-slim

ENV PATH="/home/docker/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create non-root user and group
RUN groupadd --system docker && \
    useradd --system --create-home --gid docker docker && \
    mkdir -p /home/docker/azuredjango && chown -R docker:docker /home/docker && chmod -R 755 /home/docker

COPY --chown=docker:docker ./entrypoint.sh /home/docker/azuredjango/entrypoint.sh
RUN chmod +x /home/docker/azuredjango/entrypoint.sh

USER docker

WORKDIR /home/docker/azuredjango

# Copy built application from builder stage
COPY --chown=docker:docker --from=builder /home/docker/azuredjango /home/docker/azuredjango

EXPOSE 8000

ENTRYPOINT ["/home/docker/azuredjango/entrypoint.sh"]
