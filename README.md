# Terraform Microsoft Fabric Workspace

This Terraform project creates and manages Microsoft Fabric capacities and workspaces using both the Microsoft Fabric and Azure Resource Manager Terraform providers.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- Microsoft Fabric access with appropriate permissions
- Azure CLI installed and configured
- Azure subscription with permissions to create Fabric capacities

## Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── provider.tf               # Provider configuration
├── variables.tf              # Variable definitions
├── terraform.tfvars.json     # Variable values (excluded from git)
├── terraform.tfvars.json.example  # Example variable values
├── modules/
│   ├── fabric_capacity/      # Azure Fabric capacity module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── provider.tf
│   └── fabric_workspace/     # Microsoft Fabric workspace module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── provider.tf
├── creative/                 # Additional resources directory
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
       "tenant_id": "your-tenant-id-here",
       "subscription_id": "your-subscription-id-here"
     },
     "capacities": [
       {
         "basename": "capacity-name",
         "location": "West Europe",
         "sku": "F32",
         "admin_email": "admin@yourdomain.com"
       }
     ],
     "workspaces": [
       {
         "display_name": "workspace-name",
         "description": "Workspace description",
         "capacity_basename": "capacity-name"
       }
     ]
   }
   ```

## Variables

The project uses the following variables defined in [`variables.tf`](variables.tf):

### Provider Configuration
- `fabric_provider.tenant_id` (string): Your Microsoft Fabric tenant ID
- `fabric_provider.subscription_id` (string): Your Azure subscription ID

### Capacity Configuration
- `capacities` (list): List of Fabric capacities to create
  - `basename` (string): Base name for the capacity and resource group
  - `location` (string): Azure region for the capacity
  - `sku` (string): Fabric capacity SKU (e.g., F32, F64, F128)
  - `admin_email` (string): Email of the capacity administrator

### Workspace Configuration
- `workspaces` (list): List of Fabric workspaces to create
  - `display_name` (string): The name of the Fabric workspace
  - `description` (string): Description of the workspace
  - `capacity_basename` (string): Reference to the capacity basename

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

## Modules

### fabric_capacity

The [`fabric_capacity`](modules/fabric_capacity) module creates Azure Fabric capacities with the following features:

- Creates Azure Resource Group
- Deploys Microsoft Fabric capacity
- Configurable SKU and location
- Sets administration members

#### Module Inputs
- `basename` (string): Base name for resources
- `location` (string): Azure region
- `sku` (string): Fabric capacity SKU
- `admin_email` (string): Administrator email address

#### Module Outputs
- `id` (string): The Azure resource ID of the Fabric capacity

### fabric_workspace

The [`fabric_workspace`](modules/fabric_workspace) module creates Microsoft Fabric workspaces with the following features:

- Configurable display name and description
- Links to existing Fabric capacity
- Uses the Microsoft Fabric provider version 1.2.0

#### Module Inputs
- `display_name` (string): The name of the Fabric workspace
- `description` (string): Description of the workspace (optional, defaults to empty string)
- `capacity_id` (string): The ID of the Fabric capacity to assign the workspace to

## Provider Configuration

This project uses multiple Terraform providers:

### Microsoft Fabric Provider
- Version: 1.2.0
- Authentication: Azure CLI (`use_cli = true`)
- Preview features enabled

### Azure Resource Manager Provider
- Version: >= 3.98.0
- Authentication: Azure CLI
- Used for creating Fabric capacities and resource groups

### Azure Active Directory Provider
- Version: >= 2.47.0
- Used for looking up user principals for capacity administration

## Dependencies

The project establishes the following dependencies:
- Workspaces depend on capacities being created first
- Capacity administrators are validated against Azure AD

## License

The Microsoft Fabric Terraform provider is licensed under the Mozilla Public License 2.0. See [LICENSE.txt](.terraform/providers/registry.terraform.io/microsoft/fabric/1.2.0/windows_amd64/LICENSE.txt) for details.

## Notes

- The [`terraform.tfvars.json`](terraform.tfvars.json) file contains sensitive information and is excluded from version control
- State files ([`terraform.tfstate`](terraform.tfstate)) are also excluded from git
- The Fabric provider is configured with `preview = true` to enable preview features
- Ensure the admin email provided exists as a valid user in your Azure AD tenant
- Fabric capacities require specific Azure regions that support Microsoft Fabric