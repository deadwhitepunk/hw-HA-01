# Домашнее задание к занятию 1 «Disaster recovery и Keepalived»

# Желонкин Дмитрий

------


### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

[`Настройки роутера1`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/settings_router1)

[`Настройки роутера2`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/settings_router2)

[`PKT схема`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/hsrp_advanced.pkt)

![Отключение первого кабеля](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_RSHP_broke_cable.png)

![Отключение второго кабеля](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_broke_cable2.png)

![Скрин рабочего окружения](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_scr_cisco.png)

------


### Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

[`Конфиг файл host1 (ansible1) master`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/keepalived_master.conf)

[`Конфиг файл host2 (ansible2) backup`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/keepalived_backup_host3.conf)

Видим что IP адресс находится на мастере

![IP before floating](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_before_float.png)

[`Скрипт проверки доступности порта и наличия файла index.html`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/vrrp_script.sh)

Переименовываем index файл

![Rename index-file](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_rename_index.png)

Логи keepalived

![Keeplived logs](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_float_after_rename_index.png)

Доступность nginx по общему IP

![Keeplived logs](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_nginx_after_rename_index.png)

Floating IP теперь у backup

![IP after floating](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_after_floating.png)
------

## Дополнительные задания со звёздочкой*

Эти задания дополнительные. Их можно не выполнять. На зачёт это не повлияет. Вы можете их выполнить, если хотите глубже разобраться в материале.
 
### Задание 3*
- Изучите дополнительно возможность Keepalived, которая называется vrrp_track_file
- Напишите bash-скрипт, который будет менять приоритет внутри файла в зависимости от нагрузки на виртуальную машину (можно разместить данный скрипт в cron и запускать каждую минуту). Рассчитывать приоритет можно, например, на основании Load average.
- Настройте Keepalived на отслеживание данного файла.
- Нагрузите одну из виртуальных машин, которая находится в состоянии MASTER и имеет активный виртуальный IP и проверьте, чтобы через некоторое время она перешла в состояние SLAVE из-за высокой нагрузки и виртуальный IP переехал на другой, менее нагруженный сервер.
- Попробуйте выполнить настройку keepalived на третьем сервере и скорректировать при необходимости формулу так, чтобы плавающий ip адрес всегда был прикреплен к серверу, имеющему наименьшую нагрузку.
- На проверку отправьте получившийся bash-скрипт и конфигурационный файл keepalived, а также скриншоты логов keepalived с серверов при разных нагрузках

Скрипт который отправляет "1" если load average больше 1. Его прокидываем на каждый хост.

[`Скрипт проверки нагрузки`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/loadbalancer.sh)

Настраиваем crontab

![Crontab for script](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_crontab.png)

Ниже представлен отредактированный keepalive конфиг для задания 3.

[`Конфиг файл host1 (ansible1) master, для задания 3`](https://github.com/deadwhitepunk/hw-HA-01/blob/main/keepalived_exerc3_master.conf)

Stress master (host1) Priority становится 1, т.к. load average стал больше 1 и состояние перешло в failure.

![Stress](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_stress_master.png)

Master становится host2.

![Новый мастер host2](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_slave_become_a_master.png)

И виртуальный IP переехал

![IP after floating host2](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_float_ip_exc3.png)

Снимаем stress с host1. Host1 становится master обратно

![Chill host1](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_master_become_master_again.png)

Накидываем stress на host1 и host2. Master становится host3

![FULL STRESS](https://github.com/deadwhitepunk/hw-HA-01/blob/main/img/image_stress_2host_master_3host.png)
------


### Правила приема работы

1. Необходимо следовать инструкции по выполнению домашнего задания, используя для оформления репозиторий Github
2. В ответе необходимо прикладывать требуемые материалы - скриншоты, конфигурационные файлы, скрипты. Необходимые материалы для получения зачета указаны в каждом задании.


------

### Критерии оценки

- Зачет - выполнены все задания, ответы даны в развернутой форме, приложены требуемые скриншоты, конфигурационные файлы, скрипты. В выполненных заданиях нет противоречий и нарушения логики
- На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки, приложены не все требуемые материалы.