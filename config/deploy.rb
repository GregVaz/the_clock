# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

require 'capistrano-db-tasks'

set :application, "the_clock"
set :repo_url, "git@github.com:GregVaz/the_clock.git"
set :deploy_to, "/home/deploy/the_clock"
set :branch, ENV['BRANCH'] if ENV['BRANCH']

set :linked_files, %w{config/master.key}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 3
set :keep_assets, 3

set :db_local_clean, true
set :db_remote_clean, true

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end

# restart app by running: touch tmp/restart.txt
# at server machine
set :passenger_restart_with_touch, true
