namespace :launch do
  desc "Deploy to staging-versavault.heroku.com"

  task "staging" do
    # Push to Heroku, migrate and restart
    sh "git push heroku staging:master -f"
    sh "bundle exec heroku run rake --app staging-versavault db:migrate"
    sh "bundle exec heroku run rake db:seed --app staging-versavault"
    sh "bundle exec heroku restart --app staging-versavault"
  end
end