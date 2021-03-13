# Terraform - GitHub Enterprise Server cluster in Azure

This workflow creates a simple 5 node GitHub Enterprise Server cluster infrastructure, ideal for basic functional testing. You need to supply your own license and [handle the configuration of GitHub Enterprise Server](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster).

An example `cluster.conf` file can be found [here](https://docs.github.com/en/enterprise-server@3.0/admin/enterprise-management/initializing-the-cluster#about-the-cluster-configuration-file).

The GitHub Enterprise Server version can be specified in the `terraform.tfvars` file, along with the Azure region.

**Note:** The prompts for username/password are required by Azure for VM creation, but don't aren't actually used by the GitHub Enterprise Server VMs at all.
