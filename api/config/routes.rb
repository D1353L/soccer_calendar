Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'matches/date=:date/refresh=:refresh', to: 'matches#show'
    end
  end
end
