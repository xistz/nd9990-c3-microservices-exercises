variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "bucket_name" {
  type    = string
  default = "xistz-udagram-microservices-dev"
}

variable "db_identifier" {
  type    = string
  default = "udagram-mircoservices-dev"
}

variable "db_username" {
  type    = string
  default = "udagram"
}

variable "db_name" {
  type    = string
  default = "udagram_dev"
}

variable "cluster_name" {
  default = "udagram-eks"
}
