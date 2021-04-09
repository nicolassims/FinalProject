export MIX_ENV=prod
export PORT=4799

CFGD=$(readlink -f ~/.config/final_project)

if [ ! -e "$CFGD/base" ]; then
    echo "run deploy first"
    exit 1
fi

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://final_project:$DB_PASS@localhost/final_project_prod

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

#twitter config directory
CFGD=$(readlink -f ~/.config/twitter)


#files with these names should be filled in with correct configs
export TWITTER_CONSUMER_KEY=$(cat "$CFGD/api_key")
export TWITTER_CONSUMER_SECRET=$(cat "$CFGD/api_secret_key")
export TWITTER_ACCESS_TOKEN=$(cat "$CFGD/access_token")
export TWITTER_ACCESS_TOKEN_SECRET=$(cat "$CFGD/access_token_secret")

(cd server && _build/prod/rel/final_project/bin/final_project start)