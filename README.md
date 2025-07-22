# personal-site-gw

Entry point for a personal site hosted on AWS. The intent is to host a blog documenting AWS and Terraform learnings, demos of AWS features as I learn them, and an eventual Virtual Tabletop server provisioning app for use by me and my friends. This component will comprise just the API Gateway, any configuration steps necessary to attach it to a purchased domain name, and a trivial and minimally configurable lambda function, zero or more copies of which may be attached to the gateway for demo purposes. As the blog and VTT provisioning app components are fleshed out, they will be referenced for inclusion by the gateway.

## Architecture

### Iteration 1

**Terraform**
Terraform's AWS provider will be responsible for deploying, modifying, and tearing down all resources required by this project. Any project-specific nomenclature, e.g. account names and IDs or relevant web domains, will be parameterized and drawn from a `.tfvars` file.

**API Gateway**
An AWS API Gateway resource will be managed by Terraform. It will route one or more paths to a single Lambda function:

| Path        | Description                                      |
|-------------|--------------------------------------------------|
| `/hello/:offset` | Hello world response incorporating the offset             |
| `*`    | 404 page   |

Note that `:offset` above will not be a dynamic path. The intent, by way of a learning exercise, is to configure a small, static number of lambda listeners.

### Iteration 2

**API Gateway**

Add SSL Termination and configure DNS for purchased domain name to point at Gateway. Handle as much as possible within Terraform.

### Iteration 3

This iteration is intended to combine work on a blog, on the VTT provisioner app, and on learning other pieces of the AWS ecosystem under the one entry point.

**API Gateway**

Reference Lambda Functions in other git repos instead of a local module or native Terraform resources. The routes are not certain, but might look something like:

| Path        | Description                                      |
|-------------|--------------------------------------------------|
| `/`         | Assuming I can cook up a decent home page in a blog framework, then this will be the same lambda as `/blog/*` |
| `/blog/*`   | Lambda from future personal-site-blog repo. |
| `/vtt/*`    | Lambda from future vtt-provisioner repo |
| `/demo/:topic` | Lambda from aws-demos/:topic repo and directory |

**Lambda Function**
The Hello Lambda Function will have served as training wheels. By this iteration, they should come off.

## Usage

When this project is ready to be deployed on accounts other than my own (e.g. necessary secrets are documented, but not included), then instructions for deploying it will be included here.
