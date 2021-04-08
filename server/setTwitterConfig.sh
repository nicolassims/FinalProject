#!/bin/bash

#config directory
CFGD=$(readlink -f ~/.config/twitter)


#files with these names should be filled in with correct configs
export TWITTER_CONSUMER_KEY=$(cat "$CFGD/api_key")
export TWITTER_CONSUMER_SECRET=$(cat "$CFGD/api_secret_key")
export TWITTER_ACCESS_TOKEN=$(cat "$CFGD/access_token")
export TWITTER_ACCESS_TOKEN_SECRET=$(cat "$CFGD/access_token_secret")

mix phx.server