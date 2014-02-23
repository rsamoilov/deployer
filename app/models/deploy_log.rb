class DeployLog
  def initialize(deploy_uid)
    @deploy_uid = deploy_uid
  end

  def write(line)
    logs = read_logs
    logs << line
    Rails.cache.write @deploy_uid, logs
  end

  def read(from_position = 0)
    read_logs.from from_position
  end

  def clear
    Rails.cache.delete @deploy_uid
  end

  private

  def read_logs
    Rails.cache.read(@deploy_uid) || []
  end
end
