# Secrets and Security in CI/CD

## Overview

CI/CD pipelines are critical infrastructure components with direct access to:
- source code
- deployment environments
- cloud infrastructure
- container registries
- production systems

A compromised CI/CD pipeline can result in:
- infrastructure breaches
- credential exposure
- malicious deployments
- supply chain attacks
- production outages

Modern DevOps environments must treat CI/CD systems as high-security operational infrastructure.

Pipeline security focuses on:
- secret protection
- access control
- artifact integrity
- runner isolation
- deployment authorization
- supply chain security

---

# Secrets in CI/CD

Secrets are sensitive credentials used during pipeline execution.

Common CI/CD secrets include:
- cloud access keys
- SSH private keys
- registry credentials
- API tokens
- database passwords
- signing keys

Examples:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
DOCKER_PASSWORD
SSH_PRIVATE_KEY
GITHUB_TOKEN
```

Secrets should never be exposed directly inside:
- repositories
- workflow files
- container images
- build logs

---

# Common Secret Exposure Risks

Improper secret handling creates severe security vulnerabilities.

Common exposure scenarios:

| Risk                     | Example                         |
| ------------------------ | ------------------------------- |
| Hardcoded credentials    | passwords inside YAML           |
| Log exposure             | tokens printed in workflow logs |
| Public repositories      | exposed environment variables   |
| Shared runners           | credential leakage              |
| Compromised dependencies | malicious package access        |

Secret compromise frequently results in full infrastructure exposure.

---

# Secret Management Systems

Production environments should use centralized secret management systems.

Common platforms:

| Platform              | Usage                       |
| --------------------- | --------------------------- |
| GitHub Secrets        | CI workflow secrets         |
| HashiCorp Vault       | centralized secrets         |
| AWS Secrets Manager   | cloud-native secret storage |
| Azure Key Vault       | Azure secret management     |
| Google Secret Manager | GCP secret storage          |

Benefits:
- encrypted storage
- controlled access
- audit logging
- secret rotation
- centralized management

---

# GitHub Actions Secrets

GitHub Actions provides encrypted secret storage integrated into repositories and environments.

Secrets are injected securely during workflow execution.

Example usage:

```yaml
env:
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```

Secret scopes:
- repository secrets
- organization secrets
- environment secrets

Environment-level secrets are preferred for production deployments.

---

# Secret Rotation

Secrets should never remain static indefinitely.

Rotation practices:
- scheduled credential replacement
- automatic token expiration
- short-lived authentication

Benefits:
- reduced exposure window
- improved incident recovery
- minimized long-term credential risk

Production environments commonly rotate:
- cloud credentials
- deployment tokens
- SSH keys
- service account credentials

---

# Least Privilege Access

CI/CD systems should receive only minimum required permissions.

Example:
- deployment workflow should not receive administrative cloud access

Benefits:
- reduced attack surface
- limited blast radius
- improved access governance

Examples of restricted access:
- read-only repository tokens
- scoped registry credentials
- environment-specific permissions

Overprivileged CI systems are a major production security risk.

---

# OpenID Connect (OIDC)

Modern CI/CD systems increasingly use short-lived federated authentication instead of static credentials.

OIDC allows GitHub Actions to authenticate directly with cloud providers without storing permanent secrets.

Supported platforms:
- AWS
- Azure
- Google Cloud

Benefits:
- eliminates long-lived credentials
- improved authentication security
- automatic token expiration

OIDC is now considered a production-grade authentication standard.

---

# Runner Security

Runners execute pipeline workloads and require strict isolation controls.

---

## GitHub-Hosted Runners

Managed by GitHub.

Advantages:
- isolated ephemeral environments
- automatic cleanup
- reduced maintenance

Risks:
- shared infrastructure
- limited customization

Generally suitable for:
- standard CI workloads
- public repository automation

---

## Self-Hosted Runners

Managed internally by engineering teams.

Common deployment targets:
- EC2 instances
- Kubernetes clusters
- internal VMs

Advantages:
- infrastructure control
- private network access
- custom tooling

Risks:
- infrastructure compromise
- persistence-based attacks
- insufficient hardening

Self-hosted runners require:
- network isolation
- patch management
- restricted permissions
- monitoring

---

# Workflow Security

Workflow files themselves are part of the attack surface.

Common workflow risks:
- malicious pull requests
- unsafe script execution
- insecure third-party actions
- command injection

Example insecure pattern:

```yaml
run: echo ${{ github.event.pull_request.title }}
```

Improper input handling may result in arbitrary command execution.

---

# Third-Party Action Risks

GitHub Actions frequently use external reusable actions.

Risks:
- compromised action repositories
- malicious updates
- supply chain attacks

Best practices:
- pin action versions
- use trusted publishers
- review action source code
- avoid unverified community actions

Preferred:

```yaml
uses: actions/checkout@v4
```

Avoid:
- floating latest tags
- untrusted repositories

---

# Supply Chain Security

Modern CI/CD security extends beyond source code.

Supply chain security includes:
- dependency validation
- package integrity
- artifact signing
- trusted build systems

Supply chain attacks commonly target:
- package registries
- build systems
- dependency managers
- container images

---

# Dependency Security

Applications rely heavily on external dependencies.

Security validation should include:
- vulnerability scanning
- dependency pinning
- outdated package detection

Common tooling:

| Tool       | Purpose                  |
| ---------- | ------------------------ |
| Trivy      | container scanning       |
| Snyk       | dependency scanning      |
| Dependabot | dependency updates       |
| Grype      | vulnerability scanning   |
| Bandit     | Python security analysis |

Security scanning should execute automatically during CI.

---

# Container Security

Containers are common deployment artifacts and require dedicated security controls.

Security focus areas:
- minimal base images
- non-root containers
- vulnerability scanning
- image signing

Best practices:
- avoid unnecessary packages
- use distroless/minimal images
- scan images before deployment
- remove build-time dependencies

Example:
- alpine-based images
- non-root runtime users

---

# Artifact Integrity

Artifacts generated during CI should remain trusted and verifiable.

Production systems commonly implement:
- artifact hashing
- image signing
- provenance validation

Benefits:
- tamper detection
- trusted deployments
- supply chain integrity

Common tooling:
- Cosign
- Notary
- Sigstore

---

# Environment Isolation

Production environments should remain isolated from lower environments.

Isolation areas:
- separate credentials
- isolated runners
- restricted deployments
- dedicated infrastructure

Never:
- share production secrets with development environments
- allow unrestricted deployment access

Environment separation limits deployment blast radius.

---

# Deployment Security Controls

Production deployments should enforce:
- approval workflows
- deployment authorization
- audit logging
- restricted production access

Common controls:
- protected branches
- mandatory pull request reviews
- deployment approvals
- release tagging

Production infrastructure should never allow unrestricted direct deployments.

---

# Audit Logging

Security events should remain traceable.

Important audit areas:
- deployment history
- secret access
- workflow execution
- infrastructure changes

Audit logging supports:
- incident investigation
- compliance requirements
- operational visibility

---

# Security Monitoring

Production CI/CD systems require continuous monitoring.

Monitoring areas:
- unauthorized workflow changes
- unusual runner activity
- failed authentication attempts
- secret access anomalies

Common monitoring integrations:
- SIEM platforms
- cloud audit systems
- centralized logging platforms

---

# Common CI/CD Security Failures

Frequent production security failures include:

| Failure               | Impact                    |
| --------------------- | ------------------------- |
| Hardcoded credentials | infrastructure compromise |
| Overprivileged tokens | lateral movement          |
| Untrusted actions     | malicious execution       |
| Unpatched runners     | exploit exposure          |
| Shared environments   | cross-workload compromise |

Many large-scale breaches originate from insecure CI/CD systems.

---

# CI/CD Security Best Practices

Production security recommendations:

- use centralized secret management
- rotate credentials regularly
- implement least privilege access
- isolate runners and environments
- use short-lived authentication
- pin dependency and action versions
- scan dependencies continuously
- monitor pipeline activity
- enforce branch protection
- use immutable artifacts
- sign production images
- validate deployment approvals

Security should remain integrated into every pipeline stage.

---

# DevSecOps Integration

Modern engineering practices integrate security directly into CI/CD workflows.

DevSecOps focuses on:
- automated security validation
- continuous compliance
- integrated vulnerability scanning
- secure software delivery

Security becomes part of:
- development workflows
- pipeline execution
- deployment automation

Security is no longer treated as a separate operational phase.

---

# Conclusion

CI/CD security is foundational to modern production engineering.

Pipelines possess privileged access across:
- infrastructure
- applications
- deployment systems
- cloud environments

A properly secured CI/CD platform reduces:
- credential exposure
- supply chain attacks
- deployment compromise
- infrastructure risk

Production-grade CI/CD security requires:
- strict access control
- secure secret management
- runner isolation
- artifact integrity
- continuous monitoring
- automated security validation

Modern DevOps engineering must treat CI/CD pipelines as mission-critical infrastructure systems.
