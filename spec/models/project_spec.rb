require 'rails_helper'

RSpec.describe Project do

#You might use a full double object to stand in for an entire object that is unavailable or prohibitively expensive to create or call in the test environment. In Ruby, though, you would more often take advantage of the way Ruby allows you to open up existing classes and objects for the purposes of adding or overriding methods. It’s easy to take a “real” object and stub out only the methods that you need. This is extraordinarily useful when it comes to actual uses of stub objects.

#In RSpec, this is managed with the allow method.
  it "stubs an object" do
    project = Project.new(name: "Project Greenlight")
    allow(project).to receive(:name)
    expect(project.name).to be_nil
  end

# This test passes: line 3 sets up the stub, and the project.name call in line 4 is intercepted by the stub to return nil and never even gets to the actual project name.

# In RSpec 3.0, if you set mocks.verify_partial_doubles in the configuration file, then partial doubles will also be verified, meaning that the test will fail if the double is asked to stub a method that the object does not respond to.

# Having a stub that always returns nil is a little pointless, so RSpec allows you to specify a return value for the stubbed method using the following syntax:

  it "stubs an object again" do
    project = Project.new(:name => "Project Greenlight")
    allow(project).to receive(:name).and_return("Fred")
    expect(project.name).to eq("Fred")
  end

# # Line 19 ('allow..') is doing the heavy lifting here, tying the return value Fred to the method :name. The allow method returns a proxy to the real object, but which responds to a number of methods that let you annotate the stub. The and_return methodis one of those annotation messages which associates the return value with the method.
# Since classes in Ruby are really just objects themselves, you’d probably expect that you can stub classes just like stubbing instance objects. You’d be right
  
  it "stubs the class" do
    allow(Project).to receive(:find).and_return(
      Project.new(:name => "Project Greenlight"))
    project = Project.find(1)
    expect(project.name).to eq("Project Greenlight")
  end

# In this test, the class Project is being stubbed to return a specific project instance whenever find is called. In line 4, the find method is, in fact, called, and returns that object.

# Let’s pause here a second and examine what we’ve actually done in this test. We’re using find to get an ActiveRecord object. And because we are stubbing find we’re not touching the actual database. Using the database is, for testing purposes, slow. Very slow. And this is one strategy for avoiding the database. In the meantime, remember that this stub shouldn’t be used to verify that the find method works; it should be used by other tests that need the find method along the way to the other logic that is actually under test.

# That said, in actual practice, you also should avoid stubbing the find method because it’s part of an external library—you might be better off creating a model method that has a more meaningful and specific behavior and stubbing that method.

# Mock Expectations

# A mock object retains the basic idea of the stub—returning a specified value without actually calling a live method—and adds the requirement that the specified method must actually be called during the test. In other words, a mock is like a stub with attitude, expecting—nay, demanding—that its parameters be matched in the test or else we get a test failure.

# In RSpec, you use the expect method to create mock expectations. This can be applied to full or partial doubles.

  it "mocks an object" do
    mock_project = Project.new(:name => "Project Greenlight")
    expect(mock_project).to receive(:name).and_return("Fred")
    expect(mock_project.name).to eq("Fred")
  end

  describe "initialization" do
    let(:project) { Project.new }
    let(:task) { Task.new }

    it "considers a project with no test to be done" do
      expect(project).to be_done
    end

    it "knows that a project with an incomplete task is not done" do 
      project.tasks << task
      expect(project).not_to be_done
    end

    it "marks a project done if its tasks are done" do
      project.tasks << task
      task.mark_completed
      expect(project).to be_done
    end

    it "properly estimates a blank project" do
      expect(project.completed_velocity).to eq(0)
      expect(project.current_rate).to eq(0)
      expect(project.projected_days_remaining.nan?).to be_truthy
      expect(project).not_to be_on_schedule
    end
  end

  describe "estimates" do
    let(:project) { Project.new }
    let(:newly_done) { Task.new(size: 3, completed_at: 1.day.ago) } 
    let(:old_done) { Task.new(size: 2, completed_at: 6.months.ago) } 
    let(:small_not_done) { Task.new(size: 1) } 
    let(:large_not_done) { Task.new(size: 4) }
    
    before(:example) do
      project.tasks = [newly_done, old_done, small_not_done, large_not_done]
    end
    
    it "can calculate total size" do 
      expect(project.total_size).to eq(10)
    end

    # as above but using custom matchers
    it "can calculate total size" do
      expect(project).to be_of_size(10)
      expect(project).to be_of_size(5).for_incomplete_tasks_only
    end
    
    it "can calculate remaining size" do 
      expect(project.remaining_size).to eq(5)
    end

    it "knows its velocity" do
      expect(project.completed_velocity).to eq(3)
    end

    it "knows its rate" do
      expect(project.current_rate).to eq(1.0 / 7)
    end

    it "knows its projected time remaining" do
      expect(project.projected_days_remaining).to eq(35)
    end

    it "knows if it is on schedule" do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
      project.due_date = 6.months.from_now
      expect(project).to be_on_schedule
    end

    it "knows if its on schedule when velocity is 0" do
      project.tasks = [small_not_done]
      expect(project).not_to be_on_schedule
    end

    it "knows if its on schedule when due_date is undefined" do
      project.due_date = nil
      expect(project).to be_on_schedule
    end

  end

end