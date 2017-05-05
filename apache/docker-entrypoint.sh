#!/bin/bash
set -e

if [ ! -e piwik.php ]; then
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -

    # add proxy settings
    sed -i -e "s|^assume\_secure\_protocol \= 0$|assume_secure_protocol = 1|g" /var/www/html/config/global.ini.php
    sed -i -e "s|^;proxy\_client\_headers\[\] \= HTTP\_X\_FORWARDED_FOR$|proxy_client_headers[] = HTTP_X_FORWARDED_FOR|g" /var/www/html/config/global.ini.php
    sed -i -e "s|^;proxy\_host\_headers\[\] \= HTTP\_X\_FORWARDED_HOST$|proxy_host_headers[] = HTTP_X_FORWARDED_HOST|g" /var/www/html/config/global.ini.php
    sed -i -e "s|^;proxy\_ips\[\] \= 204\.93\.240\.\*$|proxy_ips[] = ${PROXY_IP}|g" /var/www/html/config/global.ini.php

	chown -R www-data .
fi

exec "$@"
