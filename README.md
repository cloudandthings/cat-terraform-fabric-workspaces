# Terraform Microsoft Fabric Workspace

This Terraform project creates and manages Microsoft Fabric capacities, domains, and workspaces using both the Microsoft Fabric and Azure Resource Manager Terraform providers.

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
│   ├── fabric_domain/        # Microsoft Fabric domain module
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
     "fabric_capacities": [
       {
         "location": "eastus2",
         "basename": "test001",
         "sku": "F2",
         "admin_emails": [
           "admin@yourdomain.com",
           "admin2@yourdomain.com"
         ]
       }
     ],
     "domains": [
       {
         "display_name": "test-domain",
         "description": "This is a test domain",
         "parent_domain_id": "",
         "admin_principals": [
           {
             "id": "user-object-id-here",
             "type": "User"
           }
         ]
       }
     ],
     "workspaces": [
       {
         "display_name": "test-workspace",
         "description": "This is a test workspace",
         "capacity_basename": "test001",
         "domain_name": "test-domain"
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
- `fabric_capacities` (list): List of Fabric capacities to create
  - `location` (string): Azure region for the capacity
  - `basename` (string): Base name for the capacity and resource group
  - `sku` (string): Fabric capacity SKU (e.g., F2, F32, F64, F128)
  - `admin_emails` (list): List of administrator email addresses

### Domain Configuration
- `domains` (list): List of Fabric domains to create
  - `display_name` (string): The name of the Fabric domain
  - `description` (string, optional): Description of the domain
  - `parent_domain_id` (string, optional): ID of the parent domain for nested domains
  - `admin_principals` (list): List of administrator principals
    - `id` (string): Object ID of the user or group
    - `type` (string): Type of principal ("User" or "Group")

### Workspace Configuration
- `workspaces` (list): List of Fabric workspaces to create
  - `display_name` (string): The name of the Fabric workspace
  - `description` (string, optional): Description of the workspace
  - `capacity_basename` (string): Reference to the capacity basename
  - `domain_name` (string, optional): Reference to the domain display name

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
- Sets administration members from email addresses

#### Module Inputs
- `basename` (string): Base name for resources
- `location` (string): Azure region (default: "North Europe")
- `sku` (string): Fabric capacity SKU (default: "F2")
- `admin_emails` (list): List of administrator email addresses

#### Module Outputs
- `id` (string): The Azure resource ID of the Fabric capacity

### fabric_domain

The [`fabric_domain`](modules/fabric_domain) module creates Microsoft Fabric domains with the following features:

- Creates Fabric domains for organization and governance
- Supports nested domain hierarchies
- Configurable administrator role assignments
- Domain-based workspace management

#### Module Inputs
- `display_name` (string): The display name of the Fabric domain
- `description` (string): Description of the domain (optional)
- `parent_domain_id` (string): ID of the parent domain for nested domains (optional)
- `admin_principals` (list): List of administrator principals with id and type

#### Module Outputs
- `id` (string): The ID of the Fabric domain

### fabric_workspace

The [`fabric_workspace`](modules/fabric_workspace) module creates Microsoft Fabric workspaces with the following features:

- Configurable display name and description
- Links to existing Fabric capacity
- Automatic domain assignment
- Capacity state validation

#### Module Inputs
- `display_name` (string): The name of the Fabric workspace
- `description` (string): Description of the workspace (optional)
- `capacity_id` (string): The Azure resource ID of the Fabric capacity
- `fabric_domain_id` (string): The ID of the Fabric domain (optional)

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
- Domains are created first and independently
- Workspaces depend on both capacities and domains being created
- Capacity administrators are validated against Azure AD
- Domain workspace assignments are created after workspace creation

## Architecture

The solution creates a hierarchical structure:
1. **Azure Resource Groups** - Container for Azure resources
2. **Fabric Capacities** - Compute resources for Fabric workloads
3. **Fabric Domains** - Organizational units for governance
4. **Fabric Workspaces** - Development environments linked to capacities and domains

## License

The Microsoft Fabric Terraform provider is licensed under the Mozilla Public License 2.0.

## Notes

- The [`terraform.tfvars.json`](terraform.tfvars.json) file contains sensitive information and is excluded from version control
- State files ([`terraform.tfstate`](terraform.tfstate)) are also excluded from git
- The Fabric provider is configured with `preview = true` to enable preview features
- Ensure admin emails and principal IDs exist as valid users/groups in your Azure AD tenant
- Fabric capacities require specific Azure regions that support Microsoft Fabric
- Domain assignments automatically link workspaces to their specified domains
- The workspace module extracts capacity names from Azure resource IDs for Fabric provider compatibility