locals {
  common_tags = {
    Purpose   = "Jenkins Multi-Branch"
    ManagedBy = "Terraform"
    Owner     = "YourEmailHere@domain.com"
    GitUrl    = "https://ToYourURL"
  }
  env_tags = {
    dev = { Name = "app_dev", Environment = "dev" }
    stg = { Name = "app_stg", Environment = "stg" }
    prd = { Name = "app_prd", Environment = "prd" }
  }
}