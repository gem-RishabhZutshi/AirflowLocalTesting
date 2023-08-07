#!/usr/bin/env bash

TRY_LOOP="20"

: "${REDIS_HOST:="redis"}"
: "${REDIS_PORT:="6379"}"

: "${POSTGRES_HOST:="postgres"}"
: "${POSTGRES_PORT:="5432"}"

wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}


wait_for_port "Postgres" "$POSTGRES_HOST" "$POSTGRES_PORT"

wait_for_port "Redis" "$REDIS_HOST" "$REDIS_PORT"

case "$1" in
``all)
    airflow db init
    airflow db upgrade
    sleep 5
    exec airflow webserver &         # Start webserver in the background
    sleep 10                         # Give webserver some time to start
    exec airflow worker &            # Start worker in the background
    exec airflow scheduler &         # Start scheduler in the background
    exec airflow celery flower &     # Start flower in the background
    wait                            # Wait for all background processes to finish
    ;;
  *)
    exec "$@"
    ;;
esac
