S3FileManager::Application.routes.draw do

  get "invitation/send"
  get "dashboard/index"

  resources :authentications
  #root :controller => "authentications", :action => "new"
  match '/SendInvitation', :controller => "invitation", :action => "send"
  root :controller => "dashboard" , :action => "index"
  match '/register' , :controller => "authentications", :action => 'register'
  match '/createuser' , :controller => "authentications", :action => 'createuser'
  match 'login', :controller => "authentications", :action => "new"
  match 'logout', :controller => "authentications", :action => "logout"
  match 'forgotpassword', :controller => "authentications", :action => "forgotpassword"
  match 'resetpassword/:id', :controller => "authentications", :action => "resetpassword"
  match 'setpassword', :controller => "authentications", :action => "setpassword"
  match 'auto_complete/:key', :controller => "dashboard", :action => "auto_complete", :constraints => {:key => /[^\/]*/}
  match 'SyncAmazon', :controller => "dashboard", :action =>"syncamazon"
  match 'dashboard', :controller => "dashboard", :action => "index"
  match '/dashboard(/:key)', :controller => "dashboard", :action => "index"
  match ':controller/:action/:id'
  match ':controller/:action'
  match '/installer' => redirect("http://s3.amazonaws.com/VersaVault/VersaVaultSyncTool_32Bit.exe")
  # routes for web service
  #match 'get_amazon_bucket_id(/:username/:password)', :controller => "authentications", :action => "getamazonbucketid"
  # See how all your routes lay out with "rake routes"
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
