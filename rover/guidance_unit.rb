class Rover::GuidanceUnit
  CLOCKWISE_COMPASS = %w(N E S W).freeze
  COUNTERCLOCKWISE_COMPASS = %w(N W S E).freeze

  attr_reader :mission_control, :rover

  def initialize(mission_control, rover)
    @mission_control = mission_control
    @rover = rover
  end

  def destination_obstructed?(x, y)
    !mission_control.tile_free?(x, y, rover.id)
  end

  def move_ahead(x, y, heading)
    case heading
    when 'N'
      y += 1
    when 'S'
      y -= 1
    when 'E'
      x += 1
    when 'W'
      x -= 1
    end
    return x, y, heading
  end

  def turn_clockwise(x, y, heading)
    new_heading = change_heading(heading, CLOCKWISE_COMPASS)
    return x, y, new_heading
  end

  def turn_counterclockwise(x, y, heading)
    new_heading = change_heading(heading, COUNTERCLOCKWISE_COMPASS)
    return x, y, new_heading
  end

  def change_heading(heading, compass)
    current_azimuth = compass.find_index(heading)
    compass.rotate(current_azimuth + 1).first
  end
end
