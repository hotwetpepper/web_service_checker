#/bin/bash

# Возвращение вывода к стандартному форматированию
NORMAL='\033[0m'      # ${NORMAL}

# Цветом текста (жирным) (bold) :
WHITE='\033[1;37m'    # ${WHITE}

# Цвет фона
BGRED='\033[41m'      # ${BGRED}
BGGREEN='\033[42m'    # ${BGGREEN}
BGBLUE='\033[44m'     # ${BGBLUE}

# Получаем статус веб-сервера через systemd записываем его в переменную
nginx_status=$(systemctl status nginx | grep -Eo "running|dead|failed")

if [[ $nginx_status = 'running' ]]
then
  echo -en  "${WHITE} ${BGGREEN} Веб сервер работает ${NORMAL}\n"
else
  echo -en "${WHITE} ${BGRED} nginx не работает ${NORMAL}\n"
  systemctl restart nginx # Перезапускаем nginx
  sleep 1 # Ожидаем 1 секунду
  echo -en "${WHITE} ${BGRED} Статус Nginx после перезапуска $(systemctl status nginx | grep -Eo "running|dead|failed") ${NORMAL}\n"
  echo $(curl -i $(hostname -i) | grep  OK) # Проверка отдает ли веб-сервер http код 200
fi

php_fpm_status=$(systemctl status php7.2-fpm | grep -Eo "running|dead|failed")

if [[ $php_fpm_status = 'running' ]]
then
  echo -en  "${WHITE} ${BGGREEN} Веб сервер работает ${NORMAL}\n"
else
  echo -en "${WHITE} ${BGRED} php-fpm не работает ${NORMAL}\n"
  systemctl restart php7.2-fpm # Перезапускаем php-fpm
  sleep 1 # Ожидаем 1 секунду
  echo -en "${WHITE} ${BGRED} Статус php-fpm после перезапуска $(systemctl status php7.2-fpm | grep -Eo "running|dead|failed") ${NORMAL}\n"
fi
