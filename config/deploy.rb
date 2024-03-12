# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, 'demo'
set :repo_url, 'git@github.com:riyasoner123/ror-cap.git' # should match git repo
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/demo"

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v18.13.0'
set :nvm_map_bins, %w[nodejs node npm yarn]
set :bundle_binstubs, true
set :local_user, -> { `git config user.name`.chomp }
set :keep_releases, 5

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml" , 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "storage"
