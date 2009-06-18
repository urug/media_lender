ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.welcome "welcome", :controller => "welcome", :action => "index"
  map.resources :user_sessions
  map.resources :users
  map.resources :movies
  map.root :controller => 'movies'
end
