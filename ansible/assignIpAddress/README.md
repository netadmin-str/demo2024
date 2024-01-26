### Назначаем IP на интерфейсы

```
---

    - name: Create folder for interfaces
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
    - name: Create file options fot interfaces
      ansible.builtin.copy:
        dest: "/etc/net/ifaces/{{ item['ifname'] }}/options"
        content: "TYPE=eth
        DISABLE=no
        NM_CONTROLLED=no
        BOOTPROTO=static
        CONFIG_IPV4=yes"
        mode: '0777'
      loop: "{{ vars.vars.interfaces }}"
    - name: Enable routing
      shell:
        cmd: "sed -i -e 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/net/sysctl.conf"
    - name: Setting default gateway on Servers
      when: item['gw'] is defined
      ansible.builtin.copy:
        dest: "/etc/net/ifaces/{{ item['ifname'] }}/ipv4route"
        content: "default via {{ item['gw'] }}"
        mode: '0777'
      loop: "{{ vars.vars.interfaces }}"
    - name: Restart network
      ansible.builtin.systemd:
        name: network
        state: restarted

```