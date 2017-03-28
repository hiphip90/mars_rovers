class RoverControlUnit
  attr_accessor :chassis, :rover

  def initialize(chassis, rover)
    @chassis = chassis
    @rover = rover
  end

  def self.report_manual
    "\tL - turn 90 degrees counterclockwise. Can be combined with R, M in one instruction\r\n" + \
    "\tR - turn 90 degrees clockwise. Can be combined with L, M in one instruction\r\n" + \
    "\tM - move ahead 1 tile. Can be combined with L, R in one instruction\r\n" + \
    "\t\%X\% \%Y\% [\%heading\%] - go to coordinates. Heading is optional. If heading is present (must be one of N, E, S, W) will change heading, otherwise keep current heading"
  end

  def execute_instructions(instructions)
    if /\A(?<x>\d) (?<y>\d)(?<heading> [NESW])?\z/ =~ instructions
      chassis.move_to(x.to_i, y.to_i, heading)
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
