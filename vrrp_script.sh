#!/bin/bash
# Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
IP=10.128.0.23
PORT=80 

check_function()
{
nc -z "$IP" "$PORT"
RETURN_CODE=$?

if [[ "$RETURN_CODE" == "0" && -e "/var/www/html/index.nginx-debian.html" ]]; then
    echo "Порт доступен и файл индекса существует"
    return 0
else 
    echo "Порт недоступен или файл индекса не существует"
    return 1
fi
}

check_function