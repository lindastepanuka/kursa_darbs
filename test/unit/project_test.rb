require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "validations" do
    project = projects(:project)
    project.name = nil
    assert !project.save
    assert !project.valid?
  end
end
