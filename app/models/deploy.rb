class Deploy < ActiveRecord::Base
  STATES = %w(in_progress deployed)
  validates :state, inclusion: { in: STATES }
  validates :service, presence: true

  before_validation :generate_uid
  before_validation :set_default_state

  def in_progress?
    self.state == 'in_progress'
  end

  def deployed?
    self.state == 'deployed'
  end

  def finish!
    update_attribute :state, 'deployed'
  end

  def log
    @log ||= DeployLog.new(self.uid)
  end

  private

  def generate_uid
    self.uid ||= SecureRandom.hex
  end

  def set_default_state
    self.state ||= 'in_progress'
  end
end
