set :rvm_ruby_string, "1.9.3" #set your ruby name here in RVM
set :rvm_type, :system  #only if you installed RVM system-wide (as sudo)

require 'rvm/capistrano'

set :application, "r4"
set :user, "alximik"  # The server's user for deploys
set :deploy_to, "/var/www/projects/r4"

ssh_options[:forward_agent] = true # to use SSH keys
default_run_options[:pty] = true   # Must be set for the password prompt from git to work

set :deploy_via, :remote_cache
set :keep_releases, 2


server '192.81.223.184', :app, :web, :db, :primary=>true

set :scm, :git # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository, "git://github.com/alximik00/r4.git"  # Your clone URL
set :branch, 'master'

#for passenger
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after 'deploy:update_code' do
  run "cd #{release_path}; bundle install"
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end

