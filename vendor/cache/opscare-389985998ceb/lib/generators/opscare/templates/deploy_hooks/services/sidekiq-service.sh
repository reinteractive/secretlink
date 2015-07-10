sidekiq_init_script="/etc/init.d/sidekiq-${app_full_name}"

service_sidekiq(){
  if [ -f $sidekiq_init_script ] ; then
    echo "executing ${sidekiq_init_script} $1"
    $sidekiq_init_script $1
  fi
}

stop_sidekiq(){
  service_sidekiq stop
}

start_sidekiq(){
  service_sidekiq start
}

restart_sidekiq(){
  service_sidekiq stop
  service_sidekiq start
}

soft_stop_sidekiq(){
  service_sidekiq soft_stop
}
