# Repository Rules: RaspberryPi

This file defines the standards and requirements for the `geeksbsmrt/RaspberryPi` home lab repository.

## 1. Technical Stack

- **Primary Scripting**: Bash (.sh) is the preferred language for orchestration and local maintenance.
- **Orchestration**: Docker Compose for service management.
- **Excluded**: PowerShell 7 and .NET/C# are discouraged for this repository unless explicitly requested.

## 2. Networking & IP Management

The environment primarily uses the `192.168.254.0/24` range for Docker containers within the broader `192.168.0.0/16` home network.

### Allocation Strategy

- **Public Services**: Internet-routable through Caddy. Assigned from the **bottom** of the macvlan range (e.g., `.1`, `.2`, `.3`...).
- **Internal Services**: Databases, support services (e.g., Unbound). Assigned from the **top** of the macvlan range (e.g., `.254`, `.253`, `.252`...).

### Network Isolation

- **Rule**: Backend services (Databases, Redis, etc.) should use internal Docker bridge networks where possible. Only front-facing services (Caddy, Pi-hole) or those requiring direct subnet access should be exposed to the `macvlan` network.

### Naming Conventions

- **Variable**: `IP_SERVICE(_FUNCTION)` (e.g., `IP_PIHOLE`, `IP_UMAMI_DB`).
- **Container**: Must be named for the service they provide.

## 3. Secret Management

- **Primary Source**: `secrets.sops.env` (Encrypted via SOPS/AGE).
- **Secondary**: `docker/.env` (Local plaintext, derived from or kept in sync with SOPS).
- **Requirement**: The following MUST be placed in both files and encrypted in the `.sops.env`:
  - API keys, passwords, and tokens.
  - **Internal IP addresses** (any IP within the `192.168.0.0/16` range).
- **Rule**: Never commit `docker/.env` directly to Git.

## 4. Security & Industry Standards

To ensure the home lab remains secure and stable, the following standards apply:

### Container Security

- **Image Pinning**: Avoid `:latest` or `:alpine` tags without a version number. All images must be pinned to a specific version (e.g., `image: postgres:16.1-alpine`).
- **Least-Privilege**: Containers should run as non-root users (`user: "1000:1000"`) where compatible.
- **Healthchecks**: Every service in `docker-compose.yml` must include a functional `healthcheck`.
- **Logging Configuration**: Limit log sizes to prevent disk exhaustion (e.g., `max-size: "10m"`, `max-file: "3"`).

### Data Persistence

- **Standard**: Persistent data volumes should be mapped to a standard path (e.g., `./data/service_name`) or clearly organized within the service directory to simplify backups.

### Quality Control

- **Linting**: All `docker-compose.yml` and `sh` files must pass `hadolint` and `shellcheck` via pre-commit hooks.
- **Secret Scanning**: Pre-commit hooks must be active to prevent plaintext leakages.

## 5. Operational Workflow

- **Git-First Deployment**: All changes MUST be committed to the repository. Deployment is handled by GitHub Actions (`deploy-prod.yaml`).
- **Emergency Exception (Hotfix)**:
  - In a "Service Down" situation, manual fixes may be applied to the live instance **ONLY after explicit USER permission**.
  - Once verified, changes **MUST** be immediately committed to Git.
- **Idempotency**: All setup scripts must be safe to run multiple times.

## 6. Monitoring & Observability

Every new service added MUST be onboarded to the monitoring stack using native tools to avoid sidecar vulnerabilities:

1. **Uptime Kuma**: Add the public/internal URL for immediate up/down status tracking.
2. **Prometheus / Blackbox**: Add HTTP and/or DNS probes to the `website_and_http_checks` or `dns_service_checks` in `prometheus.yml.template`.
3. **Alerts**: Any new probes must be covered by the generic "EndpointDown" rule in `alert_rules.yml`. Do not add custom third-party exporters unless explicitly required.
