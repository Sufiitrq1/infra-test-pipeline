**Project Documentation Content**


**Automated AWS Infrastructure Testing**

This project implements a shift-left infrastructure testing pipeline. By using Docker to containerize a Node.js API and Floci to emulate AWS services locally, the pipeline validates infrastructure configurations (ECR and ECS) during development and within GitHub Actions. This approach identifies deployment errors before they reach production.

**Project Goal**

To build an automated CI/CD pipeline that validates AWS container deployments against a local emulator, ensuring infrastructure stability and reducing manual testing efforts.

**Technical Stack**

**Docker:** Used to containerize the Node.js API for environment consistency.

**Floci:** A local AWS emulator for testing ECR and ECS configurations without cloud costs.

**AWS CLI:** Used to interact with the emulated AWS services.

**GitHub Actions:** Automates the testing pipeline on every repository push.

**Node.js/Express:** Provides a lightweight API with health check endpoints for verification.

**Workflow**

**API Depolyment: **Created a Node.js Express application with health check endpoints.

**Containerization:** Developed a multi-stage Dockerfile to create a minimal production image.

**Local Emulation:** Configured Floci via Docker Compose to emulate AWS services.

**Validation Scripting:** Wrote a bash script to automate the testing of ECR repositories, Docker builds, and ECS task registrations.

**CI/CD Automation:** Configured a GitHub Actions workflow to run the validation script automatically on every push, ensuring only verified code progresses.

**Results**

The pipeline successfully validates the full deployment lifecycle locally and in CI. All infrastructure checks pass with automated exit codes, preventing misconfigured deployments.
