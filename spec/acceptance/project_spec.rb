require 'spec_helper'

feature Project do
  use_transactional_fixtures = true
  fixtures :projects

  background do
    @project = projects(:project)
  end

  scenario "creates a new project" do
    visit '/projects/new'
    within("form") do
      fill_in 'Name', with: 'Projekta nosaukums'
      fill_in 'Description', with: 'Projekta apraksts'
    end

    click_button 'Create Project'
    expect(page).to have_content 'Project was successfully created.'
    expect(page).to have_content 'Projekta nosaukums'
    expect(page).to have_content 'Projekta apraksts'
  end

  scenario "views project index" do
    visit '/projects'
    expect(page).to have_content @project.name
  end

  scenario "views project" do
    visit "/projects/#{@project.id}"
    expect(page).to have_content @project.name
    expect(page).to have_content @project.description
  end

  scenario "deletes project" do
    project_count = Project.all.size
    visit '/projects'
    first("tr.index").click_link('Destroy')
    Project.all.size.should eq project_count-1
  end
end