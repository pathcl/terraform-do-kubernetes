// Remote state on aws
// TODO:
//
//  - use locking and dynamodb
terraform {
  backend "s3" {
    bucket = "k8sprod"
    key    = "mbird/dev/terraform.tfstate"
    region = "us-east-1"
}
}