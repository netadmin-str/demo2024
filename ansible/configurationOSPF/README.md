### Настройка OSPF

Создаем play-book c именем `installFRR.yaml`

```
---

- name: install FRR
  hosts: HQ-R, BR-R
  tasks:
    - name: Replase repo on DVD
      shell: |
        rm /etc/apt/sources.list.d/alt.list
        apt-repo add 'rpm-dir file:/mnt x86-64 classic'

    - name: Mount DVD-disk witch repo
      shell: |
        umount -a
        mkdir -p /mnt/x86-64/
        mount /dev/sr0 /mnt/x86-64/
        apt-get update

    - name: Install FRR
      shell: apt-get install -y frr

    - name: Enable OSPF
      shell: sed -i -e 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons

    - name: Create configuration
      template:
        src=ospf.j2
        dest=/etc/frr/frr.conf

    - name: Restart FRR
      ansible.builtin.systemd:
        name: frr
        state: restarted
```
## Теперь подробнее.


Предварительно установим дополнительный модуль `netaddr` для `python` 

```
pip install netaddr
```

Эта задача заменяет репозитории в интернете на локальные. Заметьте, то диск с репозиторием должен быть подключен к виртуальной машине

```
    - name: Replase repo on DVD
      shell: |
        rm /etc/apt/sources.list.d/alt.list
        apt-repo add 'rpm-dir file:/mnt x86-64 classic'
```

Следующим действием монтируем DVD-диск с репозиторием

```
    - name: Mount DVD-disk witch repo
      shell: |
        umount -a
        mkdir -p /mnt/x86-64/
        mount /dev/sr0 /mnt/x86-64/
        apt-get update
```

Устанавливаем `OSPF`

```
    - name: Install FRR
      shell: apt-get install -y frr
```

Включаем `OSPF` в `FRR`

```
    - name: Enable OSPF
      shell: sed -i -e 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
```

Генерируем конфигурацию для `FRR` из шаблона `Jinja2`. Шаблон предварительно должен быть создан.

Генерируем шаблон. Для этого создаем файл `ospf.j2` рядом с плайбуком

```
log file /var/log/frr/frr.log
no ipv6 forwarding
!
interface tun1
 no ip ospf passive
exit
!
router ospf
 passive-interface default
{% for item in vars.vars.interfaces %}
{% if item.ospf is defined %}
{% set ipv4_host = item.ifaddr+item.mask %}
network {{ ipv4_host | ansible.utils.ipaddr('network/prefix') }} area 0
{% endif %}
{% endfor %}
exit
!
```

Объясню что происходит.

Это блок цикла. Все что находится внутри повторится столько раз сколько записей лежит в `vars.vars.interfaces`

```
{% for item in vars.vars.interfaces %}

{% endfor %}
```

Это блок условия. Мы проверяем определена ли переменная `item.ospf`.
Она береться из инвентарного файла. Для этого мы ее туда добавим вручную чуть позже

```
{% if item.ospf is defined %}

{% endif %}
```

Этот блок создает переменную `ipv4_host` в которой храниться строка формата `X.X.X.X/XX`

```
{% set ipv4_host = item.ifaddr+item.mask %}
```

Этот блок извлекает из переменной `ipv4_host` адрес сети с префиксом

```
network {{ ipv4_host | ansible.utils.ipaddr('network/prefix') }} area 0
```

Теперь добавим в инвентарный файл метку для интерфейсов, которые будут задействованны в `OSPF`

```
    HQ-R:
      ...
      vars:
        ...
        interfaces: [
          { ifname: 'ens192', type: 'eth', ifaddr: '192.168.0.1', mask: '/25', ospf: true},
        ...
          { ifname: 'tun1', type: 'iptun', ifaddr: '172.16.0.1', mask: '/30', tunlocal: '1.1.1.2', tunremote: '2.2.2.2', interface: 'ens224', ospf: true }
        ]
    BR-R:
      ...
      vars:
        ....
        interfaces: [
          ...
          { ifname: 'ens224', type: 'eth', ifaddr: '192.168.0.129', mask: '/27', ospf: true},
          { ifname: 'tun1', type: 'iptun', ifaddr: '172.16.0.2', mask: '/30', tunlocal: '2.2.2.2', tunremote: '1.1.1.2', interface: 'ens192', ospf: true}
        ]

```

Эта задача гененируем конфигурацию OSPF для каждого хоста

```
    - name: Create configuration
      template:
        src=ospf.j2
        dest=/etc/frr/frr.conf
```

Перезагружаем FRR

```
    - name: Restart FRR
      ansible.builtin.systemd:
        name: frr
        state: restarted
```
