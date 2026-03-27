# В данном файле задаются выходные значения Terraform, после apply.

# Выходная переменная с внутренними IP-адресами всех созданных ВМ
output "vm_ip" {
  description = "Внутренние IP-адреса созданных VM"
  value = {
    for k, v in yandex_compute_instance.virtual_machine :
    k => v.network_interface[0].ip_address
  }
}

# Выходная переменная с внешними IP-адресами всех созданных ВМ
output "vm_nat_ip" {
  description = "Внешние IP-адреса созданных VM"
  value = {
    for k, v in yandex_compute_instance.virtual_machine :
    k => v.network_interface[0].nat_ip_address
  }
}
