pushr_ctl="sudo pushr-ctl"
pushr_init_script="/etc/init/pushr-${app_full_name}.conf"

service_pushr(){
  if [ -f $pushr_init_script ] ; then
    echo "executing ${pushr_ctl} $1"
    $pushr_ctl $1
  fi
}

stop_pushr(){
  service_pushr stop
}

start_pushr(){
  service_pushr start
}

restart_pushr(){
  service_pushr restart
}
