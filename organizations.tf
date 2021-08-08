resource "aws_organizations_organization" "organizations" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com"
  ]
  feature_set = "ALL"
}
