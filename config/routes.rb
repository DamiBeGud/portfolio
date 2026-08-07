Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resources :contact_messages, only: [ :create ]

  namespace :admin do
    root "sections#index"
    resource :session, only: [ :new, :create, :destroy ]
    resource :home_section, path: "home", only: [ :edit, :update ]
    resource :about_section, path: "about", only: [ :edit, :update ]
    resource :contact_section, path: "contact", only: [ :edit, :update ]
    resource :settings, only: [ :edit, :update ] do
      patch :reset_colors
      patch :reset_color
    end
    patch "projects/section", to: "projects#update_section", as: :projects_section
    resources :projects, except: :show do
      patch :move_higher, on: :member
      patch :move_lower, on: :member
    end
    resources :timeline_entries, except: :show do
      patch :move_higher, on: :member
      patch :move_lower, on: :member
    end
    resources :info_cards, except: :show
    resources :contact_links, except: :show
    resources :contact_messages, only: [ :index, :show, :update ]
  end
end
