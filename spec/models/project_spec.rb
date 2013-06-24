require 'spec_helper'

describe Project do
  fixtures :projects

  it "should test validations" do
    project = projects(:project)
    project.name = nil
    project.should_not be_valid
    project.save.should_not be_true
  end
end
