# Terraform - GitHub Enterprise Server cluster in Azure


## What is this?

This workflow creates a simple 5 node GitHub Enterprise Server cluster infrastructure, ideal for basic functional testing. You need to supply your own license and [handle the configuration of GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster).

An example `cluster.conf` file can be found [here](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster#about-the-cluster-configuration-file).

The GitHub Enterprise Server version can be specified in the `terraform.tfvars` file, along with the Azure region, and other configuration options.

**Note:** The prompts for username/password are required by Azure for VM creation, but aren't actually used by the GitHub Enterprise Server VMs at all.

## How do I use it?

### [Install Terraform](https://www.terraform.io/downloads.html)

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### [Install Azure CLI & Log in](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

```
brew update && brew install azure-cli
az login
```

### Update variables (optional)

You'll be prompted for various values if they're not handled from a config file and/or don't have defaults.

- Copy/rename `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars` to choose Azure Region, cluster name, domain, instance/disk sizes, GitHub Enterprise Server version, etc...

### Run the workflow

```
terraform init
terraform apply
```

## Known Issues

- Current DNS configuration only resolves through Azure DNS servers. An `/etc/hosts` entry is provided in the output of the `terraform apply` which can be added for direct access.

## Notes
- This is provided as-is and *should not be used in a Production capacity*.

## To Do

- Add further LB health probes for non-HTTPS traffic.
- Figure out how to address timeouts/out-of-order operations from erroring out when running `terraform destroy`.
