# В этом файле объявляются переменные модуля: их имена, типы, значения по умолчанию и ограничения
# Указываем пользователя для подключения к виртуальным машинам по SSH
variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

# Указываем путь к публичному SSH-ключу для подключения к ВМ
variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

# Список CIDR-блоков для подсети. Задаем диапазон IP-адресов, которые будут доступны внутри сети.
# Значение вводится в виде списка строк. Можно указывать несколько диапазонов через запятую.
variable "subnet_cidr_blocks" {
  type    = list(string)
  default = ["192.168.10.0/24"]
}

# Описание набора виртуальных машин в виде словаря.
# Структура object с набором полей для каждой ВМ
variable "virtual_machines" {
  type = map(object({
    vm_name   = string # имя ВМ
    vm_role   = string # роль машины, например proxy, backend
    vm_cpu    = number # число vCPU
    ram       = number # объем RAM
    disk      = number # размер диска
    disk_name = string # имя диска
    template  = string # шаблон или образ, по которому создается ВМ
  }))

# Выполняется проверка корректности значения vm_role для каждой ВМ. Защита от ошибок в наименовании роли машины.
# alltrue означает, что все элементы проверяемого списка должны быть true
  validation {
    condition = alltrue([
      for vm in values(var.virtual_machines) :
      contains(["proxy", "backend"], vm.vm_role)
    ])
    error_message = "Для каждой виртуальной машины значение vm_role должно быть proxy или backend."
  }
}
