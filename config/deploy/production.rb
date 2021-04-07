set :stage, :production
set :rails_env, :production
set :branch, "master"
server '3.133.58.216', user: 'deploy', roles: %w{web app db}
