require 'spec_helper'

describe Task do
  use_transactional_fixtures = true
  fixtures :tasks

  it "should complete task" do
    task = tasks(:sample_task)
    task.complete

    task.state.should == "complete"
    task.completion_date.should == Date.today
    task.updated_at.should > task.created_at
    task.complete?.should be_true
  end

  it "should test validations" do
    task = tasks(:sample_task)
    ["due_date", "name", "project_id"].each do |attribute|
      task.send("#{attribute}=", nil)
      task.should_not be_valid
      task.save.should_not be_true
      task.reload
    end
    task.priority = 11
    task.should_not be_valid
    task.reload
    task.state = "complete"
    task.should_not be_valid
  end

  it "should select correct overdue tasks" do
    task = tasks(:sample_task)
    task.due_date = Date.today - 1.day
    task.save
    Task.overdue.should be_present
  end

  it "should select correct complete tasks" do
    task = tasks(:sample_task)
    task.complete
    Task.complete.should be_present
  end

  it "should select correct to do tasks" do
    Task.to_do.should be_present
  end
end
