namespace :launch do
  desc "Pull source from github and overwrite the local copy"
  task "githubPull" do
    sh "git checkout staging"
    sh "git reset --hard HEAD"
    sh "git clean -f -d"
    sh "git pull origin staging"
  end

  desc "Deploy to staging-versavault.heroku.com"
  task "staging" => "githubPull" do
		# Push to Heroku, migrate and restartl
		# Todo: Check if remote heroku exists otherwise create it. Force creating for now
    # sh "git remote add heroku git@heroku.com:staging-versavault.git"
		sh "git push heroku staging:master -f"
    sh "bundle exec heroku run rake --app staging-versavault db:migrate"
    sh "bundle exec heroku run rake db:seed --app staging-versavault"
    sh "bundle exec heroku restart --app staging-versavault"
  end
end
