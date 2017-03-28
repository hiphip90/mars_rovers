require_relative 'mission_control'
require_relative 'rover/factory'

class Game
  attr_reader :mission_control

  def initialize
    @mission_control = MissionControl.new
    rover_factory = Rover::Factory.new(mission_control)
    mission_control.rover_factory = rover_factory
  end

  def start
    puts '##### WELCOME TO MARS #####'
    puts '##### Print "h" to get help #####'
    main_loop
  end

  private

  def main_loop
    loop do
      command = gets.chomp
      case command
      when 'h'
        print_help_message
      when 'deploy'
        mission_control.deploy_new_rover
      when 'list'
        mission_control.list_rovers
      when /\A\d+\z/
        rover_id = command.to_i
        if mission_control.open_comm_channel_with_rover(rover_id)
          talk_to_rover_loop(rover_id)
        else
          puts 'This rover does not exist! Please select existing rover, or deploy a new one via deploy command'
          mission_control.list_rovers
        end
      else
        puts 'Unknown command'
      end
    end
  end

  def print_help_message
    puts
    puts '##### Available commands #####'
    puts "h - show this message"
    puts "deploy - send new rover to Mars"
    puts "list - list rovers on Mars"
    puts "\%rover_id\% - open comm channel with specified rover"
    puts '##############################'
    puts
  end

  def print_rover_help_message(rover_id)
    puts
    puts '##### Available rover commands #####'
    puts "h - show this message"
    puts "break - disconnect from rover"
    puts mission_control.report_rover_manual(rover_id)
    puts '##############################'
    puts
  end

  def talk_to_rover_loop(rover_id)
    system "clear" or system "cls"
    puts '##### Print commands to send to rover. Print "h" for list of valid commands #####'
    loop do
      command = gets.chomp
      case command
      when 'h'
        print_rover_help_message(rover_id)
      when 'break'
        puts '##### Disconnected from rover, back to mission control #####'
        break
      else
        mission_control.send_command_to_rover(rover_id, command)
      end
      mission_control.report_rover_position(rover_id)
    end
  end
end

Game.new.start
