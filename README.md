# personal-site-gw

Entry point for a personal site hosted on AWS. The intent is to host a blog documenting AWS and Terraform learnings, demos of AWS features as I learn them, and an eventual Virtual Tabletop server provisioning app for use by me and my friends. This component will comprise just the API Gateway, any configuration steps necessary to attach it to a purchased domain name, and a trivial and minimally configurable lambda function, zero or more copies of which may be attached to the gateway for demo purposes. As the blog and VTT provisioning app components are fleshed out, they will be referenced for inclusion by the gateway.

## Architecture

### Iteration 1 - *Completed in 78b9e856a7519ec44622782800774d05b4d22c06*

**Terraform**

Terraform's AWS provider will be responsible for deploying, modifying, and tearing down all resources required by this project. Any project-specific nomenclature, e.g. account names and IDs or relevant web domains, will be parameterized and drawn from a `.tfvars` file.

**API Gateway**

An AWS API Gateway resource will be managed by Terraform. It will route one or more paths to Hello World mock responses:

| Path        | Description                                      |
|-------------|--------------------------------------------------|
| `/hello/:offset` | Hello world response incorporating the offset             |
| `*`    | 404 page   |

Note that `:offset` above will not be a dynamic path. The intent, by way of a learning exercise, is to configure a small, static number of lambda listeners.

**Commentary**

This iteration uses individual Terraform resources for each API Gateway component (methods, integrations, responses) rather than an OpenAPI specification. While this approach is verbose and doesn't scale well for complex APIs, it provides excellent visibility into the underlying AWS resources and concepts. This detailed approach serves the learning objectives well, allowing hands-on experience with each piece of the API Gateway puzzle.

### Iteration 2 - *Ongoing*

This iteration is intended to combine work on a blog, on the VTT provisioner app, and on learning other pieces of the AWS ecosystem under the one entry point.

Despite being the second iteration, this should be understood as an ongoing project meant to incorporate other demo-worthy work I do.

**API Gateway**

Reference Lambda Functions or other handlers in other git repos instead of a local module or native Terraform resources. The routes are not certain, but might look something like:

| Path        | Description                                      |
|-------------|--------------------------------------------------|
| `/`         | Assuming I can cook up a decent home page in a blog framework, then this will be the same lambda as `/blog/*` |
| `/blog/*`   | Lambda from future personal-site-blog repo. |
| `/vtt/*`    | Lambda from future vtt-provisioner repo |
| `/demo/:topic` | Lambda from aws-demos/:topic repo and directory |
| `/hello/:offset` | Hello world response incorporating the offset             |
| `/demos/roll` | Roll a d20! |
| `/demos/roll/{rollString}` | Roll a (simplistic) roll string, e.g. 1d8+4+2d6 |

### Iteration 3 - *unimplemented*

**API Gateway**

Add SSL Termination and configure DNS for purchased domain name to point at Gateway. Handle as much as possible within Terraform.


### Iteration 4 - *unimplemented*

This iteration focuses on supporting multiple deployment environments and improving the infrastructure management patterns.

**Multiple Environments**

Refactor the Terraform configuration to support multiple environments (dev, staging, prod) with:
- Environment-specific variable files (`dev.tfvars`, `staging.tfvars`, `prod.tfvars`)
- Remote state management using S3 backend with DynamoDB locking
- Environment-specific resource configurations (logging, throttling, monitoring)
- Conditional resource creation based on environment

**Infrastructure Improvements**

- Modularize Terraform code for better reusability
- Add comprehensive tagging strategy for resource management
- Implement environment-specific API Gateway configurations
- Add CloudWatch logging and monitoring for non-dev environments

### Iteration 5 - *unimplemented*

This iteration implements automated deployment pipelines and improves the development workflow.

**CI/CD Pipeline**

Implement automated deployment using GitHub Actions or AWS CodePipeline:
- Automated Terraform validation and planning
- Environment-specific deployment workflows

**Development Workflow**

- Pre-commit hooks for Terraform formatting and validation

### Iteration 6 - *unimplemented*

This iteration addresses the scalability limitations of the individual Terraform resource approach as the API grows in complexity.

**OpenAPI Specification Migration**

Migrate from individual Terraform resources to OpenAPI specification-based API definitions:
- Convert existing mock endpoints to OpenAPI 3.0 specification
- Implement AWS API Gateway extensions for integrations
- Maintain Terraform for infrastructure while using OpenAPI for API definitions
- Add automated OpenAPI validation and documentation generation

## Usage

When this project is ready to be deployed on accounts other than my own (e.g. necessary secrets are documented, but not included), then instructions for deploying it will be included here.
