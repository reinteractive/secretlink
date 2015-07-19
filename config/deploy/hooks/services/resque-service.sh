resque_ctl="sudo resque-ctl"
resque_init_script="/etc/init/resque-${app_full_name}.conf"

service_resque(){
  if [ -f $resque_init_script ] ; then
    echo "executing ${resque_ctl} $1"
    $resque_ctl $1
  fi
}

stop_resque(){
  service_resque stop
}

start_resque(){
  service_resque start
}

restart_resque(){
  service_resque restart
}
