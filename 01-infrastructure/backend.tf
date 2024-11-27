terraform {
  backend "s3" {
    bucket         = "824622998597-tfstate"
    key            = "main.tfstate"
    region         = "us-east-2"
    dynamodb_table = "824622998597-tf-lock-table"
  }
}
