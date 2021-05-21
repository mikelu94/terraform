# Terraform

A terraform project I wrote.
It provisions:

- a VPC on a single Availability Zone
- a single Public Subnet on that VPC
- an Internet Gateway
- a Routing Table for the Public Subnet to that Internet Gateway
- an EC2 instance
- a Security Group for that EC2 instance
- a SSH Key Pair to limit access to that EC2 instance

## Dependencies

- AWS Account
- CLIs:
    - `aws`
    - `terraform`

## How to Set Up

```bash
$ aws configure
$ terraform init
```

## How to Plan/Test a State Change

```bash
$ terraform plan -var my_ip=<myIPAddress> - var public_key_path=<pathToPublicSSHKey>
```

## How to Show Current State

```bash
$ terraform state list
```

## How to Apply a State Change

```bash
$ terraform apply [-auto-approve] -var my_ip=<myIPAddress> - var public_key_path=<pathToPublicSSHKey>
```

## How to Clean Up

```bash
$ terraform destroy
```

