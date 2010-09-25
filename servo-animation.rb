require 'ruby-audio'
# You'll need to install the ruby-audio gem, and the libsndfile audio file writing C library somehow!

# Info at http://www.horrorseek.com/home/halloween/wolfstone/Motors/svoint_RCServos.html
class ServoAnimation
  SampleRate = 48000 # samples per second
  RePulse = 50 # hertz
  CentreWidth = 1.5 # mSec
  ScaleWidth = 1.0 # mSec, 0.6 is a safe starting point, but many servos can go much further! 
  PulseEvery = SampleRate / RePulse
  DefaultWait = 0.5
  
  def self.polarity= polarity
    raise "Polarity needs to be :positive or :negative" unless polarity == :positive or polarity == :negative
    @polarity = polarity
  end
  
  def self.inherited stay_classy; stay_classy.begin; end
  
  def self.begin;
    @file = "#{self.name}.wav"
    @info = RubyAudio::SoundInfo.new :channels => 1, :samplerate => SampleRate, :format => RubyAudio::FORMAT_WAV|RubyAudio::FORMAT_PCM_16
    @snd = RubyAudio::Sound.open(@file, 'w', @info)
    @angle = 0
    @polarity = :positive
  end
  
  # Stop sending commands, letting the servo go limp, for a duration
  def self.limp seconds = DefaultWait
    @angle = nil
    buffer = RubyAudio::Buffer.new('float', PulseEvery)
    buffer.size.times { |i| buffer[i] = 0.0 }
    
    (seconds * RePulse.to_f).round.times do
      @snd.write buffer
    end
  end
  
  # Wait for a duration, holding the servo at the current angle (or limp if no angle set yet)
  def self.wait seconds = DefaultWait
    return self.limp(seconds) unless @angle
    
    buffer = RubyAudio::Buffer.new('float', PulseEvery)
    threshold = (CentreWidth + (ScaleWidth * @angle)) * 0.001 * SampleRate
    #puts "On for #{(((threshold.to_f / SampleRate.to_f) * 100 * 1000).round.to_f / 100)}ms"
    polarity_table = {:positive => +1.0, :negative => -1.0, :no_sound => 0}
    puts "The um, polarity of #{self.name} is #{polarity_table[@polarity]}"
    
    buffer.size.times do |i|
      if i < threshold
        buffer[i] = polarity_table[@polarity]
      else
        buffer[i] = polarity_table[:no_sound]
      end
      
    end
    
    (seconds * RePulse.to_f).round.times do
      @snd.write buffer
    end
  end
  
  def self.set angle
    raise "Angle #{angle} is not within -1.0 - +1.0! No good! DEATH! RIGHT NOW!" if angle > 1.0 || angle < -1.0
    @angle = angle
  end
end
