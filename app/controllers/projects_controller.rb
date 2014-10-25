class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @action = CreatesProject.new(
      name: params[:project][:name],
      task_string: params[:project][:tasks])
    success = @action.create
    if success
      redirect_to projects_path
    else
      @project = @action.project
      render :new
    end
  end

  def update
    @project = Project.find params[:id]
    success = @project.update_attributes params[:project]
    if success
      redirect_to @project, notice: "'project was successfully updated.'"
    else
      render :edit
    end
  end

end
