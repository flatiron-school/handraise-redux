require 'bundler/capistrano' # for bundler support

set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano' # for whenever support 


set :application, "handraise"
set :repository,  "git@github.com:flatiron-school/handraise-redux.git"

set :user, 'janeeats'
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

set :scm, :git

default_run_options[:pty] = true
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "198.211.112.240"                          # Your HTTP server, Apache/etc
role :app, "198.211.112.240"                          # This may be the same as your `Web` server
role :db,  "198.211.112.240", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
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