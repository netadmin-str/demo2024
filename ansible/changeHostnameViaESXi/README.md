### Изменение hostname на виртуальной машине через ESXi

Для того, чтобы данный способ работал нужно на виртуалку установить `open-vm-tools-desktop`

В папке с виртуальным окружение создайте `playbook` с название `changeHostname.yaml`

```
---

- name: Настрока hostname
  hosts: esxi
  connection: local
  tasks:
    - name: Меняем имя хоста
      community.vmware.vmware_vm_shell:
        validate_certs: no
        hostname: "10.12.66.1"  # IP вашего ESXi
        username: "root" # Имя пользователя для ESXi
        password: "P@ssw0rd" # Пароль пользователя для ESXi
        vm_id: "DEMO-ISP - 5001" # Имя виртуальной машины
        vm_username: root # Имя пользователя для виртуальной машины
        vm_password: P@ssw0rd # Пароль пользователя для виртуальной машины
        vm_shell: "/usr/bin/hostnamectl" # Полный путь до команды
        vm_shell_args: "set-hostname ISP-22" # Аргументы команды
      delegate_to: localhost
```

Запускаем скрипт

```
ansible-playbook changeHostname.yaml 
```

Результат:

<p align="center">
  <img src="./pic1.png">
</p>

Также проверьте, что имя хоста изменилась на виртуалке