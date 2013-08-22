Monet::Application.routes.draw do
  get "user/index"

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'users#index'

  resources :users, :addresses, :charges, :classis, :discharges, :eassistances
  resources :employees, :expenses, :groups, :payments, :people, :schoolyears
  resources :students, :works, :siblingrelations

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match "login", :to => "sessions#login"
  match "logout", :to => "sessions#logout"
  match "user/change_admin/:id" => "users#change_admin"
  match "user/change_student/:id" => "users#change_student"
  match "schoolyear/close/:id" => "schoolyears#close"
  match "schoolyear/activate/:id" => "schoolyears#activate"
  match "schoolyear/inscription/:id" => "schoolyears#inscription"
  
end
