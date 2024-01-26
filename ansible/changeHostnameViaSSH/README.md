### Изменение hostname через SSH

Создаем `play-book` с названием `changeHostnameViaSSH.yaml`

```
---

- name: Init settings
  hosts: VMs
  tags:
    - skip_ansible_lint
  tasks:
    - name: Set hostname
      ansible.builtin.hostname:
        name: "{{ inventory_hostname }}"
```