require_relative '../rover'
require_relative 'chassis'
require_relative 'control_unit'
require_relative 'guidance_unit'

class Rover::Factory
  attr_accessor :mission_control

  def initialize(mission_control)
    @mission_control = mission_control
  end

  def fabricate_rover(id, x, y)
    rover = Rover.new(id, x, y)
    rover.chassis = Rover::Chassis.new(rover)
    guidance_unit = Rover::GuidanceUnit.new(mission_control, rover)
    rover.control_unit = Rover::ControlUnit.new(rover, rover.chassis, guidance_unit)
    rover
  end
end
