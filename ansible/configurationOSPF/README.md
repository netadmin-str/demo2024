# Установка и настройка FRR

Законченный play-book

```
---

- name: Установка и настрока FRR
  hosts: HQ-R, BR-R
  tasks:
    - name: Устанавливаем пакет frr
      shell: apt-get install -y frr

    - name: Включаем OSPF
      shell: sed -i -e 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons

    - name: Создаем конфигурацию из шаблона
      template:
        src=ospf.j2
        dest=/etc/frr/frr.conf

    - name: Перезагружаем FRR
      ansible.builtin.systemd:
        name: frr
        state: restarted
```
## Теперь подробнее.


Предварительно установим дополнительный модуль `netaddr` для `python` 

```
pip install netaddr
```

Устанавливаем `OSPF`

```
    - name: Устанавливаем пакет frr
      shell: apt-get install -y frr
```

Включаем `OSPF` в `FRR`

```
    - name: Включаем OSPF
      shell: sed -i -e 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
```

Генерируем конфигурацию для `FRR` из шаблона `Jinja2`. Шаблон предварительно должен быть создан.

Генерируем шаблон. Для этого создаем файл `ospf.j2` рядом с плайбуком

```
log file /var/log/frr/frr.log
no ipv6 forwarding
!
interface tunnel1
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

{% for item in vars.vars.tunnels %}
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
Она береться из инвентарного файла.

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

Такие же действия делаем для туннельных интерфейсов.

Эта задача гененируем конфигурацию OSPF для каждого хоста.

```
    - name: Создаем конфигурацию из шаблона
      template:
        src=ospf.j2
        dest=/etc/frr/frr.conf
```

Перезагружаем FRR

```
    - name: Перезагружаем FRR
      ansible.builtin.systemd:
        name: frr
        state: restarted
```
