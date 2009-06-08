class DomainEvent < ActiveRecord::Base
  
  belongs_to :domain
  validates_presence_of :domain, :description, :started_at
  validates_presence_of :finished_at, :on => :update
  
  before_validation_on_create :start!
  
  def finish!
    self.finished_at = Time.now
    self.save
  end
  
private

  def start!
    self.started_at = Time.now
  end
  
end