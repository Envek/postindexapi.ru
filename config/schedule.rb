# -*- encoding : utf-8 -*-
env :PATH, ENV['PATH']

app = 'postindexapi'
ruby = '2.3'
deploy_to  = "/home/piapi/#{app}"
current = "#{deploy_to}/current"
puma_sockets = "#{deploy_to}/shared/sockets"
puma_statefile = "#{puma_sockets}/puma.state"
puma_start_command = "puma -q -d -e production -b 'unix://#{puma_sockets}/puma.sock' -S '#{puma_statefile}' --control 'unix://#{puma_sockets}/pumactl.sock'"

if environment == 'production'

  # Запуск сервера после перезагрузки
  every :reboot do
    command "rvm use #{ruby} && cd #{current} && bundle exec #{puma_start_command}"
  end

  # Если Unicorn упал, пытаемся поднять
  every 5.minutes do
    command "PID=`grep pid #{puma_statefile} | awk '{print $2}'`; if [ ! -f #{puma_statefile} ] || [ ! -e /proc/$PID ]; then kill $PID; rvm use #{ruby} && cd #{current} && bundle exec #{puma_start_command}; fi"
  end

  every 1.day do
    rake 'post_index:update'
  end

end
