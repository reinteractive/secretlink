#!/bin/bash

# Loading all the services helpers.
# Don't touch this line
. ${current_app_path}/config/deploy/hooks/services/load.sh

# Zero Downtime Deploy
zdd_unicorn
# zdd_puma # if your app server is Puma

# # For Whenever-based crons
# # schedule.rb file should have this line at the top:
# # set :job_template, "bash -l -c '[[ ! -f /tmp/STOP_CRONS ]] && . /etc/app_description && . $APP_LOCATION/shared/envvars && :job'"
# wheneverize_worker
