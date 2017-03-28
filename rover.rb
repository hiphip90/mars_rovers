class Rover
  attr_accessor :id, :x, :y, :heading, :chassis, :control_unit

  def initialize(id)
    @id = id
    @x = 0
    @y = 0
    @heading = 'N'
  end

  def receive(instructions)
    control_unit.execute_instructions(instructions)
    report_position
  end

  def report_position
    puts "##### Rover ##{id} #####"
    puts "X: #{x}"
    puts "Y: #{y}"
    puts "Heading: #{heading}"
    puts '####################'
  end

  def report_error
    puts "##### Rover ##{id} #####"
    puts 'Unknown instruction, standing by'
    puts '####################'
  end

  def <=>(other)
    id <=> other.id
  end
end
