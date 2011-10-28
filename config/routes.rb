S3FileManager::Application.routes.draw do

  get "history/index"

  resources :comments

  match 'file_list/upload', :controller => "file_list", :action => "upload"


  resources :clients

  get "dashboard/index"

  get "file_list/index"

  resources :authentications

  resources :s3_uploads

  resources :projects

  resources :file_list

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "testupload#index"
  #root :controller => "authentications", :action => "new"
  root :controller => "clients" , :action => "index"

  match '/register' , :controller => "authentications", :action => 'register'
  match '/createuser' , :controller => "authentications", :action => 'createuser'
  match 'login', :controller => "authentications", :action => "new"
  match 'logout', :controller => "authentications", :action => "new"
  match 'forgotpassword', :controller => "authentications", :action => "forgotpassword"
  match 'resetpassword/:id', :controller => "authentications", :action => "resetpassword"
  match 'dashboard', :controller => "dashboard"
  match 'clients', :controller => "clients"

  match ':controller/:action/:id'
  match ':controller/:action'
  match "filelist/:id", :controller => "file_list", :action => "index"
  match 'projectlist/:id', :controller => "projects", :action => "index"
  match 'Commentlist/:id', :controller => "comments", :action => "index"
  match 'histories/:id', :controller => "history", :action => "index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
