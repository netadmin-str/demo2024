# Изменение hostname

Итоговый `play-book`

```
---

- name: Настройка hostname
  hosts: VMs
  tasks:
    - name: Меняем имя хоста
      ansible.builtin.hostname:
        name: "{{ inventory_hostname }}"
```