require 'rubygems'
require 'ruby-audio'
require 'servo-animation'

# Should make servo go all the way left, then all the way right, then go limp for one second!
class Wiggle < ServoAnimation
  set -1.0
  wait 2.0
  
  set 0.0
  wait 1.0
  
  set +1.0
  wait 2.0
  
  #limp 1.0
end

# Sways side to side in a sine wave motion
class Sway < ServoAnimation
  self.polarity = :positive
  angles = (0..360).to_a.select { |i| i % 2 == 0 }.map { |n| (n.to_f / 180) * Math::PI }
  angles.each do |angle|
    set Math.sin(angle)
    wait 0.01
  end
end

class SwayTheOtherWay < ServoAnimation
  self.polarity = :negative
  angles = (0..360).to_a.select { |i| i % 2 == 0 }.map { |n| (n.to_f / 180) * Math::PI }
  angles.each do |angle|
    set Math.sin(angle)
    wait 0.01
  end
end


