whenever_bin="${current_app_path}/bin/whenever"

wheneverize(){
  if [ -f ${whenever_bin} ] ; then
    cd ${current_app_path}
    ${whenever_bin} --update-crontab ${app_full_name} --set "environment=${FRAMEWORK_ENV}"
  fi
}

wheneverize_worker(){
  if [[ "${SERVER_ROLE}" == "worker" ]] ; then
    wheneverize
  fi
}
