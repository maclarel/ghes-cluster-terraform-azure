# Terraform - GitHub Enterprise Server cluster in Azure


## What is this?

This workflow creates a simple 5 node GitHub Enterprise Server cluster infrastructure, ideal for basic functional testing. You need to supply your own license and [handle the configuration of GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster).

An example `cluster.conf` file can be found [here](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster#about-the-cluster-configuration-file).

The GitHub Enterprise Server version can be specified in the `terraform.tfvars` file, along with the Azure region.

**Note:** The prompts for username/password are required by Azure for VM creation, but don't aren't actually used by the GitHub Enterprise Server VMs at all.

## How do I use it?

### Install Terraform

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Install Azure CLI & Log in

```
brew update && brew install azure-cli
az login
```

### Update variables

Edit `terraform.tfvars` to choose Azure Region, cluster name, domain, and GitHub Enterprise Server version

### Run the workflow

```
terraform init
terraform apply
```

## To Do

- Add more variable support
- Clean up formatting/comments
- Figure out a way to split this into multiple files (???)
- Figure out how to address timeouts/out-of-order operations from erroring out when running `terraform destroy`
