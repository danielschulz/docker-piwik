#!/bin/bash
set -e

if [ ! -e piwik.php ]; then
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -
	chown -R www-data .
fi


# add proxy settings

echo -ne "\n" >> /var/www/html/config/config.ini.php
echo "assume_secure_protocol = \"1\"" >> /var/www/html/config/config.ini.php

echo -ne "\n" >> /var/www/html/config/config.ini.php
echo "proxy_client_headers[] = \"HTTP_X_FORWARDED_FOR\"" >> /var/www/html/config/config.ini.php
echo "proxy_host_headers[] = \"HTTP_X_FORWARDED_HOST\"" >> /var/www/html/config/config.ini.php

echo -ne "\n" >> /var/www/html/config/config.ini.php
echo "proxy_ips[] = \"${PROXY_IP}\"" >> /var/www/html/config/config.ini.php

exec "$@"
