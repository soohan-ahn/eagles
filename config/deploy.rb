lock '3.4.0'

set :application, "eagles"
role :web, "52.25.171.132"

set :user, 'ec2-user'
set :ssh_options, :port=>22, :forward_agent=>false, :keys=>"~/.ssh/id_rsa", :passphrase=>:password
set :use_sudo, false
set :keep_releases, 10
set :scm, "git"
set :scm_username, :user
set :scm_password, :password
set :repo_url, "git://github.com/soohanboys/eagles.git"
set :deploy_to, "/home/deploy/eagles"
set :branch, "master"

set :default_shell, :bash
set :rvm_type, :system
set :use_sudo, true
set :pty, true

set :nginx_domains, "localhost"
set :nginx_sites_available_dir, "/etc/nginx/conf.d"
set :app_server_port, 80

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:reload'
  end
end