Deployer::Application.routes.draw do
  root 'deploy#show_deploy_api'
  get 'api', to: 'deploy#show_deploy_api', as: :show_deploy_api
  get 'ui', to: 'deploy#show_deploy_ui', as: :show_deploy_ui
  get 'collector', to: 'deploy#show_deploy_collector', as: :show_deploy_collector

  post 'deploy/:service', to: 'deploy#do_deploy', as: :do_deploy
end
