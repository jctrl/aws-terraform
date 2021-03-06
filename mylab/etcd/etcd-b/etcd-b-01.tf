resource "aws_instance" "etcd-b-01" {
    #depends_on = [ "aws_instance.etcd-a-01" ]
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    block_device = {
        device_name = "/dev/sdb"
        volume_type = "gp2"
        volume_size = "50"
    }
    key_name = "${var.aws_ec2_keypair.etcd}"
    security_groups = [ "${var.security_group_etcd}" ]
    # associate_public_ip_address = true: 
    # Error launching source instance: Network interfaces and an instance-level private IP address may not be specified on the same 
    # request (InvalidParameterCombination). Workaround: turn on associate_public_ip_address for each subnet
    private_ip = "${var.etcd_private_ip.us-west-2b}"
    subnet_id = "${var.subnet_core-us-west-2b}"
    iam_instance_profile = "${var.iam_instance_profile.etcd}"
    user_data = <<USER_DATA
${file("cloud-config/etcd.yaml")}
${file("../../common/cloud-config/systemd-units.yaml")}
${file("../../common/cloud-config/files.yaml")}
USER_DATA

    tags {
        Name="docker-etcd-b-01"
    }
}
