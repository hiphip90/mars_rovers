class Rover::Chassis
  attr_reader :rover

  def initialize(rover)
    @rover = rover
  end

  def move_to(x, y, heading = nil)
    rover.x = x
    rover.y = y
    rover.heading = heading unless heading.nil?
  end
end
