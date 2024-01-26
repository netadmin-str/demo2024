### Начальная настройка ansible

В папке с витуальным окружением создайте файл `ansible.cfg` со следующим содержимом

```
[defaults]

inventory = ./hosts.yaml
ask_pass = False
host_key_checking = False
```

В тойже папке создайте файл `hosts.yaml` и добавьте в него свой ESXi сервер и виртуальные машины

```
VMs:
  hosts:
    ISP:
      ansible_ssh_host: 10.15.15.2
      vars:
        interfaces: [
          { ifname: 'ens161', ifaddr: '2.2.2.1', mask: '/30'},
          { ifname: 'ens192', ifaddr: '10.12.66.2', mask: '/24'},
          { ifname: 'ens224', ifaddr: '1.1.1.1', mask: '/30'},
          { ifname: 'ens256', ifaddr: '94.41.92.1', mask: '/24'}
        ]
    HQ-R:
      ansible_ssh_host: 10.15.15.3
      vars:
        interfaces: [
          { ifname: 'ens192', ifaddr: '192.168.0.1', mask: '/25'},
          { ifname: 'ens224', ifaddr: '1.1.1.2', mask: '/30'}
        ]
    BR-R:
      ansible_ssh_host: 10.15.15.4
      vars:
        interfaces: [
          { ifname: 'ens192', ifaddr: '2.2.2.2', mask: '/30'},
          { ifname: 'ens224', ifaddr: '192.168.0.129', mask: '/27'}
        ]
    HQ-SRV:
      ansible_ssh_host: 10.15.15.5
      vars:
        interfaces: [
          { ifname: 'ens192', ifaddr: '192.168.0.2', mask: '/25'}
        ]
        gw: '192.168.0.1'
    BR-SRV:
      ansible_ssh_host: 10.15.15.6
      vars:
        interfaces: [
          { ifname: 'ens192', ifaddr: '192.168.0.130', mask: '/27'}
        ]
      gw: '192.168.0.129'
  vars:
    ansible_connection: ssh 
    ansible_user: root
    ansible_password: P@ssw0rd

cisco_host:
  hosts:
    R1:
      ansible_ssh_host: 10.15.15.9
  vars:
    ansible_connection: network_cli
    ansible_network_os: ios
    ansible_user: admin
    ansible_password: cisco
```