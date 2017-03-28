class Rover
  attr_accessor :id, :x, :y, :heading, :chassis, :control_unit

  def initialize(id, x, y)
    @id = id
    @x = x
    @y = y
    @heading = 'N'
  end

  def receive(command)
    control_unit.execute_command(command)
  end

  def report_manual
    control_unit.report_manual
  end

  def report_position
    report do
      puts "X: #{x}"
      puts "Y: #{y}"
      puts "Heading: #{heading}"
    end
  end

  def <=>(other)
    id <=> other.id
  end

  def report
    puts "##### Rover ##{id} speaking #####"
    yield
    puts '####################'
  end
end
