$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.

set :application,               "alasocho"
set :repository,                "git@github.com:foca/alasocho.git"
set :use_sudo,                  false

set :deploy_to,                 "/data/#{application}"
set :deploy_via,                :remote_cache
set :user,                      "deploy"
set :normalize_asset_timestamps, false
set :scm,                       "git"

ssh_options[:forward_agent] = true

task :production do
  set :rails_env, "production"
  set :branch, "master"

  role :app, 'alasocho.com'
  role :web, 'alasocho.com'
  role :db,  'alasocho.com', primary: true
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(release_path, 'vendor', 'bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --without 'development test' --deployment"

    on_rollback do
      if previous_release
        run "cd #{previous_release} && bundle install --without 'development test' --deployment"
      else
        logger.important "no previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  task :bundle_new_release, roles: [:app] do
    bundler.create_symlink
    bundler.install
  end
end

task :restart_resque do
  run "cd #{current_path} && RAILS_ENV=#{rails_env} VVERBOSE=1 QUEUE=* ./script/resque_worker restart"
end

task :create_various_symlinks do
  run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/data #{release_path}/data"
end

after "deploy:rollback:revision", "bundler:install"
after "deploy:update_code", "bundler:bundle_new_release"
after "deploy:update_code", "create_various_symlinks"
after "deploy:restart", "restart_resque"
