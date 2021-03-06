DotaQuantify::Application.routes.draw do
  resources :heros do
    member do
      get :kda
    end
  end

  resources :parties

  resources :matches do
    collection do
      get 'fetch'
      get 'fetch_for_followed'
      get 'fetch_recent'
      get 'export'
      get 'calendar'
      get 'random'
    end
  end

  resources :profiles, path: "/players" do
    collection do
      get 'dashboard'
      get 'export'
    end
    member do
      get 'heroes'
      get 'matches'
    end
  end

  resources :players, path: "/performances" do
    collection do
      get 'charts'
      get 'charts_data'
    end
  end

  get 'reports/:type/:year(/:month(/:day))' => 'reports#show', as: "report"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'profiles#dashboard'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
