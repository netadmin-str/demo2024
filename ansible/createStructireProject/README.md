### Создание молудей проекта

Сейчас все наш сценарий хранится в одном файле. Со временем в файл вы будите добавлять новые задачи. Что затруднит ориентацию в этотм сценарии. Поэтому разделим весь сценарий на части

Для этого в корневой папке вашего проекта создадим папку `tasks`

В этой папке создадим следующие файлы:

```
setHostname.yaml
enableRouting.yaml
setIpAddress.yaml
setDefaultGateway.yaml
restartNetwork.yaml
```

Теперь наполним созданные файлы следующим содержимом

`setHostname.yaml`

```
---

- name: Set hostname
  ansible.builtin.hostname:
    name: "{{ inventory_hostname }}"
```

`enableRouting.yaml`

```
---

- name: Enable routing
  shell:
    cmd: "sed -i -e 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/net/sysctl.conf"

```

`setIpAddress.yaml`

```
---

- name: Creating a folder for interfaces
  ansible.builtin.file:
    path: "/etc/net/ifaces/{{ item['ifname'] }}"
    state: directory
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
- name: Creating a file with IP address
  ansible.builtin.copy:
    dest: "/etc/net/ifaces/{{ item['ifname'] }}/ipv4address"
    content: "{{ item['ifaddr']+item['mask'] }}"
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
- name: Creating a file options for interfaces
  ansible.builtin.copy:
    dest: "/etc/net/ifaces/{{ item['ifname'] }}/options"
    content: "TYPE=eth
    DISABLE=no
    NM_CONTROLLED=no
    BOOTPROTO=static
    CONFIG_IPV4=yes"
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
```

`setDefaultGateway.yaml`

```
---

- name: Setting default gateway on Servers
  when: item['gw'] is defined
  ansible.builtin.copy:
    dest: "/etc/net/ifaces/{{ item['ifname'] }}/ipv4route"
    content: "default via {{ item['gw'] }}"
    mode: '0777'
  loop: "{{ vars.vars.interfaces }}"
```

`restartNetwork.yaml`

```
---

- name: Restart network
  ansible.builtin.systemd:
    name: network
    state: restarted
```

## Теперь объединим все эти задачи в один `playbook`

в папке `/playbook` создадим файл `initSettings.yaml`

```
---

- name: Init settings
  hosts: VMs
  tasks:
    - include_tasks: tasks/setHostname.yaml
    - include_tasks: tasks/enableRouting.yaml
    - include_tasks: tasks/setIpAddress.yaml
    - include_tasks: tasks/setDefaultGateway.yaml
    - include_tasks: tasks/restartNetwork.yaml
```

тем самым мы сделали такой же сценарий, но теперь проще его воспринимать и масштабировать