resource "aws_dynamodb_table" "dynamodb" {
  name         = var.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  # Set max read and write request limits (no limit if commented out)
  /*
  on_demand_throughput {
    max_read_request_units  = 1
    max_write_request_units = 1
  }
  */

  attribute {
    name = "ID"
    type = "S" # String
  }

  # This attribute is in use, but cannot be defined here.
  #attribute {
  #  name = "URL"
  #  type = "S"  # String
  #}

  # Unix epoch time format. https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html
  # Expired items are still visible but will be deleted withing a few days.
  ttl {
    attribute_name = "TTL"
    enabled        = true
  }
}
