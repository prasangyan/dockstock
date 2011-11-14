namespace :launch do
  desc "Deploy to staging-versavault.heroku.com"

  task "staging" do
		# Push to Heroku, migrate and restartl
		# Todo: Check if remote heroku exists otherwise create it.
		%x[git push heroku staging:master -f]
		%x[heroku rake db:migrate --app staging-versavault]
		%x[heroku rake db:seed --app staging-versavault]
		%x[heroku restart --app staging-versavault]
  end
end
