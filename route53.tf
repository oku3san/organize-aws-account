resource "aws_route53_zone" "main_public" {
  name = aws_ssm_parameter.domain.value
}
