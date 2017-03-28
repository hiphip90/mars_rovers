class Rover::ControlUnit
  attr_accessor :chassis, :rover, :guidance_unit

  def initialize(rover, chassis, guidance_unit)
    @rover = rover
    @chassis = chassis
    @guidance_unit = guidance_unit
  end

  def report_manual
    rover.report do
      puts "L - turn 90 degrees counterclockwise. Can be combined with R, M in one instruction"
      puts "R - turn 90 degrees clockwise. Can be combined with L, M in one instruction"
      puts "M - move ahead 1 tile. Can be combined with L, R in one instruction"
      puts "\%X\% \%Y\% [\%heading\%] - go to coordinates. Heading is optional. If heading is present (must be one of N, E, S, W) will change heading, otherwise keep current heading"
    end
  end

  def execute_command(command)
    if /\A(?<x>\d)\w(?<y>\d)\w?(?<heading>[NESW])?\z/ =~ command
      move_to(x.to_i, y.to_i, heading)
    elsif /\A[LRM]+\z/ =~ command
      execute_movement_instructions(command)
    else
      report_unknown
    end
  end

  private

  def execute_movement_instructions(instructions)
    instructions.each_char do |instruction|
      destination = calculate_destination(instruction)
      move_to(*destination)
    end
  end

  def calculate_destination(instruction)
    case instruction
    when 'M'
      guidance_unit.move_ahead(rover.x, rover.y, rover.heading)
    when 'L'
      guidance_unit.turn_counterclockwise(rover.x, rover.y, rover.heading)
    when 'R'
      guidance_unit.turn_clockwise(rover.x, rover.y, rover.heading)
    end
  end

  def move_to(x, y, heading)
    if guidance_unit.destination_obstructed?(x, y)
      report_obstructed
    else
      chassis.move_to(x, y, heading)
    end
  end

  def report_unknown
    rover.report { puts 'Unknown instruction, standing by' }
  end

  def report_obstructed
    rover.report { puts 'Path is obstructed, standing by' }
  end
end