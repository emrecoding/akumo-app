# akumo-app - README
Welcome to the `akumo-app` repository. This setup is where Jenkins-based CI/CD automation interfaces seamlessly with AWS through Terraform Infrastructure-as-Code (IaC).

## Overview
Contained within this repository is the CI/CD configuration for three distinct environments: `dev`, `stg`, and `prd`. These are represented by the branches `develop`, `stage`, and `main`. In the AWS ecosystem, each environment corresponds to an EC2 instance, adhering to the naming convention: `app_[environment_name]`.

## Why a Multibranch Pipeline?
The Multibranch Pipeline in Jenkins is a game-changer for our project. Here’s why:

- **Branch-specific CI/CD**: With each branch representing a different environment, the multibranch pipeline ensures that CI/CD processes are tailor-made for each branch, enhancing specificity and reducing risks.
- **Automatic Branch Detection**: As soon as a new branch is pushed to the repository, Jenkins automatically detects and creates a new pipeline for it. This automation speeds up the development process and ensures no branch is left behind.
- **Isolation**: By using a multibranch pipeline, changes in one environment (e.g., dev) don't accidentally spill over to others (e.g., prd). This isolation is crucial for maintaining the integrity of our production environment.
- **Flexibility**: Developers can freely experiment and test changes in the development or staging branches without affecting the main production environment. Once validated, these changes can be smoothly promoted to higher environments.

## Prerequisites
- **AWS Account**: Required for AWS resource provisioning.
- **VSCode**: The recommended coding environment.
- **Jenkins Server**: A Jenkins server with a multibranch pipeline already configured is necessary.
- **GitHub**: A private repository is leveraged for this project to uphold security and version control best practices.

## Jenkins Pipeline Breakdown
Drawing from the Jenkinsfile, the CI/CD process unfolds as:

### Parameters
The `SELECT_CHOICE` parameter is introduced at the outset, offering users the choice between Terraform actions: `plan`, `apply`, or `destroy`.

### Stages
1. **Environment maps**: The current branch (`develop`, `stage`, or `main`) determines the `ENV_NAME` variable, aligning it with the relevant environment (`dev`, `stg`, or `prd`).
2. **Checkout**: Code from the specified branch is fetched into the Jenkins workspace.
3. **Terraform Initialization**: Based on the selected environment, the backend key path is configured, targeting the `terraform.state` within the `akumo_app` directory. Terraform then initializes the backend.
4. **Code Quality Assurance**: Before any other Terraform action is run, it's imperative to ensure code quality and correctness. At this stage, `terraform validate` is executed to check the configuration files for any errors. Subsequently, `terraform fmt` is run to ensure consistent formatting across all Terraform files. This step is considered a **_best practice_** and should _never_ be skipped, ensuring consistency and reliability across all environments (`dev`, `stg`, `prd`).
5. **Execute Terraform Action**: Relying on the user's chosen action (`plan`, `apply`, or `destroy`), Terraform gets activated within the `akumo_app` directory, employing the appropriate `.tfvars` file for the chosen environment.

This **sequence of stages** outlines the automation process in our project that utilizes Terraform's **_Infrastructure as Code (IaC)_** to **provision AWS resources**. It ensures _consistent, error-free deployment_ by maintaining **code quality**, aligning configurations with the **correct environments**, and streamlining the application or destruction of resources through a structured workflow.


# Sequential Logic in DevOps Lifecycle

The infrastructure for the application is built iteratively following the DevOps loop, ensuring a consistent and smooth transition between environments:

## Development Environment (dev)
- **Backend Directory Structure**: Organizing the **dev** backend environment within a specific directory (e.g., `akumo_app/dev/terraform.state`) ensures separation and better organization between environments.
- **EC2 Provisioning**: Starting with an _EC2 instance_ allows developers to create a reproducible environment that mirrors what the application will need in production. It aids in local testing and verification.

## Staging Environment (stg)
- **Mirroring dev**: By keeping the staging environment close to the development setup, you can catch issues that might only occur when the code is run in an environment that's more similar to production.
- **Integration and Testing**: This phase acts as a safety net, where integration with other services and _rigorous testing_ ensures that the code will perform as expected in the production environment.

## Production Environment (prd)
- **Mirroring stg**: Keeping the production environment similar to staging ensures that what has been tested and verified in staging will behave the same way in production.
- **Deployment**: Deployment to _production_ is the final step, showcasing the application to the end-users. It's crucial that this environment is stable, secure, and performs well.

## Terraform Backend Configuration
- **S3 Bucket for State Files**: Using _S3_ for storing Terraform state files provides a centralized, durable, and secure way to manage the state. Dividing these into separate directories for dev, stg, and prd ensures isolation and control over different environments.
- **Terraform Initialization in Jenkins**: Automating this process within _Jenkins_ enables a smooth transition between different stages of the DevOps lifecycle, allowing for version control, collaboration among team members, and automated execution.

_Throughout this cycle, each environment plays a pivotal role, working in tandem to continually plan, build, test, deploy, and monitor, driving continuous improvement of the product._

## Declarative: Post-Actions

The post-actions section is a vital part of the Jenkins pipeline, where operations like notifications, reporting, and cleanup are executed after the main pipeline process. This section ensures a seamless transition from the development phase to deployment and monitoring.

### Slack API Integration

The integration of Slack API in the Jenkins pipeline provides an immediate feedback loop for developers and stakeholders, ensuring everyone is on the same page regarding the status of the pipeline.

- **Function**: Sends real-time notifications to specific Slack channels or users regarding the success or failure of the pipeline run.
- **Purpose**: To enable rapid communication within the team and facilitate quick responses to any issues.
- **Benefits**: Enhances collaboration and ensures that all team members are informed of critical updates in a timely manner.
- **How it Works**: Depending on the pipeline status, a corresponding message is sent to Slack using the `slackSend` command.

### Workspace Cleanup

Workspace cleanup is essential for maintaining an efficient, secure, and well-functioning application.

- **Function**: Deletes temporary files, artifacts, and any leftover data from the Jenkins workspace after the pipeline execution.
- **Purpose**: To ensure that subsequent runs are isolated and to prevent potential storage or security issues.
- **Benefits**:
  - **Reclaim Disk Space**: Frees up storage, preventing potential disk space issues.
  - **Ensure Isolation**: Prevents accidental carry-over of files between builds.
  - **Enhance Security**: Reduces risks associated with lingering sensitive data.
- **How it Works**: The command `cleanWs()` is executed at the end of the pipeline to remove all temporary files from the workspace.

### Synergy: How They Work Together

The combination of Slack API integration and workspace cleanup creates a robust foundation for a well-functioning application.

- **Communication and Efficiency**: While Slack ensures quick communication, workspace cleanup maintains an efficient environment, making sure that the development process is agile and responsive.
- **Security and Compliance**: Together, they ensure that the application is not only kept up to date but also complies with best practices regarding security and resource management.
- **Enhanced Collaboration**: Real-time notifications foster teamwork, while a clean workspace ensures that everyone works in a consistent and error-free environment.

These declarative post-actions are not just additional features but fundamental components that bridge the development, deployment, and monitoring stages, ensuring a holistic and streamlined approach to modern DevOps practices.

## Wrapping Up
The structure, logic, and content of the code underscore the power of flexibility and minimalism. By adeptly mapping the `BRANCH_NAME` variable (which indicates the current branch) to the corresponding `ENV_NAME` variable(indicates the environment mapped to the branch of the repository), the Jenkinsfile ensures that each environment-specific script runs seamlessly and without error. This dynamic relationship between the two variables, alongside other components in the Jenkinsfile and Terraform files, keeps the code concise, yet powerful. This blend of GitHub and Jenkins, especially with the implementation of the multibranch pipeline, transforms the provisioning of AWS resources into a straightforward task, making Infrastructure-as-Code via Terraform both efficient and delightfully easy to manage.
