resource "aws_security_group" "sg" {
    name        = local.sg_name_final
    description = var.sg_description
    vpc_id      = var.vpc_id
    
    #this is block
    dynamic "ingress" {
        for_each = var.inbound_rules
        content {
            from_port        = ingress.value["from_port"]    #each.value[<key-name>]
            to_port          = ingress.value["to_port"]
            protocol         = ingress.value["protocol"]
            cidr_blocks      = ingress.value["cidr_blocks"]

        }
        
    }

    egress {
        from_port        = 0 # from 0 to 0 means opening all ports
        to_port          = 0
        protocol         = "-1" # -1 means all protocols
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = merge(
        var.common_tags,
        var.sg_tags,
        {
            Name = "${var.project_name}-${var.environment}"
        }
    )
}