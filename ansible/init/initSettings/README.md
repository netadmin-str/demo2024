### Начальная настройка ansible

В папке с витуальным окружением создайте файл `ansible.cfg` со следующим содержимом

```
[defaults]

inventory = ./hosts.ini
ask_pass = False
host_key_checking = False
```

В тойже папке создайте файл `hosts.ini` и добавьте в него свой ESXi сервер и виртуальные машины

```
[esxi]
10.12.66.1

[VMs]
ISP ansible_ssh_host=10.15.15.2
HQ-R ansible_ssh_host=10.15.15.3
BR-R ansible_ssh_host=10.15.15.4
HQ-SRV ansible_ssh_host=10.15.15.5
BR-SRV ansible_ssh_host=10.15.15.6

[VMs:vars]
ansible_connection=ssh 
ansible_user=root
ansible_password=P@ssw0rd
```