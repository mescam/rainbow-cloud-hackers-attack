resource "aws_launch_configuration" "seekerz" {
    lifecycle { create_before_destroy = true }
    name_prefix = "seekerz-lc-"
    image_id = "ami-d8f4deab"
    instance_type = "t2.nano"

    iam_instance_profile = "${aws_iam_instance_profile.seekerz.id}"

    security_groups = ["${aws_security_group.internal.id}"]

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    key_name = "${aws_key_pair.master.key_name}"
    user_data = "${file("./provisioning/seekerz.sh")}"
}

resource "aws_autoscaling_group" "seekerz" {
    lifecycle { create_before_destroy = true }

    name = "rcha-seekerz-asg"
    vpc_zone_identifier = ["${aws_subnet.seekerz-a.id}", "${aws_subnet.seekerz-b.id}"]
    launch_configuration = "${aws_launch_configuration.seekerz.name}"
  
    health_check_type = "EC2"

    max_size = "10"
    min_size = "0"
    desired_capacity = "${var.seekerz_count}"
    force_delete = true
  
    termination_policies = ["NewestInstance", "Default"]
    tag {
        key                 = "Name"
        value               = "rcha-seekerz-node"
        propagate_at_launch = "true"
    }

    tag {
        key                 = "Service"
        value               = "RainbowCloudHackersAttack"
        propagate_at_launch = "true"
    }
}

