require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/rbenv"
require "capistrano/passenger"

set :rbenv_type, :user
set :rbenv_ruby, '3.0.0'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
