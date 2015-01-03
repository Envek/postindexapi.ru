ssh_options[:forward_agent] = true # Используем локальные ключи, а не ключи сервера
default_run_options[:pty] = true   # Для того, чтобы можно было вводить пароль

set :application, 'postindexapi'
set :domain, 'piapi@postindexapi.ru'

set :scm, :git
set :repository, 'git@github.com:Envek/postindexapi.ru.git'
set :branch, 'master'
set :deploy_via, :remote_cache
set :deploy_to, "/home/piapi/#{application}"

server domain, :app, :web, :db, primary: true

set :rvm_ruby_string, '2.2.0'
set :rvm_type, :user
set :use_sudo, false
require 'rvm/capistrano'
require 'bundler/capistrano'

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'

# Автосоздание конфигов при необходимости
after 'deploy:update_code', :roles => :app do
  run "test -d #{deploy_to}/shared/config || mkdir #{deploy_to}/shared/config"
  %w(database settings).each do |filename|
    run "test -f #{deploy_to}/shared/config/#{filename}.yml || cp #{current_release}/config/#{filename}.yml.example #{deploy_to}/shared/config/#{filename}.yml"
    run "rm -f #{current_release}/config/#{filename}.yml"
    run "ln -s #{deploy_to}/shared/config/#{filename}.yml #{current_release}/config/#{filename}.yml"
  end
end

require 'puma/capistrano'

shared_children.push('tmp/post_indices')
