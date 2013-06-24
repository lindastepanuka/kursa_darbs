class Task < ActiveRecord::Base
  attr_accessible :completion_date, :description, :due_date, :name, :priority, :project_id, :state

  belongs_to :project, dependent: :destroy

  validates :due_date, :name, :project_id, presence: true
  validates :completion_date, presence: true, if: Proc.new{ |t| t.complete? }
  validates_inclusion_of :priority, in: (1..10).to_a

  def self.overdue
    where(state: "new").select{ |t| t.due_date.past? }
  end

  def self.complete
    where(state: "complete")
  end

  def self.to_do
    where(state: "new").select{ |t| !t.due_date.past?}
  end

  def complete
    self.state = "complete"
    self.completion_date = Time.now.to_date
    self.save
  end

  def complete?
    self.state == "complete"
  end
end
