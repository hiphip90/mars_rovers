require_relative 'rover'
require_relative 'rover_chassis'
require_relative 'rover_control_unit'

class MissionControl
  attr_reader :rovers
  attr_accessor :next_id

  def initialize
    @rovers = []
    @next_id = 1
  end

  def deploy_new_rover
    rover = assemble_new_rover
    rovers << rover
    self.next_id += 1
    rover.report_position
  end

  def send_instructions_to_rover(id, instructions)
    rover = open_comm_channel_with_rover(id)
    rover.receive(instructions)
  end

  def open_comm_channel_with_rover(id)
    rovers.find { |rover| rover.id == id }
  end

  def list_rovers
    rovers.each(&:report_position)
  end

  def report_rover_manual
    RoverControlUnit.report_manual
  end

  def report_rover_position(id)
    rover = open_comm_channel_with_rover(id)
    rover.report_position
  end

  private

  def assemble_new_rover
    rover = Rover.new(next_id)
    rover.chassis = RoverChassis.new(rover)
    rover.control_unit = RoverControlUnit.new(rover.chassis, rover)
    rover
  end
end
