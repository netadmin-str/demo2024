### Настрока шлюза по умолчанию и туннельных интерфейсов

```
---

- name: Настраиваем DG для виртуальных машин
  hosts: VMs
  tasks:
    - name: Устанавливаем default_interface
      when:
        - ansible_facts[item].ipv4.address is defined
        - vars.vars.interfaces | selectattr('gw','defined')
        - vars.vars.interfaces | selectattr('gw','defined') | map(attribute='ifaddr') | first == ansible_facts[item].ipv4.address
      ansible.builtin.set_fact:
        default_interface: "{{ item }}"
        default_ip: "{{vars.vars.interfaces | selectattr('gw','defined') | map(attribute='gw') | first}}"
      loop: "{{ ansible_facts.interfaces }}"

    - name: Настраиваем шлюз для устройств
      when: default_interface is defined
      ansible.builtin.copy:
        dest: "/etc/net/ifaces/{{ default_interface }}/ipv4route"
        content: "default via {{ default_ip }}"
        mode: '0777'

    - name: Включаем маршрутизацию
      shell:
        cmd: "sed -i -e 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/net/sysctl.conf"

    - name: Перезагружаем сеть
      ansible.builtin.systemd:
        name: network
        state: restarted

- name: Настраиваем Tunnel для виртуальных машин
  hosts: VMs
  tasks:
    - name: Creating a folder for interfaces
      when: vars.vars.tunnels is defined
      ansible.builtin.file:
        path: "/etc/net/ifaces/{{ item['ifname'] }}"
        state: directory
        mode: '0777'
      loop: "{{ vars.vars.tunnels }}"

    - name: Creating a file with IP address
      when: vars.vars.tunnels is defined
      ansible.builtin.copy:
        dest: "/etc/net/ifaces/{{ item['ifname'] }}/ipv4address"
        content: "{{ item['ifaddr']+item['mask'] }}"
        mode: '0777'
      loop: "{{ vars.vars.tunnels }}"

    - name: Creating a file options for tunnel interfaces
      when: vars.vars.tunnels is defined
      ansible.builtin.copy:
        dest: "/etc/net/ifaces/{{ item['ifname'] }}/options"
        content: "TYPE=iptun
          TUNTYPE=gre
          TUNLOCAL={{ item['tunlocal'] }}
          TUNREMOTE={{ item['tunremote'] }}
          TUNOPTIONS='ttl 64'
          HOST={{ default_interface }}"
        mode: '0777'
      loop: "{{ vars.vars.tunnels }}"

    - name: Перезагружаем сеть
      ansible.builtin.systemd:
        name: network
        state: restarted
```