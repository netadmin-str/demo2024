### Изменение hostname через SSH

Создаем `play-book` с названием `changeHostnameViaSSH.yaml`

```
---
- name: Init settings
  hosts: VMs
  tasks:
  - name: Set hostname
    ansible.builtin.hostname:
      name: "{{ inventory_hostname }}"
```

Проверяем ``