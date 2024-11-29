terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cac-devtest-dev"
    storage_account_name = "cccterraformstatestorage"
    container_name       = "poc-appservice"
    key                  = "appservice-#{Octopus.Environment.Name}.terraform.tfstate"
  }
}

provider "azurerm" {
   features {}
}

variable "resourcegroupname" {
  type = "string"
  default = "app-srv-rg"
}

variable "webappname" {
  type = "string"
  default = "demoapp-#{Octopus.Environment.Name}"
}

variable "environment" {
  type = "string"
  default = "#{Octopus.Environment.Name}"
}

variable "location" {
  type = "string"
  default = "Canada Central"
}

variable "region" {
  type = "string"
  default = "canadacentral"
}

variable "owner" {
  type = "string"
  default = "demoapp-#{Octopus.Environment.Name}"
}

variable "description" {
  type = "string"
  default = "demoapp Website"
}

resource "azurerm_app_service_plan" "main" {
  name = "${var.webappname}-service-plan"
  location = "${var.location}"
  resource_group_name = "${var.resourcegroupname}"
  kind = "Linux"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = {
    description = "${var.description}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
  }
}

resource "azurerm_app_service" "main" {
  name                = "${var.webappname}"
  location = "${var.location}"
  resource_group_name = "${var.resourcegroupname}"
  app_service_plan_id = "${azurerm_app_service_plan.main.id}"

  site_config {
    linux_fx_version = "DOTNETCORE|6.6"
  }

  tags = {
    description = "${var.description}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    octopus-environment = "#{Octopus.Environment.Name}"
    octopus-role = "random-quotes-web"
  }
}
