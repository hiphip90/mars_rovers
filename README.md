# Mars Rovers Simulator

## Usage
  Clone repo:
  `git clone git@github.com:hiphip90/mars_rovers.git`
  Start game:
  `cd mars_rovers`
  `ruby lib/game.rb`
  Follow instructions.

## Main screen commands
  `h` to list commands
  `deploy` to deploy new rover
  `list` to list currently deployed rovers
  `%rover_id%` to start comm session with selected rover

## Rover screen commands
  `h` to list rover commands
  `break` to quit to main screen
  `%x% %y% [%heading%]` to move rover to specified position
  `LMMR` or any other combination of `M` - move 1 tile forward, `L` - turn counterclockwise or `R` - turn clockwise

## Requirements
  Created, tested and supposed to run under Ruby 2.4.0
