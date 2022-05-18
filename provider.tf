terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.20.0"
    }
  }
}



provider "aws" {

    region = "us-east-2"
    access_key = ""
    secret_key = ""

}  
