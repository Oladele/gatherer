require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do

  describe "POST create" do
    it "creates a project" do
      post :create, project: {name: "Runway", tasks: "Start something:2"}
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action).project.name).to eq("Runway")
    end

    it "creates a project (mock version)" do
      fake_action = instance_double(CreatesProject, create: true)
      expect(CreatesProject).to receive(:new).with(name: "Runway", task_string: "start something:2").and_return(fake_action)
      post :create, project: {name: "Runway", tasks: "start something:2"}
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action)).not_to be_nil
    end

    it "goes back to the form on failure" do
      post :create, project: {name: "", tasks: ""}
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end

    # [Above]..we had to think of a case where the save would fail. (The RSpec-generated scaffold tests cover failure similarly, with the need for you to create a set of invalid parameters for an object.)

    # We won’t always be able to do that so easily, but we can mock objects to ensure a failing create. I’ll throw in the failing update test, even though we didn’t put update in our controller in the earlier tutorial—it’s still a test structure you might find useful:

    it "fails create gracefully" do
      action_stub = double(create: false, project: Project.new)
      expect(CreatesProject).to receive(:new).and_return(action_stub)
      post :create, :project => {:name => 'Project Runway'}
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end

  end

  describe "PATCH update" do

    let(:sample){ Project.create!(name:"Test Project")}
    
    before(:example) do
      allow(Project).to receive(:find).and_return(sample)
    end


    it "changes a project" do
      expect(sample).to receive(:update_attributes).and_return(true)
      patch :update, id: sample.id, project: {name: "Fred"}
      expect(response).to redirect_to(project_path)
    end

    it "fails update gracefully" do
      expect(sample).to receive(:update_attributes).and_return(false)
      patch :update, id: sample.id, project: {name: "Fred"}
      expect(response).to render_template(:edit)
      expect(assigns(:project)).to be_present
    end
  end

end
