require_relative 'rover'
require_relative 'rover_chassis'
require_relative 'rover_control_unit'
require_relative 'rover_guidance_unit'

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

  def list_rovers
    rovers.each(&:report_position)
  end

  def send_command_to_rover(id, command)
    open_comm_channel_with_rover(id).receive(command)
  end

  def report_rover_manual(id)
    open_comm_channel_with_rover(id).report_manual
  end

  def report_rover_position(id)
    open_comm_channel_with_rover(id).report_position
  end

  def open_comm_channel_with_rover(id)
    rovers.find { |rover| rover.id == id }
  end

  def tile_free?(x, y)
    return false if (x < 0 || y < 0)
    rovers.none? { |rover| rover.x == x && rover.y == y }
  end

  private

  def assemble_new_rover
    rover = Rover.new(next_id, *determine_landing_site)
    rover.chassis = RoverChassis.new(rover)
    guidance_unit = RoverGuidanceUnit.new(self)
    rover.control_unit = RoverControlUnit.new(rover, rover.chassis, guidance_unit)
    rover
  end

  def determine_landing_site
    (0..Float::INFINITY).each { |x| return [x,0] if tile_free?(x, 0) }
  end
end
