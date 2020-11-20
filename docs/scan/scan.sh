#!/bin/sh

date=$(date +%Y-%m-%dT%H:%M:%S)

base="http://locbusrtct.dataccessor.com:20082"

set -ex

for endpoint in /api/bus/logs-course/1 /api/disruption/active /api/places/all /api/routes/0
do
	path="${date}/${endpoint}"
	mkdir -p "$(dirname $path)"
	if [ ! -f "$path" ]; then
		curl -o "$path" "$base$endpoint"
	fi
done

endpoint=/api/stop-time/next-line-live

	path="${date}/${endpoint}"
	mkdir -p "$(dirname $path)"
	if [ ! -f "$path" ]; then
		curl -d '{"routeId":"1034","routeDirection":0}' -o "$path" "$base$endpoint"
	fi
