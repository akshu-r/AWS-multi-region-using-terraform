

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

resource "aws_route53_zone" "main" {
  name = "yourdomain.com"
}

resource "aws_route53_health_check" "region1" {
  type = "HTTP"
  fqdn = module.region_1.ec2_public_dns
  resource_path = "/"
}

resource "aws_route53_health_check" "region2" {
  type = "HTTP"
  fqdn = module.region_2.ec2_public_dns
  resource_path = "/"
}

resource "aws_route53_record" "region1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.yourdomain.com"
  type    = "A"
  set_identifier = "region1"
  region  = "ap-south-1"
  latency_routing_policy {}
  health_check_id = aws_route53_health_check.region1.id
  ttl = 60
  records = [module.region_1.ec2_public_ip]
}

resource "aws_route53_record" "region2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.yourdomain.com"
  type    = "A"
  set_identifier = "region2"
  region  = "us-west-2"
  latency_routing_policy {}
  health_check_id = aws_route53_health_check.region2.id
  ttl = 60
  records = [module.region_2.ec2_public_ip]
}

