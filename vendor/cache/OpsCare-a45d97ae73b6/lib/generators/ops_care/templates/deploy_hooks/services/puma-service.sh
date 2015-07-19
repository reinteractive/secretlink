puma_init_script="/etc/init.d/puma-${app_full_name}"

service_puma(){
  if [ -f "${puma_init_script}" ] ; then
    echo "executing ${puma_init_script} $1"
    $puma_init_script $1
  fi
}

stop_puma(){
  service_puma stop
}

start_puma(){
  service_puma start
}

restart_puma(){
  service_puma restart
}

zdd_puma(){
  service_puma zdd
}
