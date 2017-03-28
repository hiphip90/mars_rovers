class RoverChassis
  CLOCKWISE_DIRECTIONS = %w(N E S W).freeze
  COUNTERCLOCKWISE_DIRECTIONS = %w(N W S E).freeze

  attr_reader :rover

  def initialize(rover)
    @rover = rover
  end

  def move_to(x, y, heading)
    rover.x = x
    rover.y = y
    rover.heading = heading
  end

  def move_ahead
    case rover.heading
    when 'N'
      rover.y += 1
    when 'S'
      rover.y -= 1
    when 'E'
      rover.x += 1
    when 'W'
      rover.x -= 1
    end
  end

  def turn_clockwise
    rover.heading = next_clockwise_heading
  end

  def turn_counterclockwise
    rover.heading = next_counterclockwise_heading
  end

  private

  def next_clockwise_heading
    current_heading = CLOCKWISE_DIRECTIONS.find_index(rover.heading)
    CLOCKWISE_DIRECTIONS.rotate(current_heading + 1).first
  end

  def next_counterclockwise_heading
    current_heading = COUNTERCLOCKWISE_DIRECTIONS.find_index(rover.heading)
    COUNTERCLOCKWISE_DIRECTIONS.rotate(current_heading + 1).first
  end
end
