Rails.application.routes.draw do
  root "top#show"

  resource :setting, only: %w(show)
  resources :data_sources
  resources :masked_data, except: %w(edit update)
  resources :ignored_tables, except: %w(edit update)

  resources :users, except: %w(show destroy)

  resource :search, controller: :search_results, as: :search_results, only: %w(show)

  resources :databases, controller: :database_memos, as: :database_memos do
    resources :schemas, controller: :schema_memos, as: :schema_memos, shallow: true, except: %w(index) do
      resources :tables, controller: :table_memos, as: :table_memos, shallow: true, except: %w(index) do
        resources :columns, controller: :column_memos, as: :column_memos, shallow: true, only: %w(edit update destroy) do
          resources :logs, controller: :column_memo_logs, as: :logs, only: "index"
        end

        resources :logs, controller: :table_memo_logs, as: :logs, only: "index"

        resource :favorite_table, only: %w(create destroy)
      end
    end

    resources :logs, controller: :database_memo_logs, as: :logs, only: "index"
  end

  get "/databases/:database_name/:name" => "schema_memos#show", as: "database_schema"
  get "/databases/:database_name/:schema_name/:name" => "table_memos#show", as: "database_schema_table"

  resource :markdown_preview, only: %w(create)

  get "auth/google_oauth2/callback", to: "sessions#create"
  get "logout", to: "sessions#destroy"
end
