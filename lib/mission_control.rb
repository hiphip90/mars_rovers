class MissionControl
  attr_reader :rovers
  attr_accessor :next_id, :rover_factory

  def initialize
    @rovers = []
    @next_id = 1
  end

  def deploy_new_rover
    rover = rover_factory.fabricate_rover(next_id, *determine_landing_site)
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

  def tile_free?(x, y, current_rover_id = nil)
    return false if (x < 0 || y < 0)
    rovers.none? do |rover|
      rover.id != current_rover_id && rover.x == x && rover.y == y
    end
  end

  private

  def determine_landing_site
    (0..Float::INFINITY).each { |x| return [x,0] if tile_free?(x, 0) }
  end
end
