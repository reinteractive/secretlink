#!/bin/bash
. ${current_app_path}/config/deploy/hooks/lib/app-server.sh

echo "*** zdd unicorn ***"
zdd_unicorn
