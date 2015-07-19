#!/bin/bash

# Loading all the services helpers.
# Don't touch this line
. ${current_app_path}/config/deploy/hooks/services/load.sh

# Zero Downtime Deploy
zdd_unicorn
# zdd_puma # if your app server is Puma
