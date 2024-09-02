## DATAS

variable "kms_key_id" {
  type    = string
  default = null
}

variable "aws_s3_bucket" {
  type    = string
  default = null
}

## MODULES

variable "bucket" {
  type    = any
  default = []
}

variable "key" {
  type    = any
  default = []
}

## TAGS

variable "tags" {
  type    = map(string)
  default = {}
}

## RESOURCES

variable "data_catalog" {
  type = list(object({
    id          = number
    description = string
    name        = string
    parameters  = map(string)
    type        = string
    tags        = optional(map(string))
  }))
  default = []

  validation {
    condition     = length([for a in var.data_catalog : true if contains(["LAMBDA", "HIVE", "GLUE"], a.type)]) == length(var.data_catalog)
    error_message = "Type of data catalog: LAMBDA for a federated catalog, GLUE for AWS Glue Catalog, or HIVE for an external hive metastore."
  }
}

variable "database" {
  type = list(object({
    id                    = number
    name                  = string
    bucket                = optional(any)
    comment               = optional(string)
    expected_bucket_owner = optional(string)
    force_destroy         = optional(bool)
    properties            = optional(map(string))
    acl_configuration = optional(list(object({
      s3_acl_option = optional(string)
    })))
    encryption_configuration = optional(list(object({
      encryption_option = string
      kms_key           = optional(any)
    })))
  }))
  default = []

  validation {
    condition     = length([for a in var.database : true if contains(["SSE_S3", "SSE_KMS", "CSE_KMS"], a.encryption_configuration.encryption_option)]) == length(var.database)
    error_message = "Type of key : one of SSE_S3, SSE_KMS, CSE_KMS."
  }
}

variable "named_query" {
  type = list(object({
    id           = number
    database_id  = any
    name         = string
    query        = string
    description  = optional(string)
    workgroup_id = optional(any)
  }))
  default = []
}

variable "prepared_statement" {
  type = list(object({
    id              = number
    name            = string
    query_statement = string
    workgroup_id    = any
    description     = optional(string)
  }))
  default = []
}

variable "workgroup" {
  type = list(object({
    id            = number
    name          = string
    description   = optional(string)
    state         = optional(string)
    force_destroy = optional(bool)
    tags          = optional(map(string))
    configuration = optional(list(object({
      bytes_scanned_cutoff_per_query     = optional(number)
      enforce_workgroup_configuration    = optional(bool)
      execution_role                     = optional(string)
      publish_cloudwatch_metrics_enabled = optional(bool)
      requester_pays_enabled             = optional(bool)
      selected_engine_version            = optional(string)
      result_configuration = optional(list(object({
        expected_bucket_owner = optional(string)
        output_location       = optional(string)
        acl_configuration = optional(list(object({
          s3_acl_option = optional(string)
        })))
        encryption_configuration = optional(list(object({
          encryption_option = string
          kms_key           = optional(any)
        })))
      })))
    })))
  }))
  default = []

  validation {
    condition     = length([for a in var.workgroup : true if contains(["SSE_S3", "SSE_KMS", "CSE_KMS"], a.configuration.result_configuration.encrpytion_configuration.encrpytion_option)]) == length(var.workgroup)
    error_message = "Type of key : one of SSE_S3, SSE_KMS, CSE_KMS."
  }
}
