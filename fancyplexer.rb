#               -=- Fancyplexer -=-
# This little doodad makes audio files which a tiny
# microcontroller can split up and route to a bunch
#      of servos, for making animatronic hats.
#
# Hope it's useful!
#                                        <3 Bluebie

require 'rubygems'
require 'ruby-audio'

class Fancyplexer
  DefaultOptions = {
    :sample_rate => 48000, # Samples Per Second
    :max_angle => 1.0, # Maximum angle possible, and also, -this is the minimum, 0.0 is centered.
    :outputs => 1, # Channels to write
    :gap => 0.0005, # Leaves a little dead gap after each PPM signal
    :postgap => 0.002, # gap to leave after the run of PPM signals
    :high => -1.0,
    :low => +1.0,
    :left => 0.001, # seconds; These numbers define the pulse widths
    :right => 0.002, # seconds
  }
  
  def initialize filename, options = {}
    @file = "#{filename}"
    DefaultOptions.merge(options).each do |key, value|
     self.instance_variable_set "@#{key}", value
    end

    @info = RubyAudio::SoundInfo.new :channels => 1, :samplerate => @sample_rate, :format => RubyAudio::FORMAT_WAV|RubyAudio::FORMAT_PCM_16
    @snd = RubyAudio::Sound.open(@file, 'w', @info)
    @angles = Array.new(@outputs, 0.0)
    
    # make our little postgap buffer to go after each run of pulses
    @postgap_buffer = new_pulse_buffer(@postgap)
    set_buffer @postgap_buffer, @low
  end

  # set the positions
  def set *angles
    angles.each_with_index do |val, idx|
     @angles[idx] = val;
    end
  end

  # go to and hold at the currently set positions for a duration (default: smallest possible moment)
  def hold duration = 0.0
    buffer = new_pulse_buffer
    frame_width = buffer.size * (@outputs + 1)
    [duration.to_f * @sample_rate.to_f / frame_width, 1].max.round.times do
      @angles.each do |angle|
        set_buffer buffer, @low
        set_buffer buffer, @high, angle_becomes_width(angle) * @sample_rate
        @snd.write buffer
      end
      
      # add our postgap so the reciever can reset itself
      @snd.write @postgap_buffer
    end
  end
  
  # transition from current values to a set of values, linearly, or otherwise
  # to make a tweener block, first is the from angle, second argument is the to
  # value, and the third is 'time', which is between 0.0 and 1.0, relative to the
  # duration, so imagine it as a relative position within the animation.
  def tween future, duration = 1.0, &tweener
    tweener ||= proc do |from, to, time|
     add = to.to_f - from.to_f
     from.to_f + (add * time)
    end
    
    # TODO: Write this!
    from = @angles.dup
    frames = [duration.to_f * @sample_rate / frame_width, 1].max.round
    frames.times do |frame|
     angles = Array.new(@outputs, 0.0)
     @outputs.times { |idx| angles[idx] = tweener[from[idx], (future[idx] || from[idx]).to_f, frame.to_f / frames.to_f] }
     set *angles
     hold
    end
    # TODONE: This!
  end
  
  # creates a little world made of sunshine and lollipops!
  def world &country; self.instance_exec &country; end
  def close; @snd.close; end
  
  private
  # FEED ME FLOATS! :O :| :O :| :O :|
  def map number, left, right, future_left, future_right
    floaty = (number - left) / (right - left)
    future_left + ((future_right - future_left) * floaty)
  end
  
  # makes pulse widths!
  def angle_becomes_width angle
    map angle.to_f, -@max_angle.to_f, @max_angle.to_f, @left.to_f, @right.to_f
  end
  
  # makes a little pulse buffer
  def new_pulse_buffer(length = false)
    RubyAudio::Buffer.new('float', length ? length * @sample_rate : pulse_width)
  end
  
  # set a given width of buffer to a value
  def set_buffer buffer, value, width = :all
    (width == :all ? buffer.size : width.to_i).times do |idx|
      buffer[idx] = value
    end
  end
  
  def pulse_width; (@right + @gap).to_f * @sample_rate.to_f; end
  def frame_width; pulse_width * (@outputs + 1); end
end
