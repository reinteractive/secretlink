sidekiq_service_name="sidekiq-${app_full_name}"
sidekiq_service_file="/etc/init/${sidekiq_service_name}.conf"

service_sidekiq() {
  if [ -f "${sidekiq_service_file}" ] ; then
    sudo service ${sidekiq_service_name} $1
  fi
}

stop_sidekiq(){
  service_sidekiq stop
}

start_sidekiq(){
  service_sidekiq start
}

restart_sidekiq(){
  stop_sidekiq
  start_sidekiq
}
