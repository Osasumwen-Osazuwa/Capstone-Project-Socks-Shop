output "node_addresses" {
  value = ["${aws_instance.socks_shop_node.*.public_dns}"]
}

output "master_address" {
  value = "${aws_instance.socks_shop_master.public_dns}"
}

output "sock_shop_address" {
  value = "${aws_elb.socks-shop.dns_name}"
}