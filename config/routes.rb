Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  get "/graphql", to: "graphql#schema"
  devise_for :users, skip: :sessions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
