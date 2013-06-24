require 'spec_helper'

describe Task, :type => :feature do
  use_transactional_fixtures = true
  fixtures :projects
  fixtures :tasks

  before :each do
    @project = projects(:project)
    @task = tasks(:sample_task)
  end

  it "creates a new task" do
    visit '/tasks/new'
    within("form") do
      fill_in 'Name', with: 'Pirmais uzdevums'
      fill_in 'State', with: 'new'
      fill_in 'Priority', with: 1
      select @project.name, from: "Project"
    end

    click_button 'Create Task'
    expect(page).to have_content 'Task was successfully created.'
    expect(page).to have_content 'Pirmais uzdevums'
    expect(page).to have_content 'new'
    expect(page).to have_content '1'
    expect(page).to have_content @project.name
  end

  it "views task index" do
    visit '/tasks'
    expect(page).to have_content @task.name
  end

  it "views task complete index" do
    visit '/complete_index'
    page.should_not have_content @task.name
    @task.complete
    visit '/complete_index'
    page.should have_content @task.name
  end

  it "views task to_do index" do
    @task.due_date = Date.today
    @task.save
    visit '/to_do_index'
    page.should have_content @task.name
  end

  it "views task overdue index" do
    visit '/overdue_index'
    page.should_not have_content @task.name
    @task.due_date = Date.today-1.day
    @task.save
    visit '/overdue_index'
    page.should have_content @task.name
  end

  it "views task" do
    visit "/tasks/#{@task.id}"
    expect(page).to have_content @task.name
    expect(page).to have_content @project.name
  end

  it "deletes task" do
    task_count = Task.all.size
    visit '/tasks'
    first("tr.index").click_link('Destroy')
    Task.all.size.should eq task_count-1
  end
end