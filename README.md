Terraform
=========

This repository contains a basic intro to Terraform for a developer presentation at [Last Call Media](https://lastcallmedia.com).  It contains a very simple [demo](./terraform), and this README, which describes terraform concepts.

.tf files
---------

Terraform code is written in .tf files living inside of a single directory.  Inside of these files, you'll find:

* `provider` blocks: Instantiates and configures a "provider", which allows you to create different types of resources.
* `resource` blocks: Instantiates and configures a stateful resource.
* `data` blocks: Pulls in a resource that does not need to be created.
* `variable` blocks: Declares inputs the Terraform code can take in.
* `output` blocks: Declares outputs the Terraform code produces when run.

At its core, Terraform is really about "creating resources."  To do that, you use provider and data blocks to create resources.

**Concept**: All .tf files inside a given directory are exactly equivalent.  It doesn't matter whether they're called `main.tf`, `output.tf` or `variables.tf` - this is just convention.  Variables can live in `main.tf`, resources can live in `variables.tf`, and so on. 

Providers
---------

Providers are what allows Terraform to communicate with any third party service. Eg: AWS, Google Cloud, Cloudflare.

* [Cloudflare Example for Mass.gov](https://github.com/massgov/openmass/blob/develop/cloudflare/terraform/global/main.tf) - This code sets Cloudflare settings for the overall Mass.gov Cloudflare account.
* [AWS Example](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier) - This code creates AWS infrastructure for a two-tier web application (load balancer + EC2 instance).

State
-----

Infrastructure-as-code requires state. State tracks what resources exist and are managed by the Terraform code. New resources are not added to state until:
* The Terraform code is written.
* The Terraform code is "applied".

State can be stored in a "backend." The most common "backends" are:

* Local file storage - a `.tfstate` file that contains the state in JSON format.
* S3 - The same JSON format, but kept in S3 so it can be written to from anywhere.

**Careful**: State contains sensitive data and should never be committed to a repo. In practice, you will always want to store your state remotely.

Variables
---------

Terraform code can take variables. Variables must be declared, and are used as inputs to the system.

Variables can be typed, so that only a particular type of input will be accepted.

Top level variables can be set through:

* A `default` value in the `variable` block:
    ```hcl-terraform
    variable "domain_name" {
      default = "lastcallmedia.com"
    }
    ```
* A `.tfvars` file:
    ```hcl-terraform
    domain_name = lastcallmedia.com
    ```
* Environment variables:
    ```bash
    TF_VAR_DOMAIN_NAME=lastcallmedia.com
    ```
* A command line flag: 
    ```bash
    terraform apply -var 'domain_name=lastcallmedia.com'
    ```

Outputs
-------

Terraform code can produce "outputs." Outputs are things that the Terraform code returns to you after execution.  

Eg: The URL of a load balancer.

Modules
-------

Terraform modules are simply a directory of Terraform code.  Modules can have inputs (variables), and outputs.  
Think of modules as classes. You can "instantiate"  a module using constructor parameters (variables), and when it executes, it returns some outputs. What happens inside is a black box.

Modules can be kept and used from:
* A local directory
* Any Github repository(eg: https://github.com/massgov/mds-terraform-common)
* The [Terraform Module Registry](https://registry.terraform.io/).

Modules are includable from remote sources as well (see Terraform module registry).

Running
-------

There are two stages to running Terraform:

* Planning - where you actually see the "plan" for what's going to happen.
* Applying - Where you actually execute that plan.

In a lot of cases, you'll just use `terraform apply`, which whill first print a plan, then ask for confirmation to execute it. For PR review purposes though, we'll often use `terraform plan` explicitly to be able to produce the plan for review. 

If you ever want to clean up everything that exists for a given Terraform configuration, simply run `terraform destroy`.

Advanced Topics:
----------------

* Templating ([Terraform Docs](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)).
* State Backends ([Terraform Docs](https://www.terraform.io/docs/backends/types/index.html)).
* Secret Management ([Chamber](https://github.com/segmentio/chamber)).
* AWS Credential Storage ([AWS Vault](https://github.com/99designs/aws-vault) | [AWS Okta](https://github.com/segmentio/aws-okta)).


