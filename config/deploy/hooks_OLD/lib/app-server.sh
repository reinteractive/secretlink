unicorn_init_script="/etc/init.d/unicorn-${app_full_name}"

service_unicorn(){
  if [ -f $unicorn_init_script ] ; then
    echo "running ${unicorn_init_script} $1"
    $unicorn_init_script  $1
  else
    echo "Unicorn is not installed. Skipping $1"
  fi
}

stop_unicorn(){ 
  service_unicorn stop
}

start_unicorn(){
  service_unicorn start
}

restart_unicorn(){
  service_unicorn restart
}

zdd_unicorn(){
  service_unicorn zdd
}
