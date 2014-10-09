class CreatesProject
  attr_accessor :name, :task_string, :project
  
  def initialize(name: "", task_string: "")
    @name = name
    @task_string = task_string

  end

  def build
    self.project = Project.new(name: name)
    project.tasks = convert_string_to_tasks
    project
  end

  def convert_string_to_tasks
    # asumes space separated lists of tasks
    task_string_array = task_string.split "\n"
    
    # each task is formatted as title:size
    task_string_array.map do |task_string|
      title,size = task_string.split":"
      size = 1 if (size.blank? || size.to_i.zero?)
      Task.new(title: title, size: size)
    end
  end

  def create
    build
    project.save
  end

end