# Модуль 1 - Задине №1

[Задание](../../задание/Модуль%201%20-%20Задание%20№1.md)

Решение сделанно на системе виртуализации ESXi 8.0
<p align="center">
  <img src="./%D0%A2%D0%BE%D0%BF%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D1%8F.jpg">
</p>

1. Сборка стенда
   - 1.1 Создание виртуальных подключений [->](./createStend/createVirtualConnect/README.md)
   - 1.2 Создание виртуальной машины [->](./createStend/createVirtualMashin/README.md)
   - 1.3 Устанорвка Alt Linux [->](./createStend/installAltLinux/README.md)
   - 1.4 (Опционально) Настройка внеполосного управления виртуальными машинами [->](./createStend/connectToConsole/README.md)
   - 1.5 Подключение виртуальной машины к интернету [->](./createStend/connectVirtualMashinToInternet/README.md)
   - 1.6 Обновление до последнией версии [->](./createStend/updateAltLinux/README.md)
   - 1.7 Установка NMTUI [->](./createStend/instalNMTui/README.md)
   - 1.8 Соединение виртуальных машин между собой [->](./createStend/connectingVirtualMashin/README.md)
2. Базовая настройка
    - 2.1 Настройка HOSTNAME [->](./createIPAddresses/assignHostname/README.md)
    - 2.2 Заполнение таблицы [->](./createIPAddresses/README.md)
    - 2.3 Настройка IP на интерфейсы способ 1 [->](./createIPAddresses/assignIPAddressesNMTui/README.md)
    - 2.4 Настройка IP на интерфейсы способ 2 [->](./createIPAddresses/assignIPAdressesEtcnet/README.md)
      - 2.4.1 Настройка IP на интерфейсы HQ-R [->](./createIPAddresses/assignIPAdressesEtcnet/HQ-R.md)
      - 2.4.2 Настройка IP на интерфейсы BR-R [->](./createIPAddresses/assignIPAdressesEtcnet/BR-R.md)
      - 2.4.3 Настройка IP на интерфейсы HQ-SRV [->](./createIPAddresses/assignIPAdressesEtcnet/HQ-SRV.md)
      - 2.4.3 Настройка IP на интерфейсы BR-SRV [->](./createIPAddresses/assignIPAdressesEtcnet/BR-SRV.md)
    - 2.5 Настройка туннелей [->](./createIPAddresses/createTunnel/README.md)
3. Настройка динамической маршрутизации
    - 3.1 Установка FRR [->](./createDynamicRouting/installFRRtoInternet/README.md)
    - 3.2 Настройка FRR [->](./createDynamicRouting/settingsFRR/README.md)