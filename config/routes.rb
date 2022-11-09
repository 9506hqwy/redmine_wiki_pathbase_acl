# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  resources :projects do
    put '/wiki_pathbase_acl', to: 'wiki_pathbase_acl#update', format: false
  end
end
