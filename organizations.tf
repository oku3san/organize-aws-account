// Enable organization with sso
resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com"
  ]
  feature_set = "ALL"
}

// Create permission sets
data "aws_ssoadmin_instances" "ssoadmin_instances" {}

resource "aws_ssoadmin_permission_set" "permission_set" {
  for_each = toset([
    "AdministratorAccess",
    "ReadOnlyAccess"
  ])
  name             = each.value
  instance_arn     = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.arns)[0]
  session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "policy_attachment" {
  for_each = aws_ssoadmin_permission_set.permission_set

  instance_arn       = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/${each.key}"
  permission_set_arn = each.value.arn
}

// Assignment
data "aws_organizations_organization" "organization" {}
data "aws_identitystore_group" "admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "admin"
  }
}
resource "aws_ssoadmin_account_assignment" "admin" {
  for_each = toset(data.aws_organizations_organization.organization.accounts[*].id)

  instance_arn       = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_set["AdministratorAccess"].arn

  principal_id   = data.aws_identitystore_group.admin.group_id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}

data "aws_identitystore_group" "readonly" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "readonly"
  }
}
resource "aws_ssoadmin_account_assignment" "readonly" {
  for_each = toset(data.aws_organizations_organization.organization.accounts[*].id)

  instance_arn       = tolist(data.aws_ssoadmin_instances.ssoadmin_instances.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_set["ReadOnlyAccess"].arn

  principal_id   = data.aws_identitystore_group.readonly.group_id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}
