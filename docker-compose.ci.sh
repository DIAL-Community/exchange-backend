#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until PGPASSWORD=Password!1 psql -h "postgres" -U "registry" -d "registry_test" -c '\q'; do
  sleep 2s
done

. ./setEnv.sh test

set +e
rails db:create_db_with_public_data
rails db:migrate
rails db:sessions:clear
set -e

cron

rails test -e test
rails graphql:schema:dump
rspec --pattern spec/graphql/**/*_spec.rb
