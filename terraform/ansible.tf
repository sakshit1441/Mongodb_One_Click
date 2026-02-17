resource "local_file" "ansible_inventory" {
  content  = <<EOT
[mongodb]
%{ for ip in module.compute.private_ips ~}
mongodb-${replace(ip, ".", "-")} ansible_host=${ip} ansible_user=${var.ansible_user}
%{ endfor ~}

[mongodb:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${var.ssh_key_path} -W %h:%p -q -o StrictHostKeyChecking=no ubuntu@${module.bastion.bastion_public_ip}"'
ansible_python_interpreter=/usr/bin/python3
EOT
  filename = var.inventory_file
  directory_permission = "0777"
  file_permission      = "0777"
}
