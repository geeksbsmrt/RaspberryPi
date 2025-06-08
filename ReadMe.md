[![Deploy Docker Stack to Prod](https://github.com/geeksbsmrt/RaspberryPi/actions/workflows/deploy-prod.yaml/badge.svg)](https://github.com/geeksbsmrt/RaspberryPi/actions/workflows/deploy-prod.yaml)

# RaspberryPi Home Lab Configuration

This repository contains configuration files and resources for setting up and managing a Raspberry Pi-based home lab environment. It leverages tools like Docker, pre-commit hooks, and encrypted secrets management to ensure a secure and maintainable setup.

## Features
- Dockerized Services: Containerized applications for easy deployment and scalability.
- Pre-commit Hooks: Automated code quality checks to maintain code standards.
- Encrypted Secrets Management: Secure handling of sensitive information using SOPS.
- CI/CD Workflows: Automated workflows for testing and deployment.

## Repository Structure
```plaintext
.github/workflows/       # GitHub Actions workflows for CI/CD
.gitignore               # Specifies files to ignore in Git
.pre-commit-config.yaml  # Configuration for pre-commit hooks
.sops.yaml               # SOPS configuration for secrets management
docker/                  # Docker configurations and Dockerfiles
secrets.sops.env         # Encrypted environment variables
```
