variable "s3_name" {
  type    = string
#  default = "logs"
}

variable "s3_name2" {
  type    = string
 # default = "images"
}

resource "random_id" "s3name" {
  byte_length = 8
}

locals {
  s3_name = "${var.s3_name}-${random_id.s3name.hex}"
  s3_name2 = "${var.s3_name2}-${random_id.s3name.hex}"
}
