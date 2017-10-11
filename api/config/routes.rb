Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'matches/:date', to: 'matches#show'
      post 'matches/refresh/:date', to: 'matches#refresh'
    end
  end
end
