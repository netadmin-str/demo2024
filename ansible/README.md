# Автоматизация настройки устройств

0. Подготовка
   - 0.1 Установка Python3.12 [->](./init/installPython3.12/README.md)
   - 0.2 Создание виртуального окружения [->](./init/createVirtualEnv/README.md)
   - 0.3 Подключение VSCode к виртуальной машине [->](./init/connectVSCodeToAnsible/README.md)
   - 0.4 Установка Ansible [->](./init/installAnsible/README.md)
   - 0.5 Начальная настройка Ansible [->](./init/initSettings/README.md)
   - 0.5 Начальная настройка VMs если они уже созданы на стенде [->](./init/initVMs/README.md)
   - 0.6 Подготовка шаблона виртуальной машины для сборки стенда. [->]()
1. Создание стенда
   - 1.1 Настройка виртуальных сетей [->](./createStend/createVirualNet/README.md)
   - 1.2 Разворачивание виртуальных машин [->](./createStend/deployVMs/README.md)
2. Начальная настрока машин.
   - 2.1 Монтируем локалный репозиторий на DVD диске [->](./mount-local-repo/README.md)
   - 2.2 Настраиваем имя хоста [->](./changeHostnameViaSSH/README.md)
   - 2.3 Настройка шлюза по умолчанию и туннелей. [->](./createTunnelInterfaces/README.md)
   - 2.3 Установка и настройка FRR [->](./configurationOSPF/README.md)