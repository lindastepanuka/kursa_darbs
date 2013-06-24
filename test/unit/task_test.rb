require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  use_transactional_fixtures = true

  test "complete task" do
    task = tasks(:sample_task)
    task.complete

    assert task.state == "complete"
    assert task.completion_date == Date.today
    assert task.updated_at > task.created_at
    assert task.complete?
  end

  test "validations" do
    ["due_date", "name", "project_id"].each do |attribute|
      task = tasks(:sample_task)
      task.send("#{attribute}=", nil)
      assert !task.valid?
      assert !task.save
      task.reload
    end
    task = tasks(:sample_task)
    task.priority = 11
    assert !task.valid?
    task.reload
    task.state = "complete"
    assert !task.valid?
  end

  test "overdue selector" do
    task = tasks(:sample_task)
    task.due_date = Date.today - 1.day
    task.save
    assert Task.overdue.present?
  end

  test "complete selector" do
    task = tasks(:sample_task)
    task.complete
    assert Task.complete.present?
  end

  test "to do selector" do
    assert Task.to_do.present?
  end
end
