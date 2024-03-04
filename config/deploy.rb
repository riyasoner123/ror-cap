# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, 'demo'
set :repo_url, 'git@github.com:riyasoner123/ror-cap.git' # should match git repo
set :branch, :main
set :deploy_to, '/home/ubuntu/demo'
set :pty, true
set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.0.0'
set :default_env, {
   'PATH' => "$HOME/.rvm/bin:$PATH"
}
set :default_env, {
  'SECRET_KEY_BASE' => '7ebc1eec6b2fabb2dc317c075f293e008b1e6c2f53ca02b5961b8f6474d6a975c4a3e4a437cb6c41e14768f47ae5f03b513d350ab39f38b1d39e82dde9a9c796'
}

# Puma configuration
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    # accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
