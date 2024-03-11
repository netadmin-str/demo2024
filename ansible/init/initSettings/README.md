### Начальная настройка ansible

В папке с витуальным окружением создайте файл `ansible.cfg` со следующим содержимом

```
[defaults]

inventory = ./hosts.yaml
ask_pass = False
host_key_checking = False
```



В той же папке создайте файл `hosts.yaml` и добавьте в него свой ESXi сервер и виртуальные машины

```
all:
  vars:
    esxi_hostname: "10.12.66.1"
    esxi_username: "root"
    esxi_password: "P@ssw0rd"
    esxi_datastore: "Data_str"
    vms_username: "root"
    vms_user_password: "P@ssw0rd"
VMs:
  hosts:
    ISP:
      ansible_ssh_host: 10.15.15.2
      vars:
        routing: true
        interfaces: [
          { type: 'eth', ifaddr: '1.1.1.1', mask: '/30', network_name: 'ansible_net10'},
          { type: 'eth', ifaddr: '2.2.2.1', mask: '/30', network_name: 'ansible_net20'},
          { type: 'eth', ifaddr: '94.41.92.1', mask: '/24', network_name: 'ansible_net50'},
        ]
        internet: { type: 'eth', ifaddr: '10.12.66.2', mask: '/24', gw: '10.12.66.254', network_name: "VM_network" }
    HQ-R:
      ansible_ssh_host: 10.15.15.3
      vars:
        routing: true
        interfaces: [
          { type: 'eth', ifaddr: '192.168.0.1', mask: '/25', network_name: 'ansible_net30'},
          { type: 'eth', ifaddr: '1.1.1.2', mask: '/30', network_name: 'ansible_net10', gw: '1.1.1.1'},
        ]
        tunnels: [
          { type: 'iptun', ifname: 'tunnel1', ifaddr: '172.16.0.1', mask: '/30', tunlocal: '1.1.1.2', tunremote: '2.2.2.2', interface: 'ens224', ospf: true }
        ]
        pkg: [ 'frr', iperf3 ]
    BR-R:
      ansible_ssh_host: 10.15.15.4
      vars:
        routing: true
        interfaces: [
          { type: 'eth', ifaddr: '2.2.2.2', mask: '/30', network_name: 'ansible_net20', gw: '2.2.2.1'},
          { type: 'eth', ifaddr: '192.168.0.129', mask: '/27', network_name: 'ansible_net40'},
        ]
        tunnels: [
          { type: 'iptun', ifname: 'tunnel1', ifaddr: '172.16.0.2', mask: '/30', tunlocal: '2.2.2.2', tunremote: '1.1.1.2', interface: 'ens192', ospf: true}
        ]
        pkg: [ 'frr', iperf3 ]
    HQ-SRV:
      ansible_ssh_host: 10.15.15.5
      vars:
        interfaces: [
          { type: 'eth', ifaddr: '192.168.0.2', mask: '/25', network_name: 'ansible_net30', gw: '192.168.0.1'}
        ]
    BR-SRV:
      ansible_ssh_host: 10.15.15.6
      vars:
        interfaces: [
          { type: 'eth', ifaddr: '192.168.0.130', mask: '/27', network_name: 'ansible_net40', gw: '192.168.0.129'}
        ] 
  vars:
    ansible_connection: ssh 
    ansible_user: root
    ansible_password: P@ssw0rd
esxis:
  hosts:
    esxi:
      ansible_ssh_host: 10.12.66.1
      vars:
        vswitchs: [
          {
            name: "INNER_ANSIBLE",
            port_groups: [
              { name: 'ansible_net10', vlan: '10' },
              { name: 'ansible_net20', vlan: '20' },
              { name: 'ansible_net30', vlan: '30' },
              { name: 'ansible_net40', vlan: '40' },
              { name: 'ansible_net50', vlan: '50' },
            ],
          }
        ]
  vars:
    ansible_connection: ssh 
    ansible_user: root
    ansible_password: P@ssw0rd
    
localhost:
  hosts:
    localhost:
      ansible_connection: local

```

Давате разберем этот конфиг по частям, чтобы узнать что за что отвечает.

### Раздел all:
```
all:
  vars:
    esxi_hostname: "10.12.66.1"
    esxi_username: "root"
    esxi_password: "P@ssw0rd"
    esxi_datastore: "Data_str"
    vms_username: "root"
    vms_user_password: "P@ssw0rd"
```

Это общие переменные, которые понадобятся для всех устройств.

`esxi_hostname: "10.12.66.1"` - IP вашего сервера ESXi, где будут распологаться виртуальные машины

`esxi_username: "root"` - имя пользователя для сервера ESXi

`esxi_password: "P@ssw0rd"` - пароль для пользователя ESXi

`esxi_datastore: "Data_str"` - имя диска, на котором будут размещаться виртуалки. Посмотреть можно в Storage -> Datastores на хосте ESXi

`vms_username: "root"` - пользователь под которым будут администрироваться виртуалки

`vms_user_password: "P@ssw0rd"` - пароль пользователя под которым будут администрироваться виртуалки. Задается в настройках самой ОС на виртуальной машине

Параметры `vms_username:` `vms_user_password:` используются для подключения к виртуальной машине через ESXi, даже при условие, что ANSIBLE не имеет связи с виртуалкой и нет ни одного сетевого интерфейса на виртуальной машине. Этот способ не совсем удобен, потому что не позволяет получить результат выполнения команд и отсутствие `иденпотентности` (страшное и смешное слово, которе вы пока не знаете). Его будем использовать для начальной конфигурации виртуалок. 

### Раздел VMs:

Разберем на примере ISP

```
VMs:
  hosts:
    ISP:
      ansible_ssh_host: 10.15.15.2
      vars:
        routing: true
        interfaces: [
          { type: 'eth', ifaddr: '1.1.1.1', mask: '/30', network_name: 'ansible_net10'},
          { type: 'eth', ifaddr: '2.2.2.1', mask: '/30', network_name: 'ansible_net20'},
          { type: 'eth', ifaddr: '94.41.92.1', mask: '/24', network_name: 'ansible_net50'},
        ]
        internet: { type: 'eth', ifaddr: '10.12.66.2', mask: '/24', gw: '10.12.66.254', network_name: "VM_network" }
...
  vars:
    ansible_connection: ssh 
    ansible_user: root
    ansible_password: P@ssw0rd 
```

`hosts` - Здесь хранятся настройки виртуальных машин

`vars` - Здесь хранятся настройки для подключения ANSIBLE к виртуальным машинам

В разделе `hosts` перечислены названия виртуальных машин. Например вот так.

```
hosts:
  ISP:
  HQ-SRV:
  HQ-R:
  BR-R:
  BR-SRV:
```

В каждой виртуальной машине создадим еще две переменные. Например вот так.

```
hosts:
  ISP:
    ansible_ssh_host: 10.15.15.2
    vars:
```

`ansible_ssh_host: 10.15.15.2` - переменная для подключения к виртуальной машине по SSH. Для этого на виртуалках создадим дополнительный интерфейс.

`vars` - переменная в которую можем накидывать любые другие параметры, которые будем использовать конкретно для этой виртуалки.

Например вот так

```
vars:
  interfaces: [
    { type: 'eth', ifaddr: '1.1.1.1', mask: '/30', network_name: 'ansible_net10'},
    { type: 'eth', ifaddr: '2.2.2.1', mask: '/30', network_name: 'ansible_net20'},
    { type: 'eth', ifaddr: '94.41.92.1', mask: '/24', network_name: 'ansible_net50'},
  ]
  internet: { type: 'eth', ifaddr: '10.12.66.2', mask: '/24', gw: '10.12.66.254', network_name: "VM_network" }
```

### Разберем раздел `interfaces`

Это список интерфейсов. Каждый элемент этого списка это словарь c параметрами одного интерфейса

```
{ type: 'eth', ifaddr: '1.1.1.1', mask: '/30', network_name: 'ansible_net10'}
```

`type` - тип интерфейса

`ifaddr` - ip который будем назначать на интерфейс

`mask` - маска для ip адреса

`network_name` - порт-группа в `ESXi` к которой будет подключен интерфейс. Важно чтобы это название было таким же как параметры `port_groups` в разделе `esxi` или названия порт-групп, которые вы создадите вручную на сервере `ESXi`


### Раздел tunnels

На некоторых виртуалках будут туннели. Создадим для них отдельную переменную в разделе `vars` конкретной виртуальной машины

```
tunnels: [
  { type: 'iptun', ifname: 'tunnel1', ifaddr: '172.16.0.2', mask: '/30', tunlocal: '2.2.2.2', tunremote: '1.1.1.2', interface: 'ens192', ospf: true}
]
```

Структура похожа на обычные интерфейсы, за исключением того, что добавилиь IP начала и конца туннеля. Обратите внимание, что на разных виртуалках они будут отличаться.


### Раздел ESXis

```
esxis:
  hosts:
    esxi:
      ansible_ssh_host: 10.12.66.1
      vars:
        vswitchs: [
          {
            name: "INNER_ANSIBLE",
            port_groups: [
              { name: 'ansible_net10', vlan: '10' },
              { name: 'ansible_net20', vlan: '20' },
              { name: 'ansible_net30', vlan: '30' },
              { name: 'ansible_net40', vlan: '40' },
              { name: 'ansible_net50', vlan: '50' },
            ],
          }
        ]
  vars:
    ansible_connection: ssh 
    ansible_user: root
    ansible_password: P@ssw0rd
```

`vswitchs:` - Список виртуальных свичей, которые будем создавать. Для данной работы одного будет достаточно

`name` - имя добавляемго виртуального свича

`port_groups` - список порт-групп, которые создаем на новом виртуальном свиче. Важно, чтобы названия совпадали с названиями `network_name` в параметрах виртуальных машин