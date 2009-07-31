set :application,       "media_lender"

set :repository,        "git@github.com:urug/#{application}.git"
set :scm,               :git
set :deploy_via,        :remote_cache
set :keep_releases,     3 

default_run_options[:pty] = true
# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

set :use_sudo,       false
set :user,           "demo"
set :rails_env,      "production"
set :deploy_to,      "/home/#{user}/public_html"

role :web, '67.207.130.132'
role :app, '67.207.130.132'
role :db, '67.207.130.132', :primary => true


# =============================================================================
# TASKS
# Don't change unless you know what you are doing!
before "deploy:migrate", "gems:install"
after "deploy", "deploy:cleanup"
after "deploy:cold", "db:populate:four"

namespace :deploy do
  desc "Restart the application"
  task :restart, :roles => :app do
    sudo "apache2ctl graceful"
  end

  desc "Spin up the application"
  task :start, :roles => :app do
    sudo "apache2ctl restart"
  end
end

# =============================================================================
namespace :gems do
  task :install, :roles => :app do
    run "cd #{current_path}; #{sudo} rake gems:install RAILS_ENV=#{rails_env}"
  end
end

# =============================================================================
namespace :db do
  namespace :populate do
    task :four, :roles => :app do
      run "cd #{current_path}; rake db:populate:four RAILS_ENV=#{rails_env}"
    end
  end
end