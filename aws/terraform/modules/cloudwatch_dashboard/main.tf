// CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.dashboard_name
  dashboard_body = data.template_file.dashboard.rendered
}

// CloudWatch dashboard template
data "template_file" "dashboard" {
  template = file("${path.module}/dashboard.json")
  vars = {
    region                   = var.config.region
    setlink-function-name    = var.config.setlink-function-name
    getlink-function-name    = var.config.getlink-function-name
    deletelink-function-name = var.config.deletelink-function-name
    links-table-name         = var.config.links-table-name
  }
}
