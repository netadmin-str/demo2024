### Создание туннельных интерфейсов.

Перед написанием сценария нужно добавить тунельные интерфейсы в инвентарный файл.

Но в дальнешем мы сталкнемся с проблемой как программой поймет что это туннельный интерфейс ведь настройка обычного интерфейса и туннельного отличается.

Поэтому предварительно у `каждого` интерфейса в инвентарном файле укажем его тип:

```
{ ifname: 'ens192', type: 'eth', ifaddr: '2.2.2.2', mask: '/30', gw: '2.2.2.1'}
```

После этого добавим на `HQ-R` и `BR-R` информацию о туннельных интерфейсах. Будте внимательный с названием интерфеса к которому привязываем туннель.

```
HQ-R:
    ansible_ssh_host: 10.15.15.3
    vars:
    interfaces: [
        { ifname: 'ens192', type: 'eth', ifaddr: '192.168.0.1', mask: '/25'},
        { ifname: 'ens224', type: 'eth', ifaddr: '1.1.1.2', mask: '/30', gw: '1.1.1.1'},
        { ifname: 'tun1', type: 'iptun', ifaddr: '172.16.0.1', mask: '/30', tunlocal: '1.1.1.2', tunremote: '2.2.2.2', interface: 'ens224'}
    ]
BR-R:
    ansible_ssh_host: 10.15.15.4
    vars:
    interfaces: [
        { ifname: 'ens192', type: 'eth', ifaddr: '2.2.2.2', mask: '/30', gw: '2.2.2.1'},
        { ifname: 'ens224', type: 'eth', ifaddr: '192.168.0.129', mask: '/27'},
        { ifname: 'tun1', type: 'iptun', ifaddr: '172.16.0.2', mask: '/30', tunlocal: '2.2.2.2', tunremote: '1.1.1.2', interface: 'ens192'}
    ]
```

## Написание сценария

Внесем изменения в файл `setIpAddress.yaml` таким образом чтобы задача по созданию файла `options` выполнялась по условию

```
- name: Creating a file options for  ether interfaces
  when: item['type'] == 'eth' # Выполнится только для интерфейсов с типом eth
  ansible.builtin.copy:
    dest: "/etc/net/ifaces/{{ item['ifname'] }}/options"
    content: "TYPE=eth
    DISABLE=no
    NM_CONTROLLED=no
    BOOTPROTO=static
    CONFIG_IPV4=yes"
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
- name: Creating a file options for tunnel interfaces
  when: item['type'] == 'iptun' # Выполнится для интерфесов с типом iptun
  ansible.builtin.copy:
    dest: "/etc/net/ifaces/{{ item['ifname'] }}/options"
    content: "TYPE=iptun
      TUNTYPE=gre
      TUNLOCAL={{ item['tunlocal'] }}
      TUNREMOTE={{ item['tunremote'] }}
      TUNOPTIONS='ttl 64'
      HOST={{ item['interface'] }}"
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
```
