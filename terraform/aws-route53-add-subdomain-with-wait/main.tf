provider "aws" {
    region     = "${var.AWS_REGION}"
}

locals {
    lb_name = "${replace(var.SANDBOX_DNS, "/(.*?)(-\\d+)(\\..+?\\.elb\\.amazonaws\\.com$)/", "$1")}" 
}

data "aws_route53_zone" "primary_zone" {
    name = "${var.DNS_ZONE_NAME}"          # "test.com."
    private_zone="${var.IS_PRIVATE_ZONE}"
}

data "aws_lb" "sandbox_alb" {
    name = "${local.lb_name}"
}

resource "null_resource" "wait_until_subdomain_doesnt_exist" {
    provisioner "local-exec" {
        command = <<EOF
            apt-get install jq -y

            timeout=600
            wait_interval=5
            domain="${var.DNS_ZONE_NAME}"
            subdomain="${var.SUBDOMAIN}"

            for (( c=0 ; c<$timeout ; c=c+$wait_interval ))	
            do
                status=$(aws route53 list-resource-record-sets --hosted-zone-id "${data.aws_route53_zone.primary_zone.zone_id}" --query "ResourceRecordSets[?Name == '$subdomain.$domain']|[?Type == 'A']" | jq 'any')
                if [[ "$status" == "true" ]]
                then
                    # domain exists, waiting
                    let remaining=$wait_sec-$c
                    echo "Domain $subdomain.$domain exists, sleeping for $wait_interval. Remaining timeout is $remaining seconds."
                    unset status  # reset the $status var
                    
                    sleep $wait_interval
                else
                    # url not exists, exit loop
                    echo "Domain doesnt exist, exiting wait loop"
                    break
                fi
            done
        EOF
  }
}

resource "aws_route53_record" "sub_domain" {
    zone_id = "${data.aws_route53_zone.primary_zone.zone_id}" # Replace with your zone ID
    name    = "${var.SUBDOMAIN}" # "sub.example.com" # Replace with your name/domain/subdomain
    type    = "A"
    alias {
        name                   = "${var.SANDBOX_DNS}"
        zone_id                = "${data.aws_lb.sandbox_alb.zone_id}"
        evaluate_target_health = true
    }

    depends_on = ["null_resource.wait_until_subdomain_doesnt_exist"]
}