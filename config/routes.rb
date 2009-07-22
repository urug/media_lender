ActionController::Routing::Routes.draw do |map|

  map.resources :friendships

  map.resource :session
  
  map.friends 'friends', :controller => 'friends', :action => 'index'
  map.invite_friends 'friends/invite', :controller => 'friends', :action => 'invite'
  
  map.pickup_invitation 'pickup_invitation/:invite_token', :controller => 'users', :action => 'pickup_invitation'
  
  map.movies_by_letter 'movies/sorted/:letter', 
                       :controller => "movies", 
                       :action => "sorted"
  map.friends_movies '/movies/friends', :controller => 'movies', :action => 'friends'                     
  map.borrow_movie 'movies/:id/borrow', :controller => 'movies', :action => 'borrow'
  map.resources :movies
  map.resources :users
  map.resource  :account

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
