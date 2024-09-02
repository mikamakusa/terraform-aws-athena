## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/terraform-aws-kms | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/terraform-aws-s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_athena_data_catalog.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_data_catalog) | resource |
| [aws_athena_database.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_named_query.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_prepared_statement.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_prepared_statement) | resource |
| [aws_athena_workgroup.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_s3_bucket"></a> [aws\_s3\_bucket](#input\_aws\_s3\_bucket) | n/a | `string` | `null` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | `any` | `[]` | no |
| <a name="input_data_catalog"></a> [data\_catalog](#input\_data\_catalog) | n/a | <pre>list(object({<br>    id          = number<br>    description = string<br>    name        = string<br>    parameters  = map(string)<br>    type        = string<br>    tags        = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_database"></a> [database](#input\_database) | n/a | <pre>list(object({<br>    id                    = number<br>    name                  = string<br>    bucket                = optional(any)<br>    comment               = optional(string)<br>    expected_bucket_owner = optional(string)<br>    force_destroy         = optional(bool)<br>    properties            = optional(map(string))<br>    acl_configuration = optional(list(object({<br>      s3_acl_option = optional(string)<br>    })))<br>    encryption_configuration = optional(list(object({<br>      encryption_option = string<br>      kms_key           = optional(any)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_key"></a> [key](#input\_key) | n/a | `any` | `[]` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_named_query"></a> [named\_query](#input\_named\_query) | n/a | <pre>list(object({<br>    id           = number<br>    database_id  = any<br>    name         = string<br>    query        = string<br>    description  = optional(string)<br>    workgroup_id = optional(any)<br>  }))</pre> | `[]` | no |
| <a name="input_prepared_statement"></a> [prepared\_statement](#input\_prepared\_statement) | n/a | <pre>list(object({<br>    id              = number<br>    name            = string<br>    query_statement = string<br>    workgroup_id    = any<br>    description     = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_workgroup"></a> [workgroup](#input\_workgroup) | n/a | <pre>list(object({<br>    id            = number<br>    name          = string<br>    description   = optional(string)<br>    state         = optional(string)<br>    force_destroy = optional(bool)<br>    tags          = optional(map(string))<br>    configuration = optional(list(object({<br>      bytes_scanned_cutoff_per_query     = optional(number)<br>      enforce_workgroup_configuration    = optional(bool)<br>      execution_role                     = optional(string)<br>      publish_cloudwatch_metrics_enabled = optional(bool)<br>      requester_pays_enabled             = optional(bool)<br>      selected_engine_version            = optional(string)<br>      result_configuration = optional(list(object({<br>        expected_bucket_owner = optional(string)<br>        output_location       = optional(string)<br>        acl_configuration = optional(list(object({<br>          s3_acl_option = optional(string)<br>        })))<br>        encryption_configuration = optional(list(object({<br>          encryption_option = string<br>          kms_key           = optional(any)<br>        })))<br>      })))<br>    })))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_catalog_arn"></a> [data\_catalog\_arn](#output\_data\_catalog\_arn) | n/a |
| <a name="output_data_catalog_id"></a> [data\_catalog\_id](#output\_data\_catalog\_id) | n/a |
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | n/a |
| <a name="output_named_query_id"></a> [named\_query\_id](#output\_named\_query\_id) | n/a |
| <a name="output_prepared_statement_id"></a> [prepared\_statement\_id](#output\_prepared\_statement\_id) | n/a |
| <a name="output_workgroup_arn"></a> [workgroup\_arn](#output\_workgroup\_arn) | n/a |
| <a name="output_workgroup_id"></a> [workgroup\_id](#output\_workgroup\_id) | n/a |
