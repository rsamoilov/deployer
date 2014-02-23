class DeployTool
  class << self
    # asynchronously perform deploy
    # service is either ui or api
    def deploy(service)
      deploy_lock = DeployLock.instance(service)

      if deploy_lock.locked?
        nil
      else
        deploy_object = Deploy.create!(service: service)
        Thread.new do
          deploy_lock.with_lock do
            run_deploy_commands_for service, deploy_object.log
            deploy_object.finish!
          end
          ActiveRecord::Base.connection_pool.release_connection
        end

        deploy_object.uid
      end
    end

    private

    def run_deploy_commands_for(service, log)
      command = Deployer.config.deploy_commands.send(service)
      IO.popen(command).each do |line|
        log.write line
      end
    end
  end # class << self
end
