class Project < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :tasks, dependent: :destroy

  validates :name, presence: true

end
