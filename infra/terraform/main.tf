terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "random" {}

resource "random_pet" "demo" {
  length = 2
}

output "name" {
  value = random_pet.demo.id
}
