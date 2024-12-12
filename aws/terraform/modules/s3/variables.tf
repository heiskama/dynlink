variable "name" {
  type        = string
  description = "Name of the S3 Bucket"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to set. Limits and requirements: https://docs.aws.amazon.com/tag-editor/latest/userguide/best-practices-and-strats.html#id_tags_naming_best_practices"
}

variable "custom_policy" {
  type        = string
  default     = null
  description = "Input the policy (JSON encoded as string) here."
}

variable "index_file" {
  type        = string
  description = "Path to the index file."
}
