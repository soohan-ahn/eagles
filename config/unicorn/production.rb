#pidをフルパスで指定する
# pid "/home/deploy/eagles/shared/tmp/pids/unicorn.pid"
# coding: utf-8

app_path = '/home/deploy/eagles'
app_shared_path = "#{app_path}/shared"

# Set unicorn options
worker_processes 1
preload_app true
timeout 20
#listen "127.0.0.1:9000"
listen "#{app_path}/tmp/sockets/unicorn.sock"

# Spawn unicorn master worker for user apps (group: apps)
#user 'apps', 'apps'

# Fill path to your app
working_directory "#{app_path}/current"

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{app_shared_path}/tmp/pids/unicorn.pid"

#before_fork do |server, worker|
#  ActiveRecord::Base.connection.disconnect!
#
#  old_pid = "#{server.config[:pid]}.oldbin"
#  if File.exists?(old_pid) && server.pid != old_pid
#    begin
#      Process.kill("QUIT", File.read(old_pid).to_i)
#    rescue Errno::ENOENT, Errno::ESRCH
#      # someone else did our job for us
#    end
#  end
#end
#
#after_fork do |server, worker|
#  ActiveRecord::Base.establish_connection
#end
