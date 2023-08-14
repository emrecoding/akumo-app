terraform {
  backend "s3" {
    bucket = "NameOfYourS3Bucket"
    region = "us-west-1"
  }
}