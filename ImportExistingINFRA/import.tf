provider "aws" {
  region = "ap-south-1"
}

import {
  id = "i-0bd3******8faea"
  to = aws_instance.existing_instance
}