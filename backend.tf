terraform {

backend "s3" {
    bucket = "myffdbucket1000-tf-state"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
}
}
