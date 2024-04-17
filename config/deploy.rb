# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, 'demo'
set :repo_url, 'git@github.com:riyasoner123/ror-cap.git' # should match git repo
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/dev/PUMA_DEPLOYMENT"


set :keep_releases, 5

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true


set :nvm_type, :user
set :nvm_node, 'v18.19.0'
set :nvm_map_bins, %w{node npm yarn}

set :rvm_type, :user
set :rvm_ruby_version, '3.0.0'
set :bundle_binstubs, true
set :local_user, -> { `git config user.name`.chomp }
# Default value for :linked_files is []
append :linked_files, "config/database.yml" , 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "storage"


set :puma_rackup, -> { File.join(current_path, 'config.ru') }

set :puma_state, "#{shared_path}/tmp/pids/puma.state"

set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"

set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock" # accept array for multi-bind

set :puma_conf, "#{shared_path}/puma.rb"

set :puma_access_log, "#{shared_path}/log/puma_access.log" # corrected log file name

set :puma_error_log, "#{shared_path}/log/puma_error.log" # corrected log file name

set :puma_role, :app

set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))

set :puma_threads, [0, 8]

set :puma_workers, 0

set :puma_worker_timeout, nil

set :puma_init_active_record, true

set :puma_preload_app, false


set :default_env, {
  'PATH' => "$HOME/.nvm/versions/node/v18.19.1/bin:$PATH"
}

namespace :puma do
  desc 'Start or restart Puma directly'
  task :start_or_restart do
    on roles(:app) do
      within current_path do
        if test("[ -e #{fetch(:puma_pid)} ]")
          # Restart Puma gracefully
          execute :bundle, "exec pumactl -e production -S #{fetch(:puma_state)} restart"
        else
          # If Puma is not running, start it
          execute :bundle, "exec puma -e production -C #{shared_path}/puma.rb"
        end
      end
    end
  end
end

# Define a callback to run the puma:start_or_restart task after deployment
after 'deploy:published', 'puma:start_or_restart'

