output "data_catalog_id" {
  value = try(aws_athena_data_catalog.this.*.id)
}

output "data_catalog_arn" {
  value = try(aws_athena_data_catalog.this.*.arn)
}

output "database_id" {
  value = try(aws_athena_database.this.*.id)
}

output "named_query_id" {
  value = try(aws_athena_named_query.this.*.id)
}

output "prepared_statement_id" {
  value = try(aws_athena_prepared_statement.this.*.id)
}

output "workgroup_id" {
  value = try(aws_athena_workgroup.this.*.id)
}

output "workgroup_arn" {
  value = try(aws_athena_workgroup.this.*.arn)
}
