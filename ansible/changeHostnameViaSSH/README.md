### Изменение hostname через SSH

Создаем `play-book` с названием `changeHostnameViaSSH.yaml`

```
---

- name: show version
  hosts: VMs
  tasks:
  - name: "update hostnames"
    hostname:
      name: "{{ hostname }}" # Эта переменная берется из hosts.ini
```