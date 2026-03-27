# Данный файл описывает основную инфраструктуру.

# Создание дисков для каждой ВМ из переменной virtual_machines
resource "yandex_compute_disk" "boot_disk" {
  for_each = var.virtual_machines
  name     = each.value["disk_name"] # имя диска для каждой ВМ из terraform.tfvars
  type     = "network-hdd" # сетевой диск в Yandex Cloud
  size     = each.value["disk"] # размер диска для каждой ВМ из terraform.tfvars
  image_id = each.value["template"] # идентификатор образа или шаблона, на основе которого будет создана ВМ
}

# Создание виртуальной сети. Нужна для подключения подсети и ВМ
resource "yandex_vpc_network" "network-s11" {
  name = "network_s11" # имя сети
}

# Создание подсети внутри сети. В этой подсети будут размещаться ВМ
resource "yandex_vpc_subnet" "subnet-s11" {
  name           = "subnet_s11" # имя подсети
  network_id     = yandex_vpc_network.network-s11.id # привязка подсети к созданой сети
  v4_cidr_blocks = var.subnet_cidr_blocks # диапазон IPv4-адресов для подсети из переменной
}

# Создание ВМ из переменной virtual_machines
resource "yandex_compute_instance" "virtual_machine" {
  for_each = var.virtual_machines
  name        = each.value.vm_name

  resources {
    cores  = each.value.vm_cpu
    memory = each.value.ram
  }

  # Подключение загрузочного диска к ВМ
  boot_disk {
    disk_id = yandex_compute_disk.boot_disk[each.key].id
  }
  
  # Сетевой интерфейс ВМ. Подключается к подсети, а nat=true включает внешний IP
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-s11.id
    nat       = true
  }

  # Метаданные, передаваемые в ВМ при создании. В данном случае задается SSH-ключ для входа
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
