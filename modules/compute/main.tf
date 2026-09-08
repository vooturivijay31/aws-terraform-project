data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-${var.environment}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      environment = var.environment
    })
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-${var.environment}-web"
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name = "${var.project_name}-${var.environment}-asg"

  min_size         = var.min_instances
  desired_capacity = var.desired_instances
  max_size         = var.max_instances

  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [var.target_group_arn]

  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}