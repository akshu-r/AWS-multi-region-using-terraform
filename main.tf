

provider "aws"{
    region = var.region_1
}

provider "aws" {
    alias = "region_2"
    region = var.region_2
  
}

# Call Region 1 module
module "region_1" {
  source         = "./modules/region_1"
  region         = var.region_1
  ami_id         = var.ami_id[var.region_1]
  instance_type  = var.instance_type
  key_name       = var.key_name
}

# Call Region 2 module
module "region_2" {
  source         = "./modules/region_2"
  providers      = { aws = aws.region_2 }
  region         = var.region_2
  ami_id         = var.ami_id[var.region_2]
  instance_type  = var.instance_type
  key_name       = var.key_name
  
}
