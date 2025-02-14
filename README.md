#📘 Módulo Terraform: Network (VPC, Subnets, Parameter Store e Tags)
Este módulo provisiona a infraestrutura de rede na AWS, incluindo:

✔ VPC com Internet Gateway.

✔ Sub-redes públicas e privadas.

✔ Parameter Store para armazenar parâmetros.

✔ Tags padronizadas para governança e rastreamento no CMDB.

📂 Estrutura do Repositório
````
tf-network-module/
├── VPC/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
├── SUBNET/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
├── PARAMETER-STORE/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
├── TAGS/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
````

---

#🚀 Exemplos de Uso

##📌 Terraform (1 VPC e 3 Subnets: 1 Pública, 2 Privadas)
````hcl
module "tags" {
  source             = "./TAGS"
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "VPC"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}

module "vpc" {
  source   = "./VPC"
  region   = "us-east-1"
  vpc_name = "my-vpc"
  vpc_cidr = "10.0.0.0/16"
  tags     = module.tags.tags
}

module "subnet_public" {
  source             = "./SUBNET"
  vpc_id             = module.vpc.vpc_id
  subnet_name        = "public-subnet"
  subnet_cidrs       = ["10.0.1.0/24"]
  availability_zones = ["us-east-1a"]
  is_public          = true
  tags               = module.tags.tags
}

module "subnet_private" {
  source             = "./SUBNET"
  vpc_id             = module.vpc.vpc_id
  subnet_name        = "private-subnet"
  subnet_cidrs       = ["10.0.2.0/24", "10.0.3.0/24"]
  availability_zones = ["us-east-1b", "us-east-1c"]
  is_public          = false
  tags               = module.tags.tags
}

module "ssm" {
  source          = "./PARAMETER-STORE"
  parameter_name  = "/app/db-password"
  parameter_value = "supersecurepassword"
  tags            = module.tags.tags
}
````

## 📌 Terragrunt Simples
### 📂 Estrutura de Pastas
````
infra/
├── terragrunt.hcl
├── vpc/
│   ├── terragrunt.hcl
├── subnet-public/
│   ├── terragrunt.hcl
├── subnet-private/
│   ├── terragrunt.hcl
├── ssm/
│   ├── terragrunt.hcl
├── tags/
│   ├── terragrunt.hcl
````

## 📌 Arquivo infra/terragrunt.hcl
````hcl
terraform {
  source = "./TAGS"
}

inputs = {
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "VPC"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}
````

## 📌 Terragrunt Reutilizável

### 📂 Estrutura de Pastas
````
infra/
├── _config/
│   ├── common-values.hcl
├── vpc/
│   ├── terragrunt.hcl
├── subnet-public/
│   ├── terragrunt.hcl
├── subnet-private/
│   ├── terragrunt.hcl
├── ssm/
│   ├── terragrunt.hcl
├── tags/
│   ├── terragrunt.hcl

````

### 📌 Arquivo _config/common-values.hcl
````hcl
inputs = {
  region = "us-east-1"
  tags   = dependency.tags.outputs.tags
}
````
### 📌 Arquivo tags/terragrunt.hcl
````hcl
terraform {
  source = "../TAGS"
}

inputs = {
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "VPC"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}
````
Agora todas as aplicações reutilizam os valores de _config/common-values.hcl, garantindo consistência e evitando duplicação de código. 🔥

---

✅ Vantagens do Módulo
✔ Cria 1 VPC e 3 sub-redes (1 pública e 2 privadas).

✔ Garante governança com tags obrigatórias.

✔ Flexível: Pode ser usado com Terraform ou Terragrunt.

✔ Reutilizável: Com Terragrunt, os valores podem ser centralizados.

✔ Facilmente expansível para novas sub-redes e serviços.

---
# Change log e Versions

1.0.0 - Criação inicial do modulo