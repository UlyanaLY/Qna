lock "~> 3.11.0"
set :application, "qna"
set :repo_url, "git@github.com:UlyanaLY/Qna.git"
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

#Default value for :linked_files is []
append :linked_files, "config/database.yml",  ".env"
# Default value for linked_dirs is []
append :linked_dirs, "bin", "log", "tmp/pids", "tmp/cache", "vendor/bundle", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
