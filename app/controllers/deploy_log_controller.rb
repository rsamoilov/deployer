class DeployLogController < WebsocketRails::BaseController
  def new_client
    deploy = Deploy.find_by(uid: message[:deploy_uid])
    logs = deploy.log.read

    send_message :current_logs, logs if logs.any?
  end
end
