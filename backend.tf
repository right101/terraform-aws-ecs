terraform {
    backend "s3" {
      bucket = "terraform-backend-raya"
      region = "us-east-1"
      key = "ecs-cluster" 
      #dynamodb_table = "terraform-session-sep-state-lock"  

    }
}