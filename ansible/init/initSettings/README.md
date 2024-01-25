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
10.15.15.2 hostname=ISP
10.15.15.3 hostname=HQ-R
10.15.15.4 hostname=BR-R
10.15.15.5 hostname=HQ-SRV
10.15.15.6 hostname=BR-SRV

[VMs:vars]
ansible_connection=ssh 
ansible_user=root
ansible_password=P@ssw0rd
```