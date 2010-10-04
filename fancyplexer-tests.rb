require 'fancyplexer'

m = Fancyplexer.new('fancy 2.wav', :outputs => 2)
m.world do
  set -0.5, +0.5
  
  set +0.5, -0.5
  hold 1.0
  set -0.5, +0.5
  hold 1.0
end

m = Fancyplexer.new('fancy-centred-test.wav', :outputs => 3)
m.world do
  set -1.0, 0.0, +1.0
  hold 10.0
end

m = Fancyplexer.new('fancytweened 5.wav', :outputs => 5)
m.world do
  set -1, -1, -1, -1, -1
  tween +1, +1, +1, +1, +1, :transition => :sine
  tween -1, -1, -1, -1, -1, :transition => :sine
end

m = Fancyplexer.new('fancytweened 1.wav', :outputs => 1)
m.world do
  set -1.0
  tween 1.0, :transition => :sine
  tween -1.0, :transition => :sine
end
