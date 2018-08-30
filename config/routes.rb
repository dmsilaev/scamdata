Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   scope :api, defaults: { format: :json } do
    # devise_for :users,
    #   path: :auth,
    #   defaults: { format: :json },
    #   singular: :user,
    #   controllers: {
    #    sessions: 'devise/sessions',
    #    passwords: 'devise/passwords',
    #    registrations: 'devise/registrations'
    # }

    resource :profile, only: [:show]

    resources :exchanges, except: [:new, :edit, :destroy]
    resources :coins, except: [:new, :edit, :destroy]
  end
end
