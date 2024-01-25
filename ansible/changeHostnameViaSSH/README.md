### Изменение hostname через SSH

Создаем `play-book` с названием `changeHostnameViaSSH.yaml`

```
---
- name: Show version
  hosts: VMs
  tasks:
    - name: Set hostname
      ansible.builtin.hostname:
        name: {{ inventory_hostname }}
```