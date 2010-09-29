PulseWidth is a collection of little ruby scripts for interfacing to RC Servos and related tech, for controlling animatronics using wav files and the likes, portably. 

## ServoAnimation class ##

This little class lets you write mono wav files, with an animation sequence, which will be encoded in to PWM codes, and saved as #{Class Name}.wav in the current directory, when you inherit a class from it. Check out servo-animation-samples.rb for a little demo. You can't make instances of these classes. They are fakey like that.

## FancyPlexer/FancyDeplexer ##

FancyPlexer is a little ruby class which implements PPM Multiplexing of a sort - where a run of pulses are sent to the µC and then a gap, and the gap signifies a reset, back to the first RC Servo. So it looks like this: -#-#-#-#---#-#-#-#---#-#-#-#---… It's a fairly standard protocol used in remote control gear, but I don't know yet how compatible this implementation is with anything other than FancyDeplexer. If you tweak the :low, :high, and :postgap settings, you should be able to make it work with any bit of gear so long as the voltage on your audio output is good enough for that device.

FancyDeplexer is a little Arduino sketch which decodes these runs of pulses and maps them out over all the pins on the chip. It uses the Analog Comparator feature, and is very much a work in progress. My intention is to keep it under 1kb so it could run on ATtiny13s and other tiny chips.


## License ##

All of this, the whole of it, is totally free to you. My wish is to spread infectious hacking smarts all over the world. And so [this] is yours forever at no cost: give it away, take it apart, learn-learn-learn without a second thought. — \_why
