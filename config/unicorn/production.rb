#pidをフルパスで指定する
pid "/home/deploy/eagles/shared/tmp/pids/unicorn.pid"

# Production specific settings
if env == "production"
  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up.
  working_directory '/home/myuser/myapp_deployed/current'
  
  # feel free to point this anywhere accessible on the filesystem
  user 'myuser', 'mygroup'
  shared_path = '/home/myuser/myapp_deployed/current'
  
  stderr_path '/home/myuser/myapp_deployed/current/log/unicorn.stderr.log'
  stdout_path '/home/myuser/myapp_deployed/current/log/unicorn.stdout.log'
end
