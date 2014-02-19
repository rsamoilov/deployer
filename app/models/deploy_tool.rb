class DeployTool
  class << self
    # service is either ui or api
    def deploy(service)
      deploy_lock = DeployLock.instance(service)

      if deploy_lock.locked?
        nil
      else
        deploy_object = Deploy.create!(service: service)
        Thread.new do
          deploy_lock.with_lock do
            send "run_#{service}_commands"
            deploy_object.finish!
          end
          ActiveRecord::Base.connection_pool.release_connection
        end

        deploy_object.uid
      end
    end

    private

    def run_api_commands
      `notify-send Deploy "API deploy, please"`
      `gnome-terminal --disable-factory --working-directory=/home/r/Projects/api`
    end

    def run_ui_commands
      `notify-send Deploy "UI deploy, please"`
      `gnome-terminal --disable-factory --working-directory=/home/r/Projects/ui`
    end
  end # class << self
end
