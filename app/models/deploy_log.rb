class DeployLog
  def initialize(deploy)
    @deploy = deploy
  end

  def write(line)
    logs = read_logs
    logs << line
    Rails.cache.write @deploy.uid, logs
    @deploy.notify_update 'logs_update', [line]
  end

  def read(from_position = 0)
    read_logs.from from_position
  end

  def clear
    Rails.cache.delete @deploy.uid
  end

  private

  def read_logs
    Rails.cache.read(@deploy.uid) || []
  end
end
