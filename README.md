# Terraform Microsoft Fabric Workspaces

This Terraform project creates and manages Microsoft Fabric capacities, domains, and workspaces using both the Microsoft Fabric and Azure Resource Manager Terraform providers.

## Prerequisites

- [mise](https://mise.jdx.dev/) — manages all required tools (Terraform, tflint, Azure CLI, pre-commit, checkov)
- Microsoft Fabric access with appropriate permissions
- Azure subscription with permissions to create Fabric capacities

## Setup

After cloning the repo, run:

```bash
mise run setup
```

This installs all required tools at the correct versions and activates the pre-commit hooks.

## Pre-commit Hooks

This repo uses [pre-commit](https://pre-commit.com/) with [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) hooks that run automatically on every `git commit`:

- **terraform_fmt** — formats all `.tf` files
- **terraform_validate** — validates all Terraform configuration
- **terraform_tflint** — lints Terraform files with tflint
- **terraform_checkov** — static security analysis

To run all hooks manually:

```bash
pre-commit run --all-files
```

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
│   │   ├── provider.tf
│   │   └── scripts/
│   │       ├── capacity_scheduler.ps1  # Runbook: scheduled pause/resume
│   │       └── capacity_autostop.ps1   # Runbook: usage-based auto-pause
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
         ],
         "scheduler": {
           "pause_time": "20:00",
           "resume_time": "07:00",
           "pause_days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
           "resume_days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
         },
         "usage_autostop": {
           "check_interval_hours": 1,
           "idle_threshold_checks": 2
         }
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
  - `scheduler` (object, optional): Automated pause/resume schedule. Omit or set to `null` to disable.
    - `pause_time` (string): Time to pause the capacity in `HH:MM` UTC format
    - `resume_time` (string): Time to resume the capacity in `HH:MM` UTC format
    - `pause_days` (list, optional): Days on which to pause (default: all days)
    - `resume_days` (list, optional): Days on which to resume (default: all days)
  - `usage_autostop` (object, optional): Usage-based auto-pause configuration. Polls workspaces for active job instances and suspends the capacity when idle. Omit or set to `null` to disable. See [Usage-based Auto-pause](#usage-based-auto-pause-autostop) for detection caveats.
    - `check_interval_hours` (number, optional): Poll frequency in hours, 1–24 (default: `1`)
    - `idle_threshold_checks` (number, optional): Consecutive idle polls required before suspending (default: `2`)

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
- Optional scheduled pause/resume via Azure Automation
- Optional usage-based auto-pause based on Fabric job instance polling

#### Module Inputs
- `basename` (string): Base name for resources
- `location` (string): Azure region (default: "North Europe")
- `sku` (string): Fabric capacity SKU (default: "F2")
- `admin_emails` (list): List of administrator email addresses
- `scheduler` (object, optional): Automated pause/resume schedule configuration. Set to `null` (default) to disable.
  - `pause_time` (string): Time to pause the capacity in `HH:MM` UTC format
  - `resume_time` (string): Time to resume the capacity in `HH:MM` UTC format
  - `pause_days` (list, optional): Days on which to run the pause schedule (default: all days)
  - `resume_days` (list, optional): Days on which to run the resume schedule (default: all days)
- `usage_autostop` (object, optional): Usage-based auto-pause configuration. Set to `null` (default) to disable. See [Usage-based Auto-pause](#usage-based-auto-pause-autostop) for what is and isn't detected.
  - `check_interval_hours` (number, optional): Poll frequency in hours, 1–24 (default: `1`)
  - `idle_threshold_checks` (number, optional): Consecutive idle polls required before suspending (default: `2`)

#### Module Outputs
- `id` (string): The Azure resource ID of the Fabric capacity
- `automation_account_id` (string): The Azure resource ID of the Automation Account. `null` when both `scheduler` and `usage_autostop` are disabled.
- `monitor_principal_id` (string): Principal ID of the Automation Account's managed identity. Used by the workspace module to grant Fabric workspace membership. `null` when `usage_autostop` is disabled.

#### Capacity Scheduler

When `scheduler` is configured, the module provisions the following Azure resources to automate capacity cost management:

- **Azure Automation Account** — with a System-Assigned Managed Identity
- **Role Assignment** — grants the Managed Identity `Contributor` access on the Fabric Capacity
- **PowerShell 7.2 Runbook** (`capacity_scheduler.ps1`) — authenticates via Managed Identity and calls the Azure Management API to suspend or resume the capacity
- **Two weekly schedules** — one to pause and one to resume the capacity at the configured times and days

The runbook is idempotent: it checks the current capacity state before acting and skips the API call if the capacity is already in the target state.

#### Usage-based Auto-pause (autostop)

When `usage_autostop` is configured, the module provisions an additional runbook (`capacity_autostop.ps1`) that polls all accessible Fabric workspaces for active job instances and suspends the capacity only after it has been consistently idle for a sustained period.

The Fabric Jobs API only reports **scheduled or triggered job instances**. Interactive and continuous workloads are invisible to this API and will not prevent suspension.

**Detected (will prevent suspension while running):**

| Workload | Activity |
|---|---|
| Data Factory | Data pipeline runs, Dataflow Gen2 refreshes, Copy Job runs |
| Data Engineering | Notebook runs (scheduled / triggered), Spark Job Definition runs, Lakehouse table maintenance (OPTIMIZE / VACUUM) |
| Data Science | ML Experiment / ML Model training jobs (when triggered as jobs) |
| Data Warehouse | Semantic model (dataset) refreshes |
| Real-Time Intelligence | KQL Database commands triggered as job instances, Mirrored Database initial snapshots (where exposed as jobs) |

**NOT detected (capacity may be suspended while these are in active use):**

| Workload | Activity |
|---|---|
| Data Warehouse / SQL | Interactive SQL queries against Fabric Warehouses; queries against the Lakehouse SQL analytics endpoint |
| Real-Time Intelligence | Interactive KQL queries against Eventhouses, KQL Databases, KQL Querysets; Eventstream continuous ingestion; Activator (Reflex) rule evaluation; Real-Time Dashboards |
| Data Engineering | Interactive notebook sessions; Spark interactive sessions / Livy endpoint usage |
| Power BI / Data Science | Power BI report rendering, DirectQuery / Direct Lake reads, paginated reports; interactive ML Experiment exploration |
| Mirrored Database | Continuous change-data replication |

> For workloads dominated by interactive SQL, KQL, Power BI, or streaming usage, the `scheduler` option is safer as it pauses at predictable off-hours rather than relying on incomplete activity detection.

The managed identity must be added as a **Member** of each Fabric workspace to monitor. Workspaces managed by this Terraform project are assigned automatically; any others must be added manually via the Fabric Admin Portal.

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
- Automatic addition of the capacity autostop managed identity as a workspace `Member`

#### Module Inputs
- `display_name` (string): The name of the Fabric workspace
- `description` (string): Description of the workspace (optional)
- `capacity_id` (string): The Azure resource ID of the Fabric capacity
- `fabric_domain_id` (string, optional): The ID of the Fabric domain
- `assign_to_domain` (bool, optional): Whether to assign the workspace to a Fabric domain (default: `false`)
- `monitor_principal_id` (string, optional): Principal ID of the capacity autostop managed identity to add as a workspace `Member`. Pass through from `module.fabric_capacity.monitor_principal_id`. Set to `null` to skip.

## Provider Configuration

This project uses multiple Terraform providers:

### Microsoft Fabric Provider
- Version: 1.10.0
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