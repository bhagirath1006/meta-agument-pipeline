# META-ARGUMENT EXAMPLE: for_each
# Creates multiple security groups from a map
# Demonstrates: for_each, dynamic blocks

resource "aws_security_group" "main" {
  for_each    = var.security_groups
  name        = "${var.project_name}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# Ingress rules - Flatten approach for handling multiple rules
resource "aws_security_group_rule" "ingress_flattened" {
  for_each = {
    for rule in flatten([
      for sg_key, sg_value in var.security_groups : [
        for idx, rule in sg_value.ingress : {
          sg_key      = sg_key
          idx         = idx
          protocol    = rule.protocol
          from_port   = rule.from_port
          to_port     = rule.to_port
          cidr_blocks = rule.cidr_blocks
        }
      ]
    ]) : "${rule.sg_key}-${rule.idx}" => rule
  }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.main[each.value.sg_key].id
}

# Egress rule for all security groups
resource "aws_security_group_rule" "egress" {
  for_each = aws_security_group.main

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = each.value.id
}
