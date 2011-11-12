# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

namespace :launch do
  desc "Deploy to staging-versavault.heroku.com"

  task "staging" do
		# Push to Heroku, migrate and restart
		# Todo: Check if remote heroku exists otherwise create it.
		%x[git push herokuStaging staging:master -f]
		%x[heroku rake db:migrate --app staging-versavault]
		%x[heroku rake db:seed --app staging-versavault]
		%x[heroku restart --app staging-versavault]
  end
end
