# Монтируем локальный репозиторий на DVD диске


Законченный `play-book`:
```
---

- name: Подключаем репозиторой на DVD диске.
  hosts: VMs
  gather_facts: no
  tasks:
    - name: Выключаем виртуальные машины
      community.vmware.vmware_guest:
        validate_certs: false
        hostname: '{{ esxi_hostname }}'
        username: '{{ esxi_username }}'
        password: '{{ esxi_password }}'
        name: "{{ inventory_hostname }}"
        state: poweredoff
      delegate_to: localhost

    - name: Подключаем DVD с репозиторием
      community.vmware.vmware_guest:
        validate_certs: false
        hostname: '{{ esxi_hostname }}'
        username: '{{ esxi_username }}'
        password: '{{ esxi_password }}'
        name: "{{ inventory_hostname }}"
        cdrom:
          - controller_number: 0
            unit_number: 0
            state: present
            type: iso
            iso_path: "[{{ esxi_datastore }}] ALT Linux 10.1 repo.iso"
      delegate_to: localhost

    - name: Включаем виртуальные машины
      community.vmware.vmware_guest:
        validate_certs: false
        hostname: '{{ esxi_hostname }}'
        username: '{{ esxi_username }}'
        password: '{{ esxi_password }}'
        name: "{{ inventory_hostname }}"
        state: poweredon
      delegate_to: localhost

    - name: Пауза 20 секунд для дозагрузки виртуалок
      ansible.builtin.pause:
        seconds: 20

    - name: Меняем репозиторий на DVD диск
      shell: |
        rm /etc/apt/sources.list.d/alt.list
        apt-repo add 'rpm-dir file:/mnt x86-64 classic'

    - name: Монтируем DVD диск с репозиторием в директорию /mnt/x86-64/
      shell: |
        umount -a
        mkdir -p /mnt/x86-64/
        mount /dev/sr0 /mnt/x86-64/
        apt-get update
```