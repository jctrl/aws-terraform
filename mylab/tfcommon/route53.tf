resource "aws_route53_zone" "primary" {
    name = "mylab.example.com"
    provisioner "local-exec" {
    command = <<CMD_DATA
cat >> ../tfcommon/route53.tfvars <<TFVARS
# main hosted zone id
aws_route53_zone_id_primary  = ${aws_route53_zone.primary.zone_id}
TFVARS
CMD_DATA
    }
}
