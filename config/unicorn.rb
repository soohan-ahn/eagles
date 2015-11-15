# Set the working application directory
# working_directory "/path/to/your/app"
app_path = '/home/deploy/eagles'
app_shared_path = "#{app_path}/shared"

working_directory "#{app_path}/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{app_shared_path}/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30