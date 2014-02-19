Deployer::Application.routes.draw do
  root 'deploy#show_deploy_api'
  get 'api', to: 'deploy#show_deploy_api', as: :show_deploy_api
  get 'ui', to: 'deploy#show_deploy_ui', as: :show_deploy_ui

  post 'deploy/do_deploy_api', to: 'deploy#do_deploy_api'
  post 'deploy/do_deploy_ui', to: 'deploy#do_deploy_ui'

  get 'deploy/check_deploy/:deploy_uid', to: 'deploy#check_deploy'
end
