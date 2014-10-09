class Task
  attr_accessor :size, :completed_at

  def initialize(options = {})
    mark_completed(options[:completed_at]) if options[:completed_at]
    # @completed = options[:completed]
    @size = options[:size]
  end
  
  def mark_completed ( date = nil )
    @completed_at = (date || Time.current)
    # @completed = true
  end

  def complete?
    completed_at.present?
  end

  def part_of_velocity?
    complete? and completed_at > Project.velocity_length_in_days.days.ago
  end

  def points_toward_velocity
    if part_of_velocity? then size else 0 end
  end

end