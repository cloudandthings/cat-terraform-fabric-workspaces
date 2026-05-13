terraform {
  required_version = ">= 1.3.0"
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "~> 1.10"
    }
  }
}