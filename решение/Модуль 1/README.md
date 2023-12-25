# Модуль 1

[Задание](../../задание/Модуль%201%20-%20Задание%20№1.md)

Решение сделанно на системе виртуализации ESXi 8.0
<p align="center">
  <img src="./%D0%A2%D0%BE%D0%BF%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D1%8F.jpg">
</p>

0. Сборка стенда
   - 0.1 Создание виртуальных подключений [->](./createStend/createVirtualConnect/README.md)
   - 0.2 Создание виртуальной машины [->](./createStend/createVirtualMashin/README.md)
   - 0.3 Устанорвка Alt Linux [->](./createStend/installAltLinux/README.md)
   - 0.4 (Опционально) Настройка внеполосного управления виртуальными машинами [->](./createStend/connectToConsole/README.md)
   - 0.5 Подключение виртуальной машины к интернету [->](./createStend/connectVirtualMashinToInternet/README.md)
   - 0.6 Обновление до последнией версии [->](./createStend/updateAltLinux/README.md)
   - 0.7 Установка NMTUI [->](./createStend/instalNMTui/README.md)
   - 0.8 Соединение виртуальных машин между собой [->](./createStend/connectingVirtualMashin/README.md)
1. Базовая настройка
    - 1.1 Настройка HOSTNAME [->](./createIPAddresses/assignHostname/README.md)
    - 1.2 Заполнение таблицы [->](./createIPAddresses/README.md)
    - 1.3 Настройка IP на интерфейсы способ 1 [->](./createIPAddresses/assignIPAddressesNMTui/README.md)
    - 1.4 Настройка IP на интерфейсы способ 2 [->](./createIPAddresses/assignIPAdressesEtcnet/README.md)
      - 1.4.1 Настройка IP на интерфейсы HQ-R [->](./createIPAddresses/assignIPAdressesEtcnet/HQ-R.md)
      - 1.4.2 Настройка IP на интерфейсы BR-R [->](./createIPAddresses/assignIPAdressesEtcnet/BR-R.md)
      - 1.4.3 Настройка IP на интерфейсы HQ-SRV [->](./createIPAddresses/assignIPAdressesEtcnet/HQ-SRV.md)
      - 1.4.3 Настройка IP на интерфейсы BR-SRV [->](./createIPAddresses/assignIPAdressesEtcnet/BR-SRV.md)
    - 1.5 Настройка туннелей [->](./createIPAddresses/createTunnel/README.md)
2. Настройка динамической маршрутизации
    - 2.1 Установка FRR [->](./createDynamicRouting/installFRRtoInternet/README.md)
    - 2.2 Настройка FRR [->](./createDynamicRouting/settingsFRR/README.md)
3. Настройка автоматического распределения IP-адресов на роутере HQ-R [->](./createDHCPServer//README.md)
4. Создание пользователей [->](./createUserName/README.md)