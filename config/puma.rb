threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

# Specifies the `environment` that Puma will run in.
# Defaults to production
rails_env = ENV.fetch('RAILS_ENV') { 'production' }
environment rails_env

# Set up directory paths
app_dir = '/home/ubuntu/demo/current'
shared_dir = '/home/ubuntu/demo/shared'

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"

# Change to match your CPU core count
workers ENV.fetch('WEB_CONCURRENCY') { 2 }

preload_app!

# Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

before_fork do
  # Disconnect from the database
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  # Reconnect to the database
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end



