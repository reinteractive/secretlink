delayed_job_init_script="/etc/init.d/delayed_job-${app_full_name}"

service_delayed_job(){
  if [ -f "${delayed_job_init_script}" ] ; then
    echo "executing ${delayed_job_init_script} $1"
    $delayed_job_init_script $1
  fi
}

stop_delayed_job(){
  service_delayed_job stop
}

start_delayed_job(){
  service_delayed_job start
}

restart_delayed_job(){
  service_delayed_job restart
}
