# Настройка hostname

Настроить `HOSTNAME` можно несколькими способами:

Способ 1: Через `nmtui`

Способ 2: Через редактирования файла `/etc/hostname`

Способ 3: Коммандой в терминале `hostnamectl set-hostname`

```
hostnamectl set-hostname ISP
```

Чтобы изменение `HOSTNAME` вступили в силу нужно перезагрузить оболочку или устройство

```
exec bash
или
systemctl reboot
```