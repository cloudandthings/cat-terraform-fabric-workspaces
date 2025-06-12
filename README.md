# Terraform Microsoft Fabric Workspace

This Terraform project creates and manages Microsoft Fabric workspaces using the Microsoft Fabric Terraform provider.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- Microsoft Fabric access with appropriate permissions
- Azure CLI installed and configured

## Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── provider.tf               # Provider configuration
├── variables.tf              # Variable definitions
├── terraform.tfvars.json     # Variable values (excluded from git)
├── terraform.tfvars.json.example  # Example variable values
├── modules/
│   └── fabric_workspace/     # Reusable workspace module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── provider.tf
└── README.md
```

## Configuration

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.json.example terraform.tfvars.json
   ```

2. Update [`terraform.tfvars.json`](terraform.tfvars.json) with your values:
   ```json
   {
     "fabric_provider": {
       "tenant_id": "your-tenant-id-here"
     },
     "workspace": {
       "display_name": "your-workspace-name",
       "description": "Your workspace description"
     }
   }
   ```

## Variables

The project uses the following variables defined in [`variables.tf`](variables.tf):

- `fabric_provider.tenant_id` (string): Your Microsoft Fabric tenant ID
- `workspace.display_name` (string): The display name for the workspace
- `workspace.description` (string, optional): Description of the workspace

## Usage

### Authenticate with Azure CLI
```bash
az login
```

### Initialize Terraform
```bash
terraform init
```

### Plan the deployment
```bash
terraform plan
```

### Apply the configuration
```bash
terraform apply
```

### Destroy resources
```bash
terraform destroy
```

## Module: fabric_workspace

The [`fabric_workspace`](modules/fabric_workspace) module creates a Microsoft Fabric workspace with the following features:

- Configurable display name and description
- Uses the Microsoft Fabric provider version 1.2.0

### Module Inputs

- `display_name` (string): The name of the Fabric workspace
- `description` (string): Description of the workspace (optional, defaults to empty string)

## Provider Configuration

This project uses the [Microsoft Fabric Terraform provider](https://registry.terraform.io/providers/microsoft/fabric/latest) with:

- Version: 1.2.0
- Authentication: Azure CLI (`use_cli = true`)
- Preview features enabled

## License

The Microsoft Fabric Terraform provider is licensed under the Mozilla Public License 2.0. See [LICENSE.txt](.terraform/providers/registry.terraform.io/microsoft/fabric/1.2.0/windows_amd64/LICENSE.txt) for details.

## Notes

- The [`terraform.tfvars.json`](terraform.tfvars.json) file contains sensitive information and is excluded from version control
- State files ([`terraform.tfstate`](terraform.tfstate)) are also excluded from git
- The provider is configured with `preview = true` to enable preview features