ssh_options[:forward_agent] = true # Используем локальные ключи, а не ключи сервера
default_run_options[:pty] = true   # Для того, чтобы можно было вводить пароль

set :application, 'postindexapi'
set :domain, 'piapi@postindexapi.ru'

set :scm, :git
set :repository, 'git@github.com:Envek/postindexapi.ru.git'
set :branch, 'master'
set :deploy_via, :remote_cache
set :deploy_to, "/srv/#{application}"

server domain, :app, :web, :db, primary: true

set :rvm_ruby_string, '2.0.0'
set :rvm_type, :user
set :use_sudo, false
require 'rvm/capistrano'
require 'bundler/capistrano'

# Автосоздание конфигов при необходимости
after 'deploy:update_code', :roles => :app do
  run "test -d #{deploy_to}/shared/config || mkdir #{deploy_to}/shared/config"
  run "test -f #{deploy_to}/shared/config/database.yml || cp #{current_release}/config/database.yml.example #{deploy_to}/shared/config/database.yml"
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
end

require 'puma/capistrano'
