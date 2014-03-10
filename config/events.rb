WebsocketRails::EventMap.describe do
  namespace :deploy_log do
    subscribe :new_client, to: DeployLogController, with_method: :new_client
  end
end
