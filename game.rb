require_relative 'mission_control'

mission_control = MissionControl.new

puts '##### WELCOME TO MARS #####'
puts '##### Print "h" to get help #####'

loop do
  command = gets.chomp
  case command
  when 'h'
    puts '##### Available commands #####'
    puts "\th - show this message"
    puts "\tdeploy - send new rover to Mars"
    puts "\tlist - list rovers on Mars"
    puts "\t\%rover_id\% - open comm channel with specified rover"
    puts '##############################'
  when 'deploy'
    mission_control.deploy_new_rover
  when 'list'
    mission_control.list_rovers
  when /\A\d+\z/
    if mission_control.open_comm_channel_with_rover(command.to_i)
      puts '##### Print instructions to send #####'
      instructions = gets.chomp
      case instructions
      when 'h'
        puts '##### Available rover commands #####'
        puts "\th - show this message"
        puts "\tL - turn counterclockwise. Can be combined with R, M in one instruction"
        puts "\tR - turn clockwise. Can be combined with L, M in one instruction"
        puts "\tM - move ahead. Can be combined with L, R in one instruction"
        puts "\t\%X\% \%Y\% [\%heading\%] - go to coordinates. Heading is optional. If heading is present (must be one of N, E, S, W) will change heading, otherwise keep current heading"
        puts '##############################'
      else
        mission_control.send_instructions_to_rover(command.to_i, instructions)
      end
    else
      puts 'This rover does not exist! Please select existing rover, or deploy a new one via deploy_rover.'
      mission_control.list_rovers
    end
  else
    puts 'Unknown command'
  end
end
