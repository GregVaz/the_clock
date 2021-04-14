set :stage, :production
set :rails_env, :production
set :branch, "master"
server '3.16.89.42', user: 'deploy', roles: %w{web app db}
