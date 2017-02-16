resource "aws_launch_configuration" "hackerz" {
    lifecycle { create_before_destroy = true }
    name_prefix = "hackerz-lc-"
    image_id = "ami-d8f4deab"
    instance_type = "t2.nano"

    iam_instance_profile = "${aws_iam_instance_profile.hackerz.id}"

    security_groups = ["${aws_security_group.internal.id}"]

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }
    user_data = "${file("./provisioning/hackerz.sh")}"
    key_name = "${aws_key_pair.master.key_name}"
}

resource "aws_autoscaling_group" "hackerz" {
    lifecycle { create_before_destroy = true }

    name = "rcha-hackerz-asg"
    vpc_zone_identifier = ["${aws_subnet.hackerz-a.id}", "${aws_subnet.hackerz-b.id}"]
    launch_configuration = "${aws_launch_configuration.hackerz.name}"
  
    health_check_type = "EC2"

    max_size = "10"
    min_size = "0"
    desired_capacity = "${var.hackerz_count}"
    force_delete = true
  
    termination_policies = ["NewestInstance", "Default"]
    tag {
        key                 = "Name"
        value               = "rcha-hackerz-node"
        propagate_at_launch = "true"
    }

    tag {
        key                 = "Service"
        value               = "RainbowCloudHackersAttack"
        propagate_at_launch = "true"
    }
}

