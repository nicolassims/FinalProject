#!/bin/bash

#based on lectures notes and hw04
export MIX_ENV=prod
export PORT=4799
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"
export SECRET_KEY_BASE=insecure
export DATABASE_URL=ecto://final_project:bad@localhost/final_project_prod

echo "Building..."

mix deps.get
mix compile

CFGD=$(readlink -f ~/.config/final_project)

if [ ! -d "$CFGD" ]; then
	mkdir -p "$CFGD"
fi

if [ ! -e "$CFGD/base" ]; then
	mix phx.gen.secret > "$CFGD/base"
fi

if [ ! -e "$CFGD/db_pass" ]; then
    pwgen 12 1 > "$CFGD/db_pass"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://final_project:$DB_PASS@localhost/final_project_prod

mix ecto.create
mix ecto.migrate

mix phx.digest


echo "Generating release..."
mix release


echo "Starting app..."

PROD=t ./start.sh