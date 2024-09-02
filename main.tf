resource "aws_athena_data_catalog" "this" {
  count       = length(var.data_catalog)
  description = lookup(var.data_catalog[count.index], "description")
  name        = lookup(var.data_catalog[count.index], "name")
  parameters  = lookup(var.data_catalog[count.index], "parameters")
  type        = lookup(var.data_catalog[count.index], "type")
  tags        = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.data_catalog[count.index], "tags"))
}

resource "aws_athena_database" "this" {
  count                 = length(var.database)
  name                  = lookup(var.database[count.index], "name")
  bucket                = lookup(var.database[count.index], "bucket")
  comment               = lookup(var.database[count.index], "comment")
  expected_bucket_owner = lookup(var.database[count.index], "expected_bucket_owner")
  force_destroy         = lookup(var.database[count.index], "force_destroy")
  properties            = lookup(var.database[count.index], "properties")

  dynamic "acl_configuration" {
    for_each = try(lookup(var.database[count.index], "acl_configuration") == null ? [] : ["acl_configuration"])
    iterator = acl
    content {
      s3_acl_option = lookup(acl.value, "s3_acl_option", "BUCKET_OWNER_FULL_CONTROL")
    }
  }

  dynamic "encryption_configuration" {
    for_each = try(lookup(var.database[count.index], "encryption_configuration") == null ? [] : ["encryption_configuration"])
    iterator = enc
    content {
      encryption_option = lookup(enc.value, "encryption_option")
      kms_key           = lookup(enc.value, "encryption_option") == "SSE_KMS" || lookup(enc.value, "encryption_option") == "CSE_KMS" ? try(var.kms_key_id != null ? data.aws_kms_key.this.id : lookup(enc.value, "kms_key")) : try(element(module.kms.*.key_arn, lookup(enc.value, "kms_key")))
    }
  }
}

resource "aws_athena_named_query" "this" {
  count       = length(var.database) == 0 ? 0 : length(var.named_query)
  database    = try(element(aws_athena_database.this.*.name, lookup(var.named_query[count.index], "database_id")))
  name        = lookup(var.named_query[count.index], "name")
  query       = lookup(var.named_query[count.index], "query")
  description = lookup(var.named_query[count.index], "description")
  workgroup   = try(element(aws_athena_workgroup.this.*.id, lookup(var.named_query[count.index], "workgroup_id")))
}

resource "aws_athena_prepared_statement" "this" {
  count           = length(var.workgroup) == 0 ? 0 : length(var.prepared_statement)
  name            = lookup(var.prepared_statement[count.index], "name")
  query_statement = lookup(var.prepared_statement[count.index], "query_statement")
  workgroup       = try(element(aws_athena_workgroup.this.*.name, lookup(var.prepared_statement[count.index], "workgroup_id")))
  description     = lookup(var.prepared_statement[count.index], "description")
}

resource "aws_athena_workgroup" "this" {
  count         = length(var.workgroup)
  name          = lookup(var.workgroup[count.index], "name")
  description   = lookup(var.workgroup[count.index], "description")
  state         = lookup(var.workgroup[count.index], "state")
  force_destroy = lookup(var.workgroup[count.index], "force_destroy")
  tags          = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.workgroup[count.index], "tags"))

  dynamic "configuration" {
    for_each = try(lookup(var.workgroup[count.index], "configuration") == null ? [] : ["configuration"])
    iterator = conf
    content {
      bytes_scanned_cutoff_per_query     = lookup(conf.value, "bytes_scanned_cutoff_per_query")
      enforce_workgroup_configuration    = lookup(conf.value, "enforce_workgroup_configuration")
      execution_role                     = lookup(conf.value, "execution_role")
      publish_cloudwatch_metrics_enabled = lookup(conf.value, "publish_cloudwatch_metrics_enabled")
      requester_pays_enabled             = lookup(conf.value, "requester_pays_enabled")

      dynamic "engine_version" {
        for_each = try(lookup(conf.value, "selected_engine_version") == null ? [] : ["engine_version"])
        content {
          selected_engine_version = lookup(conf.value, "selected_engine_version")
        }
      }

      dynamic "result_configuration" {
        for_each = try(lookup(conf.value, "result_configuration") == null ? [] : ["result_configuration"])
        iterator = res
        content {
          expected_bucket_owner = lookup(res.value, "expected_bucket_owner")
          output_location       = try(var.aws_s3_bucket != null ? join("/", ["s3:/", data.aws_s3_bucket.this.bucket], lookup(res.value, "output_location")) : join("/" , ["s3:/", element(module.s3.*.s3_bucket_id, lookup(res.value, "bucket_id"), lookup(res.value, "output_location"))]))

          dynamic "acl_configuration" {
            for_each = try(lookup(res.value, "acl_configuration") == null ? [] : ["acl_configuration"])
            iterator = acl
            content {
              s3_acl_option = try(lookup(acl.value, "s3_acl_option", "BUCKET_OWNER_FULL_CONTROL"))
            }
          }

          dynamic "encryption_configuration" {
            for_each = try(lookup(res.value, "encryption_configuration") == null ? [] : ["encryption_configuration"])
            iterator = enc
            content {
              encryption_option = try(lookup(res.value, "encryption_option"))
              kms_key_arn       = lookup(enc.value, "encryption_option") == "SSE_KMS" || lookup(enc.value, "encryption_option") == "CSE_KMS" ? try(var.kms_key_id != null ? data.aws_kms_key.this.id : lookup(enc.value, "kms_key")) : try(element(module.kms.*.key_arn, lookup(enc.value, "kms_key")))
            }
          }
        }
      }
    }
  }
}