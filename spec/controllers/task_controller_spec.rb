require 'spec_helper'

describe TasksController do
  use_transactional_fixtures = true
  fixtures :tasks

  before(:each) do
    @task = tasks(:one)
  end

  it "should get index" do
    get :index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_present
  end

  it "should get complete index" do
    Task.complete.map(&:destroy)
    get :complete_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_empty
    task = Task.create(description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    task.complete
    get :complete_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_present
  end

  it "should get to do index" do
    Task.to_do.map(&:destroy)
    get :to_do_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_empty
    task = Task.create(description: @task.description, due_date: Date.today+1.day, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    get :to_do_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_present
  end

  it "should get overdue index" do
    Task.to_do.map(&:destroy)
    get :overdue_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_empty
    task = Task.create(description: @task.description, due_date: Date.today-1.day, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: "new")
    get :overdue_index
    expect(response).to render_template("index")
    expect(assigns(:tasks)).to be_present
  end

  it "should complete task" do
    complete_task_count = Task.complete.size
    post :complete, id: @task.id

    complete_task_count.should < Task.complete.size

    flash[:notice].should eq 'Task was successfully completed'
  end

  it "should get new" do
    get :new
    expect(response).to render_template("new")
  end

  it "should create task" do
    task_count = Task.all.size
    post :create, task: { completion_date: @task.completion_date, description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: @task.state }
    task_count.should < Task.all.size
    response.should redirect_to task_path(Task.last)
    flash[:notice].should eq 'Task was successfully created.'
  end

  it "should show task" do
    get :show, id: @task
    expect(response).to render_template("show")
  end

  it "should get edit" do
    get :edit, id: @task
    expect(response).to render_template("edit")
  end

  it "should update task" do
    put :update, id: @task, task: { completion_date: @task.completion_date, description: @task.description, due_date: @task.due_date, name: @task.name, priority: @task.priority, project_id: @task.project_id, state: @task.state }
    response.should redirect_to task_path(@task)
  end

  it "should destroy task" do
    task_count = Task.all.size
    delete :destroy, id: @task
    task_count.should > Task.all.size
    response.should redirect_to tasks_path
  end
end
