#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" ]; then
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /etc/kibana/kibana.yml
	fi
	if [ "$elasticsearch_username" ]; then
		sed -ri "s/(^#)?(elasticsearch\.username\:).*/\2 '$elasticsearch_username'/" /etc/kibana/kibana.yml
		sed -ri "s/(^#)?(elasticsearch\.password\:).*/\2 '$elasticsearch_password'/" /etc/kibana/kibana.yml
	fi 
	set -- gosu kibana tini -- "$@"
fi

exec "$@"