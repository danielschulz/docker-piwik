#!/bin/bash
set -e

if [ ! -e piwik.php ]; then
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -

    # add proxy settings
    export NEW_VALUES="assume_secure_protocol = 1\n"
    export NEW_VALUES="${NEW_VALUES}proxy_client_headers[] = HTTP_X_FORWARDED_FOR\n"
    export NEW_VALUES="${NEW_VALUES}proxy_host_headers[] = HTTP_X_FORWARDED_HOST\n"
    export NEW_VALUES="${NEW_VALUES}proxy_ips[] = ${PROXY_IP}\n"
    export NEW_VALUES="${NEW_VALUES}enable_plugin_upload = 1"

    sed -i -e "s|^\[General\]$|[General]\n${NEW_VALUES}|g" /var/www/html/config/global.ini.php

    chown -R www-data .
fi

exec "$@"
