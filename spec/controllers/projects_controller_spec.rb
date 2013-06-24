require 'spec_helper'

describe ProjectsController do
  use_transactional_fixtures = true
  fixtures :projects

  before(:each) do
    @project = projects(:one)
  end

  it "should get index" do
    get :index
    expect(response).to render_template("index")
    expect(assigns(:projects)).to be_present
  end

  it "should get new" do
    get :new
    expect(response).to render_template("new")
  end

  it "should create project" do
    project_count = Project.all.size
    post :create, project: { description: @project.description, name: @project.name }
    project_count.should < Project.all.size
    response.should redirect_to project_path(Project.last)
    flash[:notice].should eq 'Project was successfully created.'
  end

  it "should show project" do
    get :show, id: @project
    expect(response).to render_template("show")
  end

  it "should get edit" do
    get :edit, id: @project
    expect(response).to render_template("edit")
  end

  it "should update project" do
    put :update, id: @project, project: { description: @project.description, name: @project.name }
    response.should redirect_to project_path(@project)
  end

  it "should destroy project" do
    project_count = Project.all.size
    delete :destroy, id: @project
    project_count.should > Project.all.size
    response.should redirect_to projects_path
  end
end
