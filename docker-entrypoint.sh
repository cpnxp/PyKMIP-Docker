#!/bin/bash
set -e
DB_FILE="/etc/pykmip/pykmip.db"
PYKMIP_VER="v0.10.0" #Should match version of PyKMIP installed via pip

if [[ ! -f $DB_FILE ]]; then
    echo "Database does not exist, begining inital setup"
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -subj "$CERT_SUBJ" -keyout /etc/pykmip/selfsigned.key -out /etc/pykmip/selfsigned.crt
    wget https://raw.githubusercontent.com/OpenKMIP/PyKMIP/$PYKMIP_VER/examples/policy.json -P /etc/pykmip/policy
    cat > /etc/pykmip/server.conf <<- EOF
	[server]
	hostname=0.0.0.0
	port=5696
	certificate_path=/etc/pykmip/selfsigned.crt
	key_path=/etc/pykmip/selfsigned.key
	ca_path=/etc/pykmip/selfsigned.crt
	auth_suite=TLS1.2
	policy_path=/etc/pykmip/policy
	enable_tls_client_auth=False
	tls_cipher_suites= TLS_RSA_WITH_AES_128_CBC_SHA256 TLS_RSA_WITH_AES_256_CBC_SHA256 TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	logging_level=DEBUG
	database_path=/etc/pykmip/pykmip.db
	EOF
    echo "End inital setup, Pull certs from the Docker Volume to configure VCenter and/or your app"
else
    echo "Normal startup - database exists"
fi

exec "$@"
