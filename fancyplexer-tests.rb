require 'fancyplexer'

m = Fancyplexer.new('fancy 2.wav', :outputs => 2)
m.world do
  set -0.5, +0.5
  
  set +0.5, -0.5
  hold 1.0
  set -0.5, +0.5
  hold 1.0
end
m.close

m = Fancyplexer.new('fancytweened 5.wav', :outputs => 5)
m.world do
  tween +1, +1, +1, +1, +1
  tween -1, -1, -1, -1, -1
end

m = Fancyplexer.new('fancytweened 1.wav', :outputs => 1)
m.world do
  tween 1.0
  tween -1.0
end
