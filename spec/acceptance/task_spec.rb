require 'spec_helper'

feature Task do
  use_transactional_fixtures = true
  fixtures :projects
  fixtures :tasks

  background do
    @project = projects(:project)
    @task = tasks(:sample_task)
  end

  scenario "should create a new task" do
    visit '/tasks/new'
    within("form") do
      fill_in 'Name', with: 'Pirmais uzdevums'
      fill_in 'State', with: 'new'
      fill_in 'Priority', with: 1
      select @project.name, from: "Project"
    end

    click_button 'Create Task'
    page.should have_content 'Task was successfully created.'
    page.should have_content 'Pirmais uzdevums'
    page.should have_content 'new'
    page.should have_content '1'
    page.should have_content @project.name
  end

  scenario "views task index" do
    visit '/tasks'
    page.should have_content @task.name
  end

  scenario "views task complete index" do
    visit '/complete_index'
    page.should_not have_content @task.name
    @task.complete
    visit '/complete_index'
    page.should have_content @task.name
  end

  scenario "views task to_do index" do
    @task.due_date = Date.today
    @task.save
    visit '/to_do_index'
    page.should have_content @task.name
  end

  scenario "views task overdue index" do
    visit '/overdue_index'
    page.should_not have_content @task.name
    @task.due_date = Date.today-1.day
    @task.save
    visit '/overdue_index'
    page.should have_content @task.name
  end

  scenario "views task" do
    visit "/tasks/#{@task.id}"
    expect(page).to have_content @task.name
    expect(page).to have_content @project.name
  end

  scenario "deletes task" do
    task_count = Task.all.size
    visit '/tasks'
    first("tr.index").click_link('Destroy')
    Task.all.size.should eq task_count-1
  end
end