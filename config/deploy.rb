# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'demo'
set :repo_url, 'https://github.com/snails/capistrano_deploy_demo'
set :branch, 'master'
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

#Set user
set :user, 'huyang'
set :use_sudo, false

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/demo"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
#set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  task :init_shared_path do
    on roles(:web) do
      run "mkdir -p #{deploy_to}/shared/log"
      run "mkdir -p #{deploy_to}/shared/pids"
      run "mkdir -p #{deploy_to}/shared/config"
      run "mkdir -p #{deploy_to}/shared/assets"
    end
  end

  task :link_shared_files do
    on roles(:web) do
      run "ln -sf #{shared_path}/assets #{deploy_to}/current/public/assets"
      run "ln -sf #{deploy_to}/shared/config/*.yml #{deploy_to}/current/config/"
      run "ln -sf #{shared_path}/pids #{deploy_to}/current/tmp/"
    end
  end

  task :migrate_database do
    on roles(:web) do
      run "cd #{deploy_to}/current/config/; mv database.example.yml database.yml"
      run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake db:migrate"
    end
  end 

  task :compile_assets do
    on roles(:web) do
      run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:precompile"
    end
  end


  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
