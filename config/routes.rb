# frozen_string_literal: true

Rails.application.routes.draw do
  mount(GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql') if Rails.env.development?

  post '/graphql', to: 'graphql#execute'

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post '/entities/process-image', to: 'entities#process_image'
  post '/entities/process-file', to: 'entities#process_file'

  root to: redirect(path: '/api-docs')

  devise_for :users, controllers: {
    confirmations: 'confirmations',
    registrations: 'registrations',
    sessions: 'sessions'
  }
  scope '/devise' do
    resources :users do
      get 'statistics', on: :collection
      get 'export_data', on: :collection
    end
  end

  devise_scope :user do
    get '/users/password', to: 'devise/passwords#new'
    post '/authenticate/credentials', to: 'authentication#sign_in_ux'
    post '/authenticate/auth0', to: 'authentication#sign_in_auth0'
    post '/authenticate/signup', to: 'authentication#sign_up_ux'

    post '/authentication/resend-activation-email', to: 'authentication#resend_activation_email'
    delete '/authentication/invalidate', to: 'authentication#invalidate_token'
    post '/authentication/reset-password', to: 'authentication#reset_password'
    post '/authentication/apply-reset-token', to: 'authentication#apply_reset_token'
    post '/authentication/validate-reset-token', to: 'authentication#validate_reset_token'
  end

  # Start of external API routes
  get 'api/v1/organizations/:id', to: 'organizations#unique_search'
  get 'api/v1/organizations', to: 'organizations#simple_search', defaults: { format: 'json' }
  post 'api/v1/organizations', to: 'organizations#complex_search', defaults: { format: 'json' }

  get 'api/v1/building_blocks/:id', to: 'building_blocks#unique_search'
  get 'api/v1/building_blocks', to: 'building_blocks#simple_search', defaults: { format: 'json' }
  post 'api/v1/building_blocks', to: 'building_blocks#complex_search', defaults: { format: 'json' }

  get 'api/v1/govstack_building_blocks', to: 'building_blocks#govstack_search', defaults: { format: 'json' }
  get 'api/v1/govstack_building_blocks/:id', to: 'building_blocks#govstack_unique_search'

  get 'api/v1/cities/:id', to: 'cities#unique_search'
  get 'api/v1/cities', to: 'cities#simple_search', defaults: { format: 'json' }

  get 'api/v1/countries/:id', to: 'countries#unique_search'
  get 'api/v1/countries', to: 'countries#simple_search', defaults: { format: 'json' }

  get 'api/v1/products/:id', to: 'products#unique_search'
  get 'api/v1/products', to: 'products#simple_search', defaults: { format: 'json' }
  post 'api/v1/products', to: 'products#complex_search', defaults: { format: 'json' }
  post 'api/v1/products/owners', to: 'products#owner_search', defaults: { format: 'json' }

  get 'api/v1/govstack_products', to: 'products#govstack_search', defaults: { format: 'json' }
  get 'api/v1/govstack_products/:id', to: 'products#govstack_unique_search'

  get 'api/v1/projects/:id', to: 'projects#unique_search'
  get 'api/v1/projects', to: 'projects#simple_search', defaults: { format: 'json' }
  post 'api/v1/projects', to: 'projects#complex_search', defaults: { format: 'json' }

  get 'api/v1/sectors/:id', to: 'sectors#unique_search'
  get 'api/v1/sectors', to: 'sectors#simple_search', defaults: { format: 'json' }

  get 'api/v1/sdgs/:id', to: 'sustainable_development_goals#unique_search'
  get 'api/v1/sdgs', to: 'sustainable_development_goals#simple_search', defaults: { format: 'json' }
  post 'api/v1/sdgs', to: 'sustainable_development_goals#simple_search', defaults: { format: 'json' }

  get 'api/v1/sustainable_development_goals/:id', to: 'sustainable_development_goals#unique_search'
  get 'api/v1/sustainable_development_goals', to: 'sustainable_development_goals#simple_search',
                                              defaults: { format: 'json' }

  get 'api/v1/tags/:id', to: 'tags#unique_search'
  get 'api/v1/tags', to: 'tags#simple_search', defaults: { format: 'json' }

  get 'api/v1/use_cases/:id', to: 'use_cases#unique_search'
  get 'api/v1/use_cases', to: 'use_cases#simple_search', defaults: { format: 'json' }
  post 'api/v1/use_cases', to: 'use_cases#complex_search', defaults: { format: 'json' }

  get 'api/v1/govstack_use_cases', to: 'use_cases#govstack_search', defaults: { format: 'json' }
  get 'api/v1/govstack_use_cases/:id', to: 'use_cases#unique_search'

  get 'api/v1/use_cases/:id/use_case_steps/:step_id', to: 'use_case_steps#unique_search'
  get 'api/v1/use_cases/:id/use_case_steps', to: 'use_case_steps#simple_search', defaults: { format: 'json' }

  get 'api/v1/workflows/:id', to: 'workflows#unique_search'
  get 'api/v1/workflows', to: 'workflows#simple_search', defaults: { format: 'json' }
  post 'api/v1/workflows', to: 'workflows#complex_search', defaults: { format: 'json' }

  get 'api/v1/opportunities/:id', to: 'opportunities#unique_search'
  get 'api/v1/opportunities', to: 'opportunities#simple_search', defaults: { format: 'json' }

  get 'api/v1/govstack_opportunities', to: 'opportunities#govstack_search', defaults: { format: 'json' }
  get 'api/v1/govstack_opportunities/:id', to: 'opportunities#govstack_unique_search'

  # End of external API routes

  get '/healthcheck', to: 'about#healthcheck', as: :healthcheck
  get '/tenant', to: 'about#tenant', as: :tenant
  get '/tenants', to: 'about#tenants', as: :tenants

  post '/send_email', to: 'application#send_email', as: :send_email
  post '/create_issue', to: 'application#create_issue', as: :create_issue

  post '/froala_image/upload' => 'froala_images#upload'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#server_error', via: :all
  match '/422', to: 'errors#server_error', via: :all
end
