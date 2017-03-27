require_relative 'rover'
require_relative 'rover_chassis'
require_relative 'rover_control_unit'

class Game
  attr_reader :rovers

  def initialize
    @rovers = []
  end

  def add_rover(id)
    rover = Rover.new(id)
    rover.chassis = RoverChassis.new(rover)
    rover.control_unit = RoverControlUnit.new(rover.chassis, rover)
    rovers << rover
  end

  def send_instructions_to_rover(id, instructions)
    rover = rovers.find { |rover| rover.id == id }
    if rover
      rover.receive(instructions)
    else
      puts 'This rover does not exist! Please select existing rover, or send a new one via add_rover.'
      list_rovers
    end
  end

  def list_rovers
    rovers.to_s
  end
end
