require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  use_transactional_fixtures = true

  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get complete index" do
    Task.complete.map(&:destroy)
    get :complete_index
    assert_response :success
    assert_empty assigns(:tasks)
    task = Task.create(description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    task.complete
    get :complete_index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get to do index" do
    Task.to_do.map(&:destroy)
    get :to_do_index
    assert_response :success
    assert_empty assigns(:tasks)
    task = Task.create(description: @task.description, due_date: Date.today+1.day, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    get :to_do_index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get overdue index" do
    Task.to_do.map(&:destroy)
    get :overdue_index
    assert_response :success
    assert_empty assigns(:tasks)
    task = Task.create(description: @task.description, due_date: Date.today-1.day, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    get :overdue_index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should complete task" do
    assert_difference('Task.complete.count') do
      post :complete, id: @task.id
    end
    assert_redirected_to task_path(assigns(:task))
    assert_equal 'Task was successfully completed', flash[:notice]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { completion_date: @task.completion_date, description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: @task.state }
    end

    assert_redirected_to task_path(assigns(:task))
    assert_equal 'Task was successfully created.', flash[:notice]
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    put :update, id: @task, task: { completion_date: @task.completion_date, description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: @task.state }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
