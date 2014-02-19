class DeployLock < ActiveRecord::Base
  def self.instance(service)
    DeployLock.where(service: service).first_or_create
  end

  def lock!
    update_attribute :locked, true
  end

  def unlock!
    update_attribute :locked, false
  end

  def with_lock
    lock!
    yield
    unlock!
  end
end
