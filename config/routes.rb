Nipanipa::Application.routes.draw do

  # first created -> highest priority.
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users, controllers: { registrations: 'users' },
                       path_names: { sign_in: 'signin', sign_out: 'signout' }

    resources :donations, only: [:new, :create, :show]

    resources :users, except: [:new, :create, :edit, :update, :destroy],
                      constraints: { id: /\d+/ } do
      resources :pictures
      resources :feedbacks
    end

    get 'conversations/new/:to' => 'conversations#new', as: :new_conversation
    resources :conversations, except: [:new, :edit, :update],
                              constraints: { id: /\d+/ } do
      put 'reply', on: :member
    end

    get 'help'       => 'static_pages#help'
    get 'about'      => 'static_pages#about'
    get 'contact'    => 'static_pages#contact'
    get 'terms'      => 'static_pages#terms'
    get 'robots.txt' => 'static_pages#robots'

    root 'static_pages#home'
  end

end
