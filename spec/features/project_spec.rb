require 'spec_helper'

describe Task, :type => :feature do
  use_transactional_fixtures = true
  fixtures :projects

  before :each do
    @project = projects(:project)
  end

  it "creates a new task" do
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

  it "views project index" do
    visit '/projects'
    expect(page).to have_content @project.name
  end

  it "views project" do
    visit "/projects/#{@project.id}"
    expect(page).to have_content @project.name
    expect(page).to have_content @project.description
  end

  it "deletes project" do
    project_count = Project.all.size
    visit '/projects'
    first("tr.index").click_link('Destroy')
    Project.all.size.should eq project_count-1
  end
end