# Подключение виртуальных машин между собой.

Для каждой виртуальной машины добавим недостающие интерфейсы

<p align="center">
  <img src="./pic1.png">
</p>

Включаем виртуалку и через `ip a` определяем кто из них кто.

<p align="center">
  <img src="./pic2.png">
</p>

Смотрим на топологию и подключаем в соответствующие сети. MAC адреса у вас будут отличаться! Будте внимательны.

<p align="center">
  <img src="./pic3.png">
</p>

Такие действия проделываем с каждой виртуалкой.