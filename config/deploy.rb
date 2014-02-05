require "rvm/capistrano" # For RVM
require 'bundler/capistrano' # for bundler support
require 'whenever/capistrano' # for whenever support 
set :whenever_command, "bundle exec whenever"

set :application, "handraise"
set :repository,  "git@github.com:flatiron-school/handraise-redux.git"

set :user, 'handraise'
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false
set :ssh_options, { :forward_agent => true }

set :scm, :git
set :branch, 'master'

default_run_options[:pty] = true
primary = '107.170.25.96'
server primary, :web, :app, :db, :worker, primary: true

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end

  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  after "deploy:finalize_update", "deploy:symlink_config"
end

namespace(:customs) do
  task :symlink, :roles => :app do
    run <<-CMD
    ln -nfs #{shared_path}/system/uploads/application.yml #{release_path}/config/application.yml
    CMD
  end
end

after "deploy","customs:symlink"
after "deploy","deploy:cleanup"
before 'deploy:setup', 'rvm:install_rvm'  
before 'deploy:setup', 'rvm:install_ruby' 
