class RoverControlUnit
  attr_accessor :chassis, :rover

  def initialize(chassis, rover)
    @chassis = chassis
    @rover = rover
  end

  def execute_instructions(instructions)
    if /\A(?<x>\d) (?<y>\d) (?<heading>[NESW])?\z/ =~ instructions
      chassis.move_to(x, y, heading)
    elsif /\A[LRM]+\z/ =~ instructions
      instructions.each_char { |action| perform_action(action) }
    else
      rover.report_error
    end
  end

  private

  def perform_action(action)
    case action
    when 'L'
      chassis.turn_counterclockwise
    when 'R'
      chassis.turn_clockwise
    when 'M'
      chassis.move_ahead
    end
  end
end
