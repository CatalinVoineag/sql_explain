SqlExplain::Engine.routes.draw do
  root to: "queries#show"

  resource :query, only: :show
end
