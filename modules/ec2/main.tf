# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# META-ARGUMENT EXAMPLE: depends_on
# EC2 instances depend on VPC subnet creation
# This ensures resources are created in the correct order

resource "aws_instance" "main" {
  count              = var.instance_count
  ami                = data.aws_ami.amazon_linux_2.id
  instance_type      = var.instance_type
  subnet_id          = var.subnet_ids[count.index % length(var.subnet_ids)]
  security_groups    = var.security_group_ids
  iam_instance_profile = aws_iam_instance_profile.main.name

  # META-ARGUMENT: depends_on
  # Explicitly state dependencies (usually implicit through references)
  depends_on = [
    aws_iam_role.main
  ]

  # User data script
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    instance_index = count.index + 1
    environment    = var.environment
  }))

  # META-ARGUMENT: lifecycle
  # Ignore changes to tags after creation
  lifecycle {
    ignore_changes = [
      tags["LastModified"]
    ]
  }

  tags = {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  }
}

# IAM role for EC2 instances (demonstrating dependency)
resource "aws_iam_role" "main" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# IAM instance profile
resource "aws_iam_instance_profile" "main" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.main.name
}

# Attach policy for SSM access
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CloudWatch monitoring
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count               = var.instance_count
  alarm_name          = "${var.project_name}-cpu-alarm-${count.index + 1}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.main[count.index].id
  }

  depends_on = [
    aws_instance.main
  ]
}
