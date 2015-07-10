# app servers
. ${current_app_path}/config/deploy/hooks/services/unicorn-service.sh
. ${current_app_path}/config/deploy/hooks/services/puma-service.sh

# Worker services
. ${current_app_path}/config/deploy/hooks/services/delayed-job-service.sh
. ${current_app_path}/config/deploy/hooks/services/sidekiq-service.sh
. ${current_app_path}/config/deploy/hooks/services/resque-service.sh
. ${current_app_path}/config/deploy/hooks/services/pushr-service.sh
